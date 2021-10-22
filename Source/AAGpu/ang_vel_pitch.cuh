/*
	This file is part of Atmosphere Autopilot /L Unleashed
	© 2018-21 Lisias T : http://lisias.net <support@lisias.net>
	© 2015-20 Baranin Alexander aka Boris-Barboris

	Atmosphere Autopilot /L Unleashed is licensed as follows:

	* GPL 3.0 : https://www.gnu.org/licenses/gpl-3.0.txt
		or, at your option, any later version

	Atmosphere Autopilot /L Unleashed is free software: you can redistribute
	it and/or modify it under the terms of the GNU General Public License as
	published by the Free Software Foundation, either version 3 of the License,
	or (at your option) any later version.

	Atmosphere Autopilot /L Unleashed is distributed in the hope that
	it will be useful, but WITHOUT ANY WARRANTY; without even the implied
	warranty of	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

	You should have received a copy of the GNU General Public License 3.0
	Atmosphere Autopilot /L Unleashed. If not, see <https://www.gnu.org/licenses/>.

*/
#pragma once

#include "aircraftmodel.cuh"

// Pitch ang vel controller
struct ang_vel_p
{
    // tunable parameters
    float max_v_construction;
    float max_aoa;
    //float max_g;
    float quadr_Kp;

    bool moderate_aoa;
    //bool moderate_g;
    bool stable;
    bool already_preupdated;

    float res_max_aoa;
    float res_min_aoa;
    float res_equilibr_v_upper;
    float res_equilibr_v_lower;
    float max_input_aoa;
    float min_input_aoa;
    float max_input_v;
    float min_input_v;
    // note g-force moderation is omitted for performace reasons
    //float max_g_aoa;
    //float min_g_aoa;
    //float max_g_v;
    //float min_g_v;
    float max_aoa_v;
    float min_aoa_v;

    float kacc_quadr;

    float target_vel;

    // Initializer
    inline __device__ __host__ void zero_init()
    {
        max_v_construction = 0.0f;
        max_aoa = 0.0f;
        quadr_Kp = 0.0f;
        moderate_aoa = false;
        stable = false;
        already_preupdated = false;
        res_max_aoa = 0.0f;
        res_min_aoa = 0.0f;
        res_equilibr_v_upper = 0.0f;
        res_equilibr_v_lower = 0.0f;
        max_input_aoa = 0.0f;
        min_input_aoa = 0.0f;
        max_input_v = 0.0f;
        min_input_v = 0.0f;
        max_aoa_v = 0.0f;
        min_aoa_v = 0.0f;
        kacc_quadr = 0.0f;
        target_vel = 0.0f;
    }

    __device__ __host__ float eval(pitch_model *mdl, float target, float target_deriv, float dt);
    __device__ __host__ void preupdatev(pitch_model *mdl);
};
