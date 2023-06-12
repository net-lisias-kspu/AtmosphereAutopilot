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
%%
x = 0:0.25:30.0;
y = 1.0 ./ (x * 0.5 + 1.0);
plot(x, y)
%%
w_min = 0.02;
ans = (1.0 - w_min) / (w_min * 5.0)
%%
x = 0:0.1:30.0;
y = 1.0 ./ exp(x * 0.2);
plot(x, y)
%%
x = -5:0.05:5;
y = tansig(x);
plot(x, y);
%%
x = 0:0.01:0.5;
y = 0.2 * exp(x * -8.0);
z = zeros(1, length(x));
z(1) = 0.2;
for j = 2:length(x)
    z(j) = (1 - 0.2 / dt * 0.01) * z(j-1);
end
plot(x, y)
hold on
plot(x, z, 'r')
