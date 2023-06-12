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
classdef ang_acc_controller < handle

    properties (SetAccess = public)
        model;                      % aircraft_model instance
        axis = 0;                   % 0 - pitch 1 - roll 2 - yaw
        target_acc = 0.0;
        predicted_acc = 0.0;
        output_control = 0.0;
    end

    methods (Access = public)
        function c = ang_acc_controller(m)
            c.model = m;
        end
    end
end

