function Concave_segments1_3and2()
    clc
    % User input for focal point and height range
    focus_x = input('Enter the x-coordinate of the focal point: ');
    focus = [focus_x, 0]; % focal point
    height_start = input('Enter the starting height of parallel rays: ');
    height_end = input('Enter the ending height of parallel rays: ');

    % Generate heights from start to end with step of 1 cm
    heights = height_start:1:height_end;

    % Parameters
    R = 20; % radius of curvature in cm
    N = length(heights); % number of segments
    segment_length = 1; % length of each segment for visualization

    % Define theta based on the range of heights
    if height_start >= 0 && height_end >= 0
        theta = linspace(0, 1.1, N+1);
    elseif height_start <= 0 && height_end <= 0
        theta = linspace(0, -1.1, N+1);
    else
        theta = linspace(1.1, -1.1, N+1);
    end  

    % Calculate segment midpoints
    midpoints = zeros(N, 2);
    for i = 1:N
        mid_theta = (theta(i) + theta(i+1)) / 2;
        midpoints(i, :) = [R * cos(mid_theta), R * sin(mid_theta)];
    end

    % Calculate reflection angles to focus
    reflection_angles = zeros(N, 1);
    for i = 1:N
        midpoint = midpoints(i, :);
        vector_to_focus = focus - midpoint;
        angle_to_focus = atan2(vector_to_focus(2), vector_to_focus(1));
        normal_angle = atan2(midpoint(2), midpoint(1));
        reflection_angles(i) = 2 * normal_angle - angle_to_focus;
    end

    % Convert reflection angles to segment angles
    segment_angles = zeros(N, 1);
    for i = 1:N
        segment_angles(i) = (reflection_angles(i) + atan2(midpoints(i, 2), midpoints(i, 1))) / 2;
    end

    % Plot
    figure;
    hold on;

    % Plot the arc from 1.1 to -1.1 radians
    arc_theta = linspace(1.2, -1.2, 100);
    arc_x = R * cos(arc_theta);
    arc_y = R * sin(arc_theta);
    plot(arc_x, arc_y, 'k--');

    % Add parallel incoming rays and reflected rays for user-defined heights
    for j = 1:length(heights)
        height = heights(j);
        % Find the intersection point on the mirror arc
        distances = sqrt((midpoints(:,2) - height).^2);
        [~, closest_idx] = min(distances);
        x_mid = R * cos(atan2(height, R));
        y_mid = height;
        seg_angle = segment_angles(closest_idx);
        seg_x = [x_mid - segment_length * cos(seg_angle)/2, x_mid + segment_length * cos(seg_angle)/2];
        seg_y = [y_mid - segment_length * sin(seg_angle)/2, y_mid + segment_length * sin(seg_angle)/2];

        % Plot the segment
        plot(seg_x, seg_y, 'b', 'LineWidth', 2); % segment line

        % Plot the incoming ray
        plot([-R, x_mid], [height, y_mid], 'g--'); % incoming ray

        % Plot the reflected ray to the focus
        plot([x_mid, focus(1)], [y_mid, focus(2)], 'r--'); % ray to focus
    end

    plot(focus(1), focus(2), 'go'); % focus point
    xlim([-R, R]);
    ylim([-R, R]);
    axis equal;
    xlabel('X-axis (cm)');
    ylabel('Y-axis (cm)');
    title('Segmented Concave Mirror with Rays Focusing at');
    grid on;
    hold off;

    % Display segment angles for each midpoint
    disp('Segment Angles (degrees) for each midpoint:');
    for i = 1:length(heights)
        fprintf('Segment %d: %.2f degrees\n', i, rad2deg(segment_angles(i)));
    end

    % Define the range of heights for parallel rays from height start to height end in cm
    heights_full_range = height_start:1:height_end;

    % Calculate focal lengths for each height in the full range
    focal_lengths = zeros(size(heights_full_range));
    for i = 1:length(heights_full_range)
        height = heights_full_range(i);
        % Calculate x-coordinate of the intersection point on the mirror arc
        x_mid = R * cos(atan2(height, R));
        % Calculate the horizontal distance to the focus
        distance_to_focus = abs(focus_x - x_mid);
        focal_lengths(i) = distance_to_focus;
    end

    % Plot focal length as a function of height
    figure();
    hold on;
    plot(heights_full_range, focus_x+zeros(size(heights_full_range)), 'LineWidth', 8, 'DisplayName', '(1.3) ');    

    h = linspace(height_start, height_end, N); % the height of the parallel rays
    F2 = R - R./(2.*cos(asin(h./R))); % Focal distance for general case
    plot(h, F2,'LineWidth', 2 ,'DisplayName', 'without rounding (1.2)'); % plot for general case
    plot(h, (R/2).*ones(size(h)),'r', 'LineWidth', 2, 'DisplayName', 'small angle (1.1)'); % plot for special case

    % Adding title, axis labels, grid, and legend:
    title('Focal Length as a Function of Height for a Concave Mirror');
    xlabel('Height of Parallel Rays (cm)');
    ylabel('Focal Length (cm)');
    grid on;
    legend('show');

end