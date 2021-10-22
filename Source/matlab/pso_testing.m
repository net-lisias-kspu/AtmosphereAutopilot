%{
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
    warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    You should have received a copy of the GNU General Public License 3.0
    Atmosphere Autopilot /L Unleashed. If not, see <https://www.gnu.org/licenses/>.

}%
%sqr_func = @(x) sum(x.^2);
%[val, point] = PSO(sqr_func, [-2.0, -4.0; 3.0, 1.0], 10, 0.6, 0.5, 0.5, 100, true);
[val, point] = PSO(@aoa_objective_function, [0.0, 0.0; 10.0, 0.5], 10000, 0.6, 1.0, 1.0, 1, true);
