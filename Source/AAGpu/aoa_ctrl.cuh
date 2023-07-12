/*
	This file is part of Atmosphere Autopilot /L Unleashed
		© 2018-2023 Lisias T : http://lisias.net <support@lisias.net>
		© 2015-2020 Baranin Alexander aka Boris-Barboris

	Atmosphere Autopilot /L Unleashed is licensed as follows:
		* GPL 3.0 : https://www.gnu.org/licenses/gpl-3.0.txt

	Atmosphere Autopilot /L Unleashed is free software: you can redistribute
	it and/or modify it under the terms of the GNU General Public License as
	published by the Free Software Foundation, either version 3 of the License,
	or (at your option) any later version.

	Atmosphere Autopilot /L Unleashed is distributed in the hope that
	it will be useful, but WITHOUT ANY WARRANTY; without even the implied
	warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

	You should have received a copy of the GNU General Public License 3.0
	Atmosphere Autopilot /L Unleashed. If not, see <https://www.gnu.org/licenses/>.

*/
#pragma once

#include "aircraftmodel.cuh"
#include "ang_vel_pitch.cuh"
//#include "ann.cuh"
#include "aoa_ctrl_constants.h"

// Pitch AoA controller
struct aoa_ctrl
{
    // tunable parameters
    matrix<AOALINPARAMS, 1> params;

    // state
    float output_vel;
    float output_acc;
    float predicted_aoa;
    float predicted_eq_v;
    float predicted_output;
    float target_aoa;
    float cur_aoa_equilibr;     // equilibrium angular velocity to stay on current AoA

    bool already_preupdated;

    // Initializer
    inline __device__ __host__ void zero_init()
    {
        params = matrix<AOALINPARAMS, 1>();
        output_vel = 0.0;
        output_acc = 0.0;
        predicted_aoa = 0.0;
        predicted_eq_v = 0.0;
        predicted_output = 0.0;
        target_aoa = 0.0;
        cur_aoa_equilibr = 0.0;
        already_preupdated = false;
    }

    __device__ __host__ float eval(pitch_model *mdl, ang_vel_p *vel_c, float target,
        float target_deriv, float dt);
    __device__ __host__ void preupdate(pitch_model *mdl);
    __device__ __host__ static matrix<2, 1> get_equlibr(pitch_model *mdl, float aoa);

private:
    __device__ __host__ void update_pars(pitch_model *mdl);
    /*__device__ __host__ float get_output(ang_vel_p *vel_c, float cur_aoa,
        float des_aoa, float dt);*/
    __device__ __host__ float aoa_dyn_inverse(pitch_model *mdl, float des_aoa, float dt);
};
