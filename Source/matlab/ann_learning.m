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
%% prepare
run('import_telemetry.m');

%% plot
nn_inputs = [aoa; control];
nn_outputs = acc;
plot(time, acc, 'r')
hold on
plot(time, nn_outputs, 'r:')
plot(time, myNeuralNetworkFunction(nn_inputs), 'b')
hold off
xlabel('time')
legend('acc','smoothed acc','ann acc');
%% plot control sensitivity
figure('Name','control sensitivity')
plot(linspace(-1,1,99), myNeuralNetworkFunction([zeros(1,99);linspace(-1,1,99)]));
xlabel('control');
ylabel('acc');
%% plot aoa sensitivity
figure('Name','aoa sensitivity')
plot(linspace(-0.25,0.25,99), myNeuralNetworkFunction([linspace(-0.25,0.25,99); zeros(1,99)]));
xlabel('aoa');
ylabel('acc');
