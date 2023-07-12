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
#include "matrix.cuh"

__device__ __host__ matrix<2, 1> operator/(const matrix<2, 2> &A, const matrix<2, 1> &b)
{
    float y = (b(1, 0) - A(1, 0) * b(0, 0) / A(0, 0)) /
        (A(1, 1) - A(1, 0) * A(0, 1) / A(0, 0));
    float x = (b(0, 0) - A(0, 1) * y) / A(0, 0);
    return colVec(x, y);
}
