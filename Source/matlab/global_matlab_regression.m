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
%% prepare
run('import_telemetry.m');

%% regression

% initial values
k_aoa = 0.0;
b_aoa = 0.0;
k_input = 100.0;
moi = 58.0;

%% problem creation
lower_bound = [-Inf,-Inf,0.0];
upper_bound = [Inf,Inf,Inf];
start_point = [k_aoa,b_aoa,k_input];
problem = createOptimProblem('fmincon','x0',start_point,...
    'objective',@(x)error_function(x(1),x(2),x(3),moi,acc,aoa,control,1.0),...
    'lb',lower_bound,'ub',upper_bound);

%% solver creation
gs = GlobalSearch('MaxTime', 60);

%% run solver
[xmin,fming,flagg,outptg,manyminsg] = run(gs,problem)

%% get regressed signal
regressed_acc = angular_model(moi, xmin(1), xmin(2), aoa,...
        xmin(3), control);

%% plot
scrsz = get(0,'ScreenSize');
figure('Name','Telemetry Plotter',...
    'Position',[100 50 scrsz(3)*0.8 scrsz(4)*0.8])
plot(time,acc,'r','Marker','.','MarkerSize',5)
hold on
plot(time,control,'k','Marker','.','MarkerSize',5)
plot(time,aoa,'b','Marker','.','MarkerSize',5)
plot(time,regressed_acc,'r:')
plot(time,v,'g')
%plot(time,acc_smooth,'c')
hold off
xlabel('time')
legend('acc-smooth','truecontrol','aoa','regressed','v');
h = gca;
set(h, 'Position', [0.02 0.06 0.96 0.92]);
