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
%% data
delta_time = 0.025;
run('import_telemetry');
%% plot

scrsz = get(0,'ScreenSize');
figure('Name','Telemetry Plotter',...
    'Position',[100 50 scrsz(3)*0.9 scrsz(4)*0.8])
hold on
plot(time, 1.0 .* acc,'r','Marker','.','MarkerSize',5)
plot(time, 1.0 .* predict,'r-.')
plot(time, 1.0 * control,'k','Marker','.','MarkerSize',5)
plot(time, 1.0 * output,'k:','Marker','.','MarkerSize',5)
plot(time, 1.0 .* aoa,'b','Marker','.','MarkerSize',5)
plot(time, 5.0 .* v,'g')
hold off
xlabel('time')
legend('acc','predict','csurf','control','aoa','v');
h = gca;
set(h, 'Position', [0.025 0.06 0.96 0.92]);
