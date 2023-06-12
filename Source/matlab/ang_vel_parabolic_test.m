%{
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
    warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    You should have received a copy of the GNU General Public License 3.0
    Atmosphere Autopilot /L Unleashed. If not, see <https://www.gnu.org/licenses/>.

}%
x = linspace(-0.1, 1.0, 500);
k = -1.0;
d = -0.01;
dt = 0.025;
v_error = -0.1;

casat = d .* x;

b_s = 2.0 * k * dt + d;
a_s = k;
c_s = k * dt * dt + d * d / 4.0 / k - v_error;
D_s = b_s * b_s - 4.0 * a_s * c_s;
s1 = (-b_s + sqrt(D_s)) / 2.0 / a_s;
s2 = (-b_s - sqrt(D_s)) / 2.0 / a_s;
s = max(s1, s2);
b = d * s + d * d / 4.0 /  k;
parab = k .* (x - s) .^ 2 + b;

plot(x, casat);
hold on
plot(x, parab);

((k * s * s + b) - v_error) / dt
k * (-dt - s)^2 + b
