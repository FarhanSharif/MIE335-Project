function Q4_plot(w, b, combo_opt)

% Get data
[train, tune, test, ~] = getFederalistData;
[M, H] = getMH_tune(train, tune);

% Extract "best" words (combo_opt)
M_best = M(:, combo_opt);
H_best = H(:, combo_opt);
test_best = test(:, combo_opt);

% Hyperplane: wx = -b --> x1 on x-axis, x2 on y-axis --> w1x + w2y = -b --> -b/w2 - (w1/w2)x
x = (0 : 14);
y = (-b / w(2)) - ((w(1)/w(2)) * x);

if w(1) == 0
    x = (0 : 14);
    y = (-b/w(2))*ones(1, length(x));
    
elseif w(2) == 0
    y = (0 : 8);
    x = (-b/w(1))*ones(1, length(y));

end

% Plot
marker_size = 30;

hold all;
Madison_plot = scatter(M_best(:, 1), M_best(:, 2), marker_size, 'red', '+');
Hamilton_plot = scatter(H_best(:, 1), H_best(:, 2), marker_size, 'green', 'o');
Disputed_plot = scatter(test_best(:, 1), test_best(:, 2), marker_size, 'blue', '*');

Classifying_Line = plot(x, y, '-m'); % Hyperplane

title('Classification according to "best" two attributes');
xlabel('Frequency of word 1');
ylabel('Frequency of word 2');

legend([Madison_plot, Hamilton_plot, Disputed_plot], {'Madison', 'Hamilton', 'Disputed', 'Location', 'northeast'});

grid

hold off;

end