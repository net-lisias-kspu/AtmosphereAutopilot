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
%% generalization debugging
gen_buf_dims = int16([11, 11]);
gen_buf_upper = [0.1, 0.1];
gen_buf_lower = [-0.1, -0.1];
delta = gen_buf_upper - gen_buf_lower;
temp = cumprod(gen_buf_dims);   % temp array for deriving a linear size of generalization buffer
gen_buf_size = temp(end);
gen_buf_input = zeros(2, gen_buf_size) + NaN;
cell_centers = zeros(2, gen_buf_size) + NaN;
gen_linear_index = 0;
global_inputs = [aoa; control];
for frame = 1:length(aoa)
    % update generalization space
    gen_buf_upper = max(gen_buf_upper, global_inputs(:,frame).'); % stretch
    gen_buf_lower = min(gen_buf_lower, global_inputs(:,frame).');
    [gen_coord, cell_center] = maptocell(global_inputs(:,frame).',...
        gen_buf_lower, gen_buf_upper, gen_buf_dims);
    gen_linear_index = coord2index(gen_coord, gen_buf_dims);
    cell_centers(:,gen_linear_index) = cell_center.';
    old_coord = gen_buf_input(:,gen_linear_index);
    if isnan(old_coord(1))
        gen_buf_input(:,gen_linear_index) = global_inputs(:,frame);
    else
        if norm((global_inputs(:,frame).' - cell_center) ./ delta) <...
                norm((old_coord.' - cell_center) ./ delta)
            gen_buf_input(:,gen_linear_index) = global_inputs(:,frame);
        end
    end
    % try to apply symmetry assumption
    gen_index_symm = gen_buf_dims - gen_coord - 1;
    gen_linear_index_symm = coord2index(gen_index_symm, gen_buf_dims);
    % symmetry
    if (gen_linear_index_symm ~= gen_linear_index) && isnan(gen_buf_input(1,gen_linear_index_symm))
        %gen_buf_input(:,gen_linear_index_symm) = -gen_buf_input(:,gen_linear_index);
    end
end
gen_inputs = zeros(2, gen_buf_size);
j = 0;
for i=1:gen_buf_size
    if ~isnan(gen_buf_input(1,i))
        j = j+1;
        gen_inputs(:,j) = gen_buf_input(:,i);
    end
end
%% plot
figure('Name', 'Generalization space')
scatter(aoa, control, 3)
hold on
scatter(gen_inputs(1,:), gen_inputs(2,:), 'r', 'fill');
scatter(cell_centers(1,:), cell_centers(2,:), 'k', 'fill');
hold off
xlabel('AoA');
ylabel('control');
