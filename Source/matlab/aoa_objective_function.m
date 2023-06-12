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
function output_val = aoa_objective_function(params)
    model = aircraft_model();
    model.aero_model = false;         % stock model
    model.force_spd_maintain = true;
    pitch_acc_c = ang_acc_pitch_yaw(0, model);
    pitch_vel_c = ang_vel_pitch_yaw(0, pitch_acc_c);
    pitch_aoa_c = aoa_controller(0, pitch_vel_c);
    pitch_aoa_c.params = params;
    dt = 0.1;
    sim_length = 50;
    time = zeros(1, sim_length);
    aoas = zeros(3, sim_length);

    frame = 1;
    aoas(:, frame) = model.aoa.';
    output_val = 0.0;

    for frame = 2:sim_length
        time(frame) = dt * (frame - 1);
        model.preupdate(dt);
        if (time(frame) > 0.0 && time(frame) < 2.5)
            des_aoa = 0.2;
        else
            des_aoa = -0.2;
        end
        p_output = pitch_aoa_c.eval(des_aoa, 0.0, dt);
        signal = [p_output, 0, 0];
        %cntrl(:, frame) = [0, r_output, 0];
        model.simulation_step(dt, signal);
        aoas(:, frame) = model.aoa.';
        aoa = model.aoa(1, 1);
        if (time(frame) >= 0.0 && time(frame) < 2.0)
            factor = time(frame);
            if (aoa > 0.2)
                factor = factor * 1000.0;
            end
        else
            factor = time(frame) - 2.5;
            if (aoa < -0.2)
                factor = factor * 1000.0;
            end
        end
        output_val = output_val + factor * abs(des_aoa - model.aoa(1, 1));
    end
end

