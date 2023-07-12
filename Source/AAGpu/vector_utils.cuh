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

#include "vector_functions.h"
#include <array>

#define __VECTOR_UTILS_DECL__ inline __device__ __host__

__VECTOR_UTILS_DECL__ float2 operator *(const float2 &lhs, const float2 &rhs)
{
    return make_float2(lhs.x * rhs.x, lhs.y * rhs.y);
}

__VECTOR_UTILS_DECL__ float3 operator *(const float3 &lhs, const float3 &rhs)
{
    return make_float3(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z);
}

__VECTOR_UTILS_DECL__ float2 operator +(const float2 &lhs, const float2 &rhs)
{
    return make_float2(lhs.x + rhs.x, lhs.y + rhs.y);
}

__VECTOR_UTILS_DECL__ float2 operator -(const float2 &lhs, const float2 &rhs)
{
    return make_float2(lhs.x - rhs.x, lhs.y - rhs.y);
}

__VECTOR_UTILS_DECL__ float2 operator *(const float2 &lhs, float rhs)
{
    return make_float2(lhs.x * rhs, lhs.y * rhs);
}

__VECTOR_UTILS_DECL__ float2 operator *(float lhs, const float2 &rhs)
{
    return make_float2(lhs * rhs.x, lhs * rhs.y);
}

__VECTOR_UTILS_DECL__ float2 operator /(const float2 &lhs, float rhs)
{
    return make_float2(lhs.x / rhs, lhs.y / rhs);
}

__VECTOR_UTILS_DECL__ float2 operator -(const float2 &rhs)
{
    return make_float2(-rhs.x, -rhs.y);
}

__VECTOR_UTILS_DECL__ float dot(const float3 &lhs, const float3 &rhs)
{
    return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z;
}

__VECTOR_UTILS_DECL__ float dot(const float2 &lhs, const float2 &rhs)
{
    return lhs.x * rhs.x + lhs.y * rhs.y;
}

__VECTOR_UTILS_DECL__ float magn(const float2 &vec)
{
    return sqrtf(dot(vec, vec));
}

__VECTOR_UTILS_DECL__ float2 normalize(const float2 &vec)
{
    float norm = magn(vec);
    return make_float2(vec.x / norm, vec.y / norm);
}

__VECTOR_UTILS_DECL__ float hypercross(const float2 &lhs, const float2 &rhs)
{
    return lhs.x * rhs.y - lhs.y * rhs.x;
}

#define float2_zero make_float2(0.0f, 0.0f)
#define float3_zero make_float3(0.0f, 0.0f, 0.0f)
#define float4_zero make_float3(0.0f, 0.0f, 0.0f, 0.0f)

inline __host__ float3 make_float3(const std::array<float, 3> &arr)
{
    return make_float3(arr[0], arr[1], arr[2]);
}

inline __host__ float2 make_float2(const std::array<float, 2> &arr)
{
    return make_float2(arr[0], arr[1]);
}