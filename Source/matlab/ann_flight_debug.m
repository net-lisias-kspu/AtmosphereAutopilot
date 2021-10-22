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
%% plot generalization space
figure('Name','Generalization space')
scatter3(gen_inputs(1,1:gen_count), gen_inputs(2,1:gen_count), gen_outputs(1:gen_count));
%scatter3(global_inputs(1,1:300), global_inputs(2,1:300), global_outputs(1:300));
xlabel('AoA');
ylabel('control');
zlabel('acc');
%% plot control sensitivity
figure('Name','control sensitivity')
control_d = linspace(-1,1,99);
aoa_d = zeros(1,99);
%plot(control_d, anneval_large([aoa_d; control_d],...
%    weights, biases, input_count, hidden_count))
hold on
plot(control_d, [zeros(99,1) + 1.0, aoa_d.', control_d.'] * lin_params.')
hold off
xlabel('control');
ylabel('acc');
%% plot aoa sensitivity
figure('Name','aoa sensitivity')
aoa_d = linspace(-0.5,0.5,99);
control_d = zeros(1,99);
%plot(aoa_d, anneval_large([aoa_d; control_d],...
%    weights, biases, input_count, hidden_count))
plot(aoa_d, [zeros(99,1) + 1.0, aoa_d.', control_d.'] * lin_params.')
xlabel('aoa');
ylabel('acc');
%% plot ann surface
aoa_d = linspace(gen_buf_lower(1),gen_buf_upper(1),31);
control_d = linspace(gen_buf_lower(2),gen_buf_upper(2),31);
[Aoa, Cntrl] = meshgrid(aoa_d, control_d);
%Acc = zeros(99, 99);
Lin_Acc = zeros(31, 31);
for i = 1:31
    for k = 1:31
        %Acc(i,k) = anneval_large([Aoa(i,k), Cntrl(i,k)].',...
        %    weights, biases, input_count, hidden_count);
        Lin_Acc(i,k) = sum(lin_params .* [1.0, Aoa(i,k), Cntrl(i,k)]);
    end
end
surf(Aoa,Cntrl,Lin_Acc);
hold on
scatter3(gen_inputs(1,1:gen_count), gen_inputs(2,1:gen_count), gen_outputs(1:gen_count));
%scatter3(global_inputs(1,:), global_inputs(2,:), global_outputs(1,:));
hold off
xlabel('Aoa');
ylabel('Cntrl');
%% cumulative acceleration graph
frame = 1000;
l = 32;
x = 1:l;
y = zeros(1,l);
y_model = y;
y_smoothed = y;
for i=1:l
    y(i) = sum(norm_acc(:,(frame-i+1):frame));
    y_model(i) = sum(ann_global_outputs(:,(frame-i+1):frame));
end
figure('Name','Cumulative acc');
plot(x,y,'-b*');
hold on
plot(x,y_model,'-r*');
hold off
legend('acc','model acc');
