#ifndef REMOTE_CONTROLS_H_
#define REMOTE_CONTROLS_H_

#include <pwm_input.h>

struct PWMInput* throttle;
struct PWMInput* rudder;
struct PWMInput* airleron;
struct PWMInput* elevator;

void InitialiseRemoteControls();

/* These will come back as a percentage */
float ReadRemoteThrottle();

float ReadRemoteRudder();

float ReadRemoteAirleron();

float ReadRemoteElevator();



#endif