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
clear;
model = aircraft_model();
model.aero_model = false;         % stock model
model.force_spd_maintain = true;
%model.MOI(1) = 165.0;
%model.pitch_rot_m(2) = 0.5;
pitch_acc_c = ang_acc_pitch_yaw(0, model);
pitch_vel_c = ang_vel_pitch_yaw(0, pitch_acc_c);
pitch_aoa_c = aoa_controller(0, pitch_vel_c);
pitch_aoa_c.params = [4.5, 0.07, 500.0];
dt = 0.1;
sim_length = 50;
time = zeros(1, sim_length);
positions = zeros(3, sim_length);
forwards = zeros(3, sim_length);
rights = zeros(3, sim_length);
aoas = zeros(3, sim_length);
pred_aoas = zeros(1, sim_length);
pred_eq_v = zeros(1, sim_length);
pred_err = zeros(1, sim_length);
pred_out = zeros(1, sim_length);
speed = zeros(1, sim_length);
ang_acc = zeros(3, sim_length);
ang_vel = zeros(3, sim_length);
output_vel = zeros(1, sim_length);
output_acc = zeros(1, sim_length);
real_setpoint_acc = zeros(1, sim_length);
cntrl = zeros(3, sim_length);
csurf = zeros(3, sim_length);

frame = 1;
positions(:, frame) = model.position.';
forwards(:, frame) = model.forward_vector.';
rights(:, frame) = model.right_vector.';
aoas(:, frame) = model.aoa.';
speed(frame) = model.velocity_magn;
csurf(:, frame) = model.csurf_state;
ang_acc(:, frame) = model.angular_acc;
ang_vel(:, frame) = model.angular_vel;

for frame = 2:sim_length
    time(frame) = dt * (frame - 1);
    model.preupdate(dt);
    if (time(frame) > 0.0 && time(frame) < 2.5)
        des_aoa = 0.2;
    else
        des_aoa = -0.2;
    end

    p_output = pitch_aoa_c.eval(des_aoa, 0.0, dt);

    output_vel(frame) = pitch_aoa_c.output_vel;
    output_acc(frame) = pitch_aoa_c.output_acc;
    pred_aoas(1, frame + 1) = pitch_aoa_c.predicted_aoa;
    pred_eq_v(1, frame) = pitch_aoa_c.predicted_eq_v;
    pred_err(1, frame) = pitch_aoa_c.predicted_error;
    pred_out(1, frame) = pitch_aoa_c.pred_output;
    real_setpoint_acc(frame) = (output_vel(frame) - output_vel(frame-1)) / dt;
    cntrl(:, frame) = [p_output, 0, 0];
    %cntrl(:, frame) = [0, r_output, 0];
    model.simulation_step(dt, cntrl(:, frame));

    positions(:, frame) = model.position.';
    forwards(:, frame) = model.forward_vector.';
    rights(:, frame) = model.right_vector.';
    aoas(:, frame) = model.aoa.';
    speed(frame) = model.velocity_magn;
    csurf(:, frame) = model.csurf_state;
    ang_acc(:, frame) = model.angular_acc;
    ang_vel(:, frame) = model.angular_vel;
end
%% Plot pitch parameters
h = figure(1338);
H0 = plot(time, ang_acc(1,:), 'b');
hold on;
H1 = plot(time, ang_vel(1,:), 'g');
H2 = plot(time, aoas(1,:), 'm');
H3 = plot(time, cntrl(1,:), 'r');
H4 = plot(time, csurf(1,:), 'k:');
H5 = plot(time, output_vel, 'g:');
H6 = plot(time, real_setpoint_acc, 'k');
H7 = plot(time, output_acc, 'k--');
H8 = plot(time, pred_aoas(1,1:end-1), 'm:');
hold off;
xlabel('time');
legend([H0,H1,H2,H3,H4,H5,H6,H7,H8], 'acc', 'ang vel', 'AoA', 'pitch ctrl', 'pitch csurf', 'output vel',...
    'true setpoint deriv', 'output acc', 'pred aoa');
h = gca;
set(h, 'Position', [0.045 0.08 0.91 0.90]);
