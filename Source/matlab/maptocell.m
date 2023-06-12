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
function [coord, cell_center] = maptocell(value, lower, upper, dims)
    span = upper - lower;
    cell_size = span ./ double(dims - 1);
    coord = floor((value - lower + (cell_size ./ 2.0)) ./ cell_size);
    coord = int16(clamp_index(coord, dims));
    cell_center = lower + double(coord) .* cell_size;
end

function cindex = clamp_index(index, limits)
    cindex = index;
    for i = 1:length(index)
        if cindex(i) < int16(0)
            cindex(i) = int16(0);
        elseif cindex(i) >= limits(i)
            cindex(i) = limits(i) - 1;
        end
    end
end

