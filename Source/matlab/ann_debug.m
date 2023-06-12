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
%% sinus approximation

inputs = linspace(-1, 1, 50);
outputs = 0.5 .* (sin(inputs) + 0.2 .* cos(7 .* inputs));
hidden_count = int16(10);
input_count = int16(1);
mu = 1e-3;
mu_min = 1e-8;
mu_max = 1e11;
grad_min = 1e-9;
grad_min_iter_limit = 6;
grad_min_iter = 0;
tau = 100;
weights = 2 .* (rand(1, hidden_count*(input_count + 1)) - 0.5);
biases = 2 .* (rand(1, hidden_count + 1) - 0.5);

ann_outputs = anneval_large(inputs, weights, biases, input_count, hidden_count);
old_sqr_err = meansqr(ann_outputs - outputs);

plot(inputs, outputs, 'r')
hold on
for i = 1:500
    [new_weights, new_biases] =...
        anntrain_lm(inputs, outputs, weights, biases, mu, input_count, hidden_count);
    ann_outputs = anneval_large(inputs, new_weights, new_biases, input_count, hidden_count);
    new_sqr_err = meansqr(ann_outputs - outputs);
    if (new_sqr_err < old_sqr_err)
        weights = new_weights;
        biases = new_biases;
        if mu/tau >= mu_min
            mu = mu / tau;
        end
        grad = old_sqr_err - new_sqr_err;
        if grad < grad_min
            grad_min_iter = grad_min_iter + 1;
            if grad_min_iter >= grad_min_iter_limit
                break
            end
        end
        if new_sqr_err == 0
            break
        end
        old_sqr_err = new_sqr_err;
        %plot(inputs, ann_outputs);
    else
        if mu*tau <= mu_max
            mu = mu * tau;
        end
    end
end
ann_outputs = anneval_large(inputs, weights, biases, input_count, hidden_count);
plot(inputs, ann_outputs);
hold off;

