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
#include "AAGpu.h"

std::vector<pitch_model_params> generate_corpus(
    const pitch_model_params &base_model,
    int moi_steps,
    float moi_min,
    float moi_max,
    int t_ratio_steps,
    float ratio_min,
    float ratio_max,
    int cl2_steps,
    float cl2_min,
    float cl2_max)
{
    std::vector<pitch_model_params> output;
    for (int i = 0; i < moi_steps; i++)
        for (int j = 0; j < t_ratio_steps; j++)
            for (int k = 0; k < cl2_steps; k++)
            {
                float moi = moi_min + i * (moi_max - moi_min) /
                    (float)(moi_steps - 1);
                float ratio = ratio_min + j * (ratio_max - ratio_min) /
                    (float)(t_ratio_steps - 1);
                float cl2 = cl2_min + k * (cl2_max - cl2_min) /
                    (float)(cl2_steps - 1);
                pitch_model_params model = base_model;
                model.moi = moi;
                model.rot_model[1] = ratio * model.rot_model[2];
                model.lift_model[2] = cl2;
                output.push_back(model);
            }
    return output;
}
