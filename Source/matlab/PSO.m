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
function [optimal_value, optimal_coord] = PSO(target_func, space, pcount, w, c1, c2, max_iter, plt)
    % initialize particles
    param_count = size(space, 1);
    particles = rand(pcount, param_count);
    local_best = particles;
    values = Inf(pcount, 1);
    vel = c2 * (rand(pcount, param_count) - 0.5) * 2.0;
    min_value = Inf;
    optimal_value = Inf;
    optimal_history = zeros(max_iter, 1);
    min_part = -1;
    iter = 0;
    space_delta = (space(2,:) - space(1,:));
    if (plt)
        h = figure(1488);
    end
    while iter < max_iter
        % evaluate
        parfor i = 1:pcount
            denorm_params = space(1,:) + space_delta .* particles(i,:);
            new_val = target_func(denorm_params);
            if (new_val < values(i))
                local_best(i,:) = particles(i, :);    % new particle-specific minimum
            end
            values(i) = new_val;
        end
        % find minimum
        [min_value, min_part] = min(values);
        if (min_value < optimal_value)
            optimal_value = min_value;
            optimal_coord = space(1,:) + space_delta .* particles(min_part,:);
        end
        optimal_history(iter + 1) = optimal_value;

        %random velocity shifts
        beta1 = (rand(pcount, param_count) - 0.5) * 2.0;
        beta2 = (rand(pcount, param_count) - 0.5) * 2.0;
        % update velocity
        vel = w * vel + c1 * beta1 .* (local_best - particles) + ...
            c2 * beta2 .* (repmat(particles(min_part,:), pcount, 1) - particles);
        % update particle positions
        particles = particles + vel;

        iter = iter + 1;
    end
    if (plt)
        plot(1:max_iter, optimal_history);
    end
end

