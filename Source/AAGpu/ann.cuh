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

#include "matrix.cuh"
#include <math.h>

template <unsigned Inputs, unsigned Neurons, unsigned Outputs> struct ann
{
    const static unsigned Pars = (1 + Inputs) * Neurons + Outputs * (1 + Neurons);

    matrix<Neurons, Inputs> weights1;
    matrix<Neurons, 1> biases1;
    matrix<Outputs, Neurons> weights2;
    matrix<Outputs, 1> biases2;

    matrix<Inputs, 2> input_norm;
    matrix<Outputs, 2> output_norm;

    __device__ __host__ void init(const matrix<Pars, 1> &pars)
    {
        int i = 0;
        for (int j = 0; j < Neurons * Inputs; j++)
            weights1.data[j] = pars.data[i++];
        for (int j = 0; j < Neurons; j++)
            biases1.data[j] = pars.data[i++];
        for (int j = 0; j < Outputs * Neurons; j++)
            weights2.data[j] = pars.data[i++];
        for (int j = 0; j < Outputs; j++)
            biases2.data[j] = pars.data[i++];
    }

    __device__ __host__ matrix<Outputs, 1> eval(const matrix<Inputs, 1> &input)
    {
        // first normalize
        matrix<Inputs, 1> ninput;
        for (int i = 0; i < Inputs; i++)
            ninput(i, 0) = 2.0f * (input(i, 0) - 0.5f * (input_norm(i, 0) +
                input_norm(i, 1))) / (input_norm(i, 1) - input_norm(i, 0));

        // eval
        auto net1 = weights1 * ninput + biases1;

        // apply tansig
        for (int i = 0; i < Neurons; i++)
            net1(i, 0) = tanhf(net1(i, 0));

        // eval 2nd layer
        auto net2 = weights2 * net1 + biases2;

        // denormalize output
        for (int i = 0; i < Outputs; i++)
            net2(i, 0) = 0.5f * (net2(i, 0) * (output_norm(i, 1) - output_norm(i, 0)) +
                (output_norm(i, 1) + output_norm(i, 0)));

        return net2;
    }
};
