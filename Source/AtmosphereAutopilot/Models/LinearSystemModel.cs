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

	You should have received a copy of the GNU General Public License 3.0 along
	with Atmosphere Autopilot /L Unleashed. If not, see <https://www.gnu.org/licenses/>.

*/
namespace AtmosphereAutopilot
{
    public struct LinearSystemModel
    {
        public readonly int state_count, input_count;

        public readonly Matrix A, B, C;

        public LinearSystemModel(int state_count, int input_count)
        {
            this.state_count = state_count;
            this.input_count = input_count;
            A = new Matrix(state_count, state_count);
            B = new Matrix(state_count, input_count);
            C = new Matrix(state_count, 1);
            Ax = Bu = AxBu = null;
        }

        public LinearSystemModel(LinearSystemModel original)
        {
            state_count = original.state_count;
            input_count = original.input_count;
            A = original.A.Duplicate();
            B = original.B.Duplicate();
            C = original.C.Duplicate();
            Ax = Bu = AxBu = null;
        }

        Matrix Ax;
        Matrix Bu;
        Matrix AxBu;

        public void eval(Matrix state, Matrix input, ref Matrix state_deriv)
        {
            Matrix.Multiply(A, state, ref Ax);
            Matrix.Multiply(B, input, ref Bu);
            Matrix.Add(Ax, Bu, ref AxBu);
            Matrix.Add(AxBu, C, ref state_deriv);
        }

        public double eval_row(int row, Matrix state, Matrix input)
        {
            double res = 0.0;
            for (int i = 0; i < A.cols; i++)
                res += A[row, i] * state[i, 0];
            for (int i = 0; i < B.cols; i++)
                res += B[row, i] * input[i, 0];
            res += C[row, 0];
            return res;
        }
    }
}
