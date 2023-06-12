/*
	This file is part of Atmosphere Autopilot /L Unleashed
	© 2018-2023 Lisias T : http://lisias.net <support@lisias.net>
	© 2015-2020 Baranin Alexander aka Boris-Barboris

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

#include <array>
#include <vector>

#include "aoa_ctrl_constants.h"

#ifdef AAGPU_EXPORTS
#define AAGPU_EXPORTS_API __declspec(dllexport)
#else
#define AAGPU_EXPORTS_API __declspec(dllimport)
#endif

// Raw model evaluation without controllers

typedef void raw_prototype(
    float dt,
    int step_count,
    float moi,
    float mass,
    float sas,
    const std::array<float, 3> &rot_model,
    const std::array<float, 3> &lift_model,
    const std::array<float, 2> &drag_model,
    bool aero_model,
    float start_vel,
    bool keep_speed,
    float input,
    std::vector<float> &out_angvel,
    std::vector<float> &out_aoa,
    std::vector<float> &out_acc,
    std::vector<float> &out_csurf,
    std::vector<float> &out_input);

AAGPU_EXPORTS_API raw_prototype raw_execute;

AAGPU_EXPORTS_API raw_prototype raw_execute_cpu;


// Evaluation under control of AoA controller

typedef void aoa_eval_prototype(
    float dt,
    int step_count,
    float moi,
    float mass,
    float sas,
    const std::array<float, 3> &rot_model,
    const std::array<float, 3> &lift_model,
    const std::array<float, 2> &drag_model,
    bool aero_model,
    float start_vel,
    float start_aoa,
    bool keep_speed,
    float target_aoa,
    const std::array<float, AOALINPARAMS> &aoa_params,
    std::vector<float> &out_angvel,
    std::vector<float> &out_aoa,
    std::vector<float> &out_acc,
    std::vector<float> &out_csurf,
    std::vector<float> &out_input,
    std::vector<float> &out_vel_output);

AAGPU_EXPORTS_API aoa_eval_prototype aoa_execute;

AAGPU_EXPORTS_API aoa_eval_prototype aoa_execute_cpu;


// AoA PSO corpus optimization

struct pitch_model_params
{
    float moi;
    float mass;
    float sas;
    std::array<float, 3> rot_model;
    std::array<float, 3> lift_model;
    std::array<float, 2> drag_model;
};

AAGPU_EXPORTS_API std::vector<pitch_model_params> generate_corpus(
    const pitch_model_params &base_model,
    int moi_steps,
    float moi_min,
    float moi_max,
    int t_ratio_steps,
    float ratio_min,
    float ratio_max,
    int cl2_steps,
    float cl2_min,
    float cl2_max);

typedef void (__stdcall *report_dlg)(int epoch, float value, std::array<float, AOALINPARAMS> params);

#define PARTICLEBLOCK 256

AAGPU_EXPORTS_API bool start_aoa_pso(
    float dt,
    int step_count,
    const pitch_model_params &model_params,
    bool aero_model,
    float start_vel,
    bool keep_speed,
    int prtcl_blocks,
    float w,
    float c1,
    float c2,
    float initial_span,
    int aoa_divisions,
    const std::array<float, 4> &exper_weights,
    report_dlg repotrer,
    int iter_limit = 10000);

AAGPU_EXPORTS_API void stop_aoa_pso();
