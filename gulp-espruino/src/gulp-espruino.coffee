attachedDevices = require('serialport')
SerialPort = attachedDevices.SerialPort
through = require 'through2'
extend = require 'extend'
_ = require 'underscore'
Q = require 'q'
PluginError = require('gulp-util').PluginError;

createOutput = ->
  consumed = ''

  append: (content) -> consumed += content
  all: -> consumed

createPublisher = (readableStream, readableStreamDone) ->
  published = false

  content: (content) ->
    if !published
      published = true
      readableStream.push(content)
      readableStreamDone()

  error: (error) ->
    if !published
      published = true
      readableStream.push(null)
      readableStreamDone(error)

createTimer = (timeoutInMillis, done) ->
  timeout = null

  ->
    clearTimeout(timeout)
    timeout = setTimeout(done, timeoutInMillis)

createEspruino = (config) ->
  output = createOutput()
  commandExecuted = Q.defer()
  connected = Q.defer()
  finishCommand = createTimer(config.idleReadTimeBeforeClose, -> commandExecuted.resolve())

  connect: ->
    connectToSerialPort = (port) ->
      serialPort = new SerialPort(port, { baudrate: 9600 }, false)

      serialPort.on 'data', (data) ->
        output.append(data.toString())
        finishCommand()

      serialPort.open -> connected.resolve(serialPort)

    if !config.port && !config.serialNumber
      connected.reject('Espruino port or serial number is not specified. Barfing.')
      return connected.promise

    if config.port
      connectToSerialPort(config.port)

    if !config.port && config.serialNumber
      attachedDevices.list (error, ports) ->
        if error
          connected.reject("Failed to find attached serial devices. Error is #{error}. Barfing.")
          return connected.promise

        espruinoPort = _.find(ports, (port) -> port.serialNumber == config.serialNumber)

        if !espruinoPort
          connected.reject("Espruino with serial number '#{config.serialNumber}' not found. Barfing. We did find these ports: #{JSON.stringify(ports)}.")
          return connected.promise

        connectToSerialPort(espruinoPort.comName)

    connected.promise

  close: ->
    closed = Q.defer()
    connected.promise.then((serialPort) -> serialPort.close(-> closed.resolve()))
    closed.promise
  log: -> output.all()
  send: (command, onError) ->
    connected.promise.then (serialPort) ->
      serialPort.on('error', onError)
      commandExecuted = Q.defer()
      serialPort.write command, (error) -> onError(error) if error
      commandExecuted.promise

module.exports =
  deploy: (options = {}) ->
    defaults =
      echoOff: true
      idleReadTimeBeforeClose: 1000
      reset: true
      save: true

    config = extend({}, defaults, options)
    espruino = createEspruino(config)

    through.obj (chunk, encoding, callback) ->
      publish = createPublisher(@, callback)
      onError = (error) -> publish.error(error)

      espruino.connect()
         .then(-> espruino.send("reset();\n", onError) if config.reset)
         .then(-> espruino.send("echo(0);\n", onError) if config.echoOff)
         .then(-> espruino.send("{ #{chunk.contents.toString()} }\n", onError))
         .then(-> espruino.send("echo(1);\n", onError) if config.echoOff)
         .then(-> espruino.send("save();\n", onError) if config.save)
         .then(-> publish.content(espruino.log()))
         .fail((error) -> publish.error(error))
         .finally(-> espruino.close())
         .done()

# Todo.
# blow up if not stream
# add in hook to finish stream slurp whenever you want
# reject promise on error
# add timeout to promise chain
