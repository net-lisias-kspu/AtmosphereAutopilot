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
%% import time series with removed delays
ksp_plots_path ='D:\Games\Kerbal Space Program 1.1\Resources\';

acc = csvread([ksp_plots_path, 'acc.csv']);
control = csvread([ksp_plots_path, 'control.csv']);
output = [0.0,csvread([ksp_plots_path, 'output.csv'])];
aoa = csvread([ksp_plots_path, 'aoa.csv']);
v = csvread([ksp_plots_path, 'v.csv']);
predict = [0.0,csvread([ksp_plots_path, 'predict.csv'])];
airspd = [0.0,csvread([ksp_plots_path, 'airspd.csv'])];
p = [0.0,csvread([ksp_plots_path, 'density.csv'])];

smoothed_acc = sgolayfilt(acc, 2, 11);

%% cut edges from telemetry and prepare time axis
max_length = max([length(acc), length(control), length(output), length(aoa),...
    length(v), length(airspd), length(p), length(predict)]);
if ~exist('delta_time', 'var')
    delta_time = 0.025;
end
time = 0:delta_time:(delta_time * (max_length - 6));

acc = [acc,zeros(1, max_length - length(acc))];
acc = acc(3:max_length - 3);
aoa = [aoa, zeros(1, max_length - length(aoa))];
aoa = aoa(3:max_length - 3);
control = [control, zeros(1,max_length - length(control))];
control = control(3:max_length - 3);
output = [output, zeros(1,max_length - length(output))];
output = output(3:max_length - 3);
v = [v,zeros(1, max_length - length(v))];
v = v(3:max_length - 3);
predict = [predict,zeros(1, max_length - length(predict))];
predict = predict(3:max_length - 3);
airspd = [airspd,zeros(1, max_length - length(airspd))];
airspd = airspd(3:max_length - 3);
p = [p,zeros(1, max_length - length(p))];
p = p(3:max_length - 3);

smoothed_acc = [smoothed_acc,zeros(1, max_length - length(smoothed_acc))];
smoothed_acc = smoothed_acc(3:max_length - 3);

series_length = length(acc);
