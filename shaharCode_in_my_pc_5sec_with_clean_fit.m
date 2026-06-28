clc; clear; close all;

%% =========================================================
% BASE DIRECTORY
%% =========================================================
set(groot,'defaultFigureColor','w');
set(groot,'defaultAxesColor','w'); 

baseDir = fullfile( ...
    'C:', ...
    'Users', ...
    '97254', ...
    'Desktop', ...
    'Hexbug', ...
    'Diameter_vs_Cycle_times_25_Nov_2025');

%% =========================================================
% DATA
%% =========================================================

diameterList_mm = [ ...
    75 75 75 75 ...
    70 70 70 70 ...
    80 80 80 80 ...
    85 85 85 85 ...
    90 90 90 90 ...
    60 60 60 60 ...
    65 65 65 65 ...
    55 55 55 55 ...
    52.5 52.5 52.5 52.5 ...
    50 50 50 50 ];

folderNames = { ...
'GX010871_MATLAB_Processed_data'
'GX010872_MATLAB_Processed_data'
'GX010873_MATLAB_Processed_data'
'GX010874_MATLAB_Processed_data'
'GX010875_MATLAB_Processed_data'
'GX010876_MATLAB_Processed_data'
'GX010877_MATLAB_Processed_data'
'GX010878_MATLAB_Processed_data'
'GX010879_MATLAB_Processed_data'
'GX010880_MATLAB_Processed_data'
'GX010881_MATLAB_Processed_data'
'GX010882_MATLAB_Processed_data'
'GX010883_MATLAB_Processed_data'
'GX010884_MATLAB_Processed_data'
'GX010885_MATLAB_Processed_data'
'GX010886_MATLAB_Processed_data'
'GX010887_MATLAB_Processed_data'
'GX010888_MATLAB_Processed_data'
'GX010889_MATLAB_Processed_data'
'GX010890_MATLAB_Processed_data'
'GX010911_MATLAB_Processed_data'
'GX010912_MATLAB_Processed_data'
'GX010913_MATLAB_Processed_data'
'GX010914_MATLAB_Processed_data'
'GX010915_MATLAB_Processed_data'
'GX010916_MATLAB_Processed_data'
'GX010917_MATLAB_Processed_data'
'GX010918_MATLAB_Processed_data'
'GX010919_MATLAB_Processed_data'
'GX010920_MATLAB_Processed_data'
'GX010921_MATLAB_Processed_data'
'GX010922_MATLAB_Processed_data'
'GX010924_MATLAB_Processed_data'
'GX010925_MATLAB_Processed_data'
'GX010926_MATLAB_Processed_data'
'GX010927_MATLAB_Processed_data'
'GX010928_MATLAB_Processed_data'
'GX010929_MATLAB_Processed_data'
'GX010930_MATLAB_Processed_data'
'GX010931_MATLAB_Processed_data'
};

%% =========================================================
% TIME WINDOW
%% =========================================================

startTime = 5;
endTime   = 7;

%% =========================================================
% SETTINGS
%% =========================================================

assert(numel(folderNames)==numel(diameterList_mm), ...
    'Diameter list mismatch');

[diameterList_mm, order] = sort(diameterList_mm,'descend');

folderNames = folderNames(order);

offset_red_mm = 8;

useOneFilePerDiameter = true;

repToUse = 1;

if useOneFilePerDiameter
    idx = repToUse:4:numel(folderNames);
else
    idx = 1:numel(folderNames);
end

saveDir = fullfile(baseDir, 'Processed_Figures_10sec');

if ~exist(saveDir,'dir')
    mkdir(saveDir);
end

if useOneFilePerDiameter
    filePrefix = sprintf('Hexbug_No_%d_', repToUse);
else
    filePrefix = 'Hexbug_All_';
end

nRuns = numel(idx);

%% =========================================================
% FIGURES
%% =========================================================

figVelR_col = figure( ...
    'Name','Red speed (10s)', ...
    'Position',[160 160 600 900]);

axVelR = gobjects(nRuns,1);

figVelY_col = figure( ...
    'Name','Yellow speed (10s)', ...
    'Position',[180 180 600 900]);

axVelY = gobjects(nRuns,1);

figVelB_col = figure( ...
    'Name','Blue speed (10s)', ...
    'Position',[200 200 600 900]);

axVelB = gobjects(nRuns,1);

figClustersR = figure('Name','Red clusters (10s)');
axClustersR = axes(figClustersR);
hold(axClustersR,'on');
axis(axClustersR,'equal');
grid(axClustersR,'on');

figClustersY = figure('Name','Yellow clusters (10s)');
axClustersY = axes(figClustersY);
hold(axClustersY,'on');
axis(axClustersY,'equal');
grid(axClustersY,'on');

figClustersB = figure('Name','Blue clusters (10s)');
axClustersB = axes(figClustersB);
hold(axClustersB,'on');
axis(axClustersB,'equal');
grid(axClustersB,'on');

figOrient = figure('Name','Orientation phi(t) (10s)');
axPhi = axes(figOrient);
hold(axPhi,'on');
grid(axPhi,'on');

figVel = figure('Name','V_theta (10s)');

axVel1 = subplot(3,1,1);
hold(axVel1,'on');
grid(axVel1,'on');

axVel2 = subplot(3,1,2);
hold(axVel2,'on');
grid(axVel2,'on');

axVel3 = subplot(3,1,3);
hold(axVel3,'on');
grid(axVel3,'on');

figAlpha = figure('Name','Alpha(t) (10s)');
axAlpha = axes(figAlpha);
hold(axAlpha,'on');
grid(axAlpha,'on');

figAlphaDot = figure('Name','Alpha_dot(t) (10s)');
axAlphaDot = axes(figAlphaDot);
hold(axAlphaDot,'on');
grid(axAlphaDot,'on');

figThetaDot = figure('Name','Theta_dot(t) (10s)');
axThetaDot = axes(figThetaDot);
hold(axThetaDot,'on');
grid(axThetaDot,'on');

figThetaV = figure('Name','Theta_v(t) (10s)');
axThetaV = axes(figThetaV);
hold(axThetaV,'on');
grid(axThetaV,'on');

%% =========================================================
% MAIN LOOP
%% =========================================================

for ii = 1:numel(idx)

    k = idx(ii);

    fprintf('Processing %s\n', folderNames{k});

    D_mm = diameterList_mm(k);

    legStr = sprintf('D=%gmm', D_mm);

    dataPattern = fullfile( ...
        baseDir, ...
        folderNames{k}, ...
        '*trackingData*.mat');

    S = dir(dataPattern);

    if isempty(S)
        continue;
    end

    clear trackingData

    load(fullfile(S(1).folder,S(1).name),'trackingData');

    %% ===== TIME CUT =====

    t_full = trackingData.timestamps_seconds(:);

    mask = (t_full >= startTime) & ...
           (t_full <= endTime);

    if sum(mask) < 10
        continue;
    end

    t  = t_full(mask);

    xr = trackingData.red.sticker(1).Xpixels(mask);
    yr = trackingData.red.sticker(1).Ypixels(mask);

    xy = trackingData.yellow.sticker(1).Xpixels(mask);
    yy = trackingData.yellow.sticker(1).Ypixels(mask);

    xb = trackingData.blue.sticker(1).Xpixels(mask);
    yb = trackingData.blue.sticker(1).Ypixels(mask);

    %% =====================================================
    % OUTLIER REMOVAL
    %% =====================================================

    X = [xr xy xb];
    Y = [yr yy yb];

    Xc = mean(X,2,'omitnan');
    Yc = mean(Y,2,'omitnan');

    dist = sqrt((X - Xc).^2 + (Y - Yc).^2);

    medD = median(dist(:),'omitnan');

    good = all(dist < 5*medD, 2);

    xr = xr(good);
    yr = yr(good);

    xy = xy(good);
    yy = yy(good);

    xb = xb(good);
    yb = yb(good);

    t  = t(good);

    if numel(t) < 6
        continue;
    end

    %% =====================================================
    % TIME STEP
    %% =====================================================

    dt_vec = diff(t);

    dt_vec(dt_vec <= 0) = NaN;

    t_mid = t(1:end-1) + 0.5*dt_vec;

    %% =====================================================
    % CIRCLE FIT
    %% =====================================================

    P = [xr yr];

    rmed = median(P,1);

    dr = sqrt(sum((P - rmed).^2,2));

    keep = dr < prctile(dr,98);

    [cx, cy, Rpx] = fitCircleKasa( ...
        P(keep,1), ...
        P(keep,2));

    R_eff_red_mm = (D_mm/2) - offset_red_mm;

    mm_per_px = R_eff_red_mm / Rpx;

    %% =====================================================
    % SCALE + CENTER
    %% =====================================================

    xr = (xr - cx) * mm_per_px;
    yr = (yr - cy) * mm_per_px;

    xy = (xy - cx) * mm_per_px;
    yy = (yy - cy) * mm_per_px;

    xb = (xb - cx) * mm_per_px;
    yb = (yb - cy) * mm_per_px;

    %% =====================================================
    % CLUSTERS
    %% =====================================================

scatter(axClustersR, xr, yr, 30, 'filled');

scatter(axClustersY, xy, yy, 30, 'filled');

scatter(axClustersB, xb, yb, 30, 'filled');

    %% =====================================================
    % PHI
    %% =====================================================

    phi = unwrap(atan2(yr - yb, xr - xb));

    plot(axPhi, t, phi, 'DisplayName', legStr);

    %% =====================================================
    % VELOCITIES
    %% =====================================================

    vxr = diff(xr) ./ dt_vec;
    vyr = diff(yr) ./ dt_vec;

    vxy = diff(xy) ./ dt_vec;
    vyy = diff(yy) ./ dt_vec;

    vxb = diff(xb) ./ dt_vec;
    vyb = diff(yb) ./ dt_vec;

    rxr = 0.5*(xr(1:end-1)+xr(2:end));
    ryr = 0.5*(yr(1:end-1)+yr(2:end));

    rxy = 0.5*(xy(1:end-1)+xy(2:end));
    ryy = 0.5*(yy(1:end-1)+yy(2:end));

    rxb = 0.5*(xb(1:end-1)+xb(2:end));
    ryb = 0.5*(yb(1:end-1)+yb(2:end));

    vR_signed = (rxr.*vyr - ryr.*vxr) ./ hypot(rxr, ryr);

    vY_signed = (rxy.*vyy - ryy.*vxy) ./ hypot(rxy, ryy);

    vB_signed = (rxb.*vyb - ryb.*vxb) ./ hypot(rxb, ryb);

    %% =====================================================
    % COLUMN FIGURES
    %% =====================================================

    figure(figVelR_col);

    axVelR(ii) = subplot(nRuns,1,ii);

    plot(t_mid, vR_signed);

    title(legStr);

    figure(figVelY_col);

    axVelY(ii) = subplot(nRuns,1,ii);

    plot(t_mid, vY_signed);

    title(legStr);

    figure(figVelB_col);

    axVelB(ii) = subplot(nRuns,1,ii);

    plot(t_mid, vB_signed);

    title(legStr);

    %% =====================================================
    % COMBINED FIGURE
    %% =====================================================

    plot(axVel1, t_mid, vR_signed, 'DisplayName', legStr);

    plot(axVel2, t_mid, vY_signed, 'DisplayName', legStr);

    plot(axVel3, t_mid, vB_signed, 'DisplayName', legStr);

    %% =====================================================
    % MIDPOINT
    %% =====================================================

    xm = 0.5*(xr + xb);

    ym = 0.5*(yr + yb);

    vxm = diff(xm) ./ dt_vec;

    vym = diff(ym) ./ dt_vec;

    theta_v = atan2(vym, vxm);

    plot(axThetaV, t_mid, theta_v, 'DisplayName', legStr);

    %% =====================================================
    % ALPHA
    %% =====================================================

    phi_mid = 0.5*(phi(1:end-1)+phi(2:end));

    alpha = mod(theta_v - phi_mid + pi, 2*pi) - pi;

    alpha_unw = unwrap(alpha);

    plot(axAlpha, t_mid, alpha_unw, 'DisplayName', legStr);

    %% =====================================================
    % ALPHA DOT
    %% =====================================================

    alpha_dot = diff(alpha_unw) ./ dt_vec(1:end-1);

    plot( ...
        axAlphaDot, ...
        t_mid(1:end-1), ...
        alpha_dot, ...
        'DisplayName', legStr);

    %% =====================================================
    % THETA DOT
    %% =====================================================

    rxm = 0.5*(xm(1:end-1)+xm(2:end));

    rym = 0.5*(ym(1:end-1)+ym(2:end));

    rm = hypot(rxm, rym);

    v_theta_mid = (rxm .* vym - rym .* vxm) ./ rm;

    v_theta_mid(rm < 1e-6) = NaN;

    omega_inst = v_theta_mid ./ rm;

    omega_inst(rm < 1e-6) = NaN;

    plot(axThetaDot, t_mid, omega_inst, 'DisplayName', legStr);

end

%% =========================================================
% SUMMARY CALCULATION
%% =========================================================

nAllRuns = numel(folderNames);

meanThetaDot_all = nan(nAllRuns,1);

diameter_mm_all = nan(nAllRuns,1);

for k = 1:nAllRuns

    fprintf('Summary computing: %s\n', folderNames{k});

    D_mm = diameterList_mm(k);

    dataPattern = fullfile( ...
        baseDir, ...
        folderNames{k}, ...
        '*trackingData*.mat');

    S = dir(dataPattern);

    if isempty(S)
        continue;
    end

    clear trackingData

    load(fullfile(S(1).folder,S(1).name),'trackingData');

    %% ===== TIME CUT =====

    t_full = trackingData.timestamps_seconds(:);

    mask = (t_full >= startTime) & ...
           (t_full <= endTime);

    if sum(mask) < 10
        continue;
    end

    t  = t_full(mask);

    xr = trackingData.red.sticker(1).Xpixels(mask);
    yr = trackingData.red.sticker(1).Ypixels(mask);

    xy = trackingData.yellow.sticker(1).Xpixels(mask);
    yy = trackingData.yellow.sticker(1).Ypixels(mask);

    xb = trackingData.blue.sticker(1).Xpixels(mask);
    yb = trackingData.blue.sticker(1).Ypixels(mask);

    %% =====================================================
    % SAME OUTLIER REMOVAL
    %% =====================================================

    X = [xr xy xb];
    Y = [yr yy yb];

    Xc = mean(X,2,'omitnan');
    Yc = mean(Y,2,'omitnan');

    dist = sqrt((X - Xc).^2 + (Y - Yc).^2);

    medD = median(dist(:),'omitnan');

    good = all(dist < 5*medD, 2);

    xr = xr(good);
    yr = yr(good);

    xy = xy(good);
    yy = yy(good);

    xb = xb(good);
    yb = yb(good);

    t  = t(good);

    if numel(t) < 6
        continue;
    end

    %% =====================================================
    % dt
    %% =====================================================

    dt = diff(t);

    dt(dt <= 0) = NaN;

    %% =====================================================
    % SAME CIRCLE FIT
    %% =====================================================

    P = [xr yr];

    rmed = median(P,1);

    dr = sqrt(sum((P - rmed).^2, 2));

    keep = dr < prctile(dr,98);

    [cx, cy, Rpx] = fitCircleKasa(P(keep,1), P(keep,2));

    R_eff_red_mm = (D_mm/2) - offset_red_mm;

    mm_per_px = R_eff_red_mm / Rpx;

    %% =====================================================
    % SAME CENTERING + SCALING
    %% =====================================================

    xr = (xr - cx) * mm_per_px;
    yr = (yr - cy) * mm_per_px;

    xb = (xb - cx) * mm_per_px;
    yb = (yb - cy) * mm_per_px;

    %% =====================================================
    % SAME MIDPOINT
    %% =====================================================

    xm = 0.5*(xr + xb);

    ym = 0.5*(yr + yb);

    vxm = diff(xm) ./ dt;

    vym = diff(ym) ./ dt;

    rxm = 0.5*(xm(1:end-1)+xm(2:end));

    rym = 0.5*(ym(1:end-1)+ym(2:end));

    rm = hypot(rxm, rym);

    %% =====================================================
    % SAME THETA DOT
    %% =====================================================

    v_theta_mid = (rxm .* vym - rym .* vxm) ./ rm;

    v_theta_mid(rm < 1e-6) = NaN;

    theta_dot_inst = v_theta_mid ./ rm;

    theta_dot_inst(rm < 1e-6) = NaN;

    %% =====================================================
    % AVERAGE
    %% =====================================================

    meanThetaDot_all(k) = mean(theta_dot_inst,'omitnan');

    diameter_mm_all(k) = D_mm;

end

%% =========================================================
% SAVE SUMMARY
%% =========================================================

ThetaDotSummary = table( ...
    folderNames(:), ...
    diameter_mm_all, ...
    meanThetaDot_all, ...
    'VariableNames', ...
    {'FolderName','Diameter_mm','MeanThetaDot_10sec'});

writetable( ...
    ThetaDotSummary, ...
    fullfile(saveDir, 'Summary_10sec_5to15.csv'));

fprintf('\nDONE.\n');

%% =========================================================
% PITCHFORK FIGURE
%% =========================================================

repID_all = nan(nAllRuns,1);

uD = unique(diameterList_mm,'stable');

for jj = 1:numel(uD)

    thisD = uD(jj);

    ids = find(diameterList_mm == thisD);

    repID_all(ids) = 1:numel(ids);

end

radius_mm_all = diameter_mm_all ./ 2;

%% =========================================================
% FIGURE
%% =========================================================

figMeanOmegaAll = figure( ...
    'Name','All Hexbugs Pitchfork', ...
    'Position',[300 120 850 500]);

axMeanOmegaAll = axes(figMeanOmegaAll);

hold(axMeanOmegaAll,'on');

grid(axMeanOmegaAll,'on');

set(axMeanOmegaAll,'TickLabelInterpreter','latex');

bugColors = [ ...
    0.0000 0.4470 0.7410
    0.8500 0.3250 0.0980
    0.9290 0.6940 0.1250
    0.4940 0.1840 0.5560 ];

for rep = 1:4

    mask = ...
        (repID_all == rep) & ...
        isfinite(radius_mm_all) & ...
        isfinite(meanThetaDot_all);

    scatter( ...
        axMeanOmegaAll, ...
        radius_mm_all(mask), ...
        meanThetaDot_all(mask), ...
        70, ...
        'filled', ...
        'MarkerFaceColor', bugColors(rep,:), ...
        'DisplayName', sprintf('Hexbug %d', rep));

end

xlabel( ...
    axMeanOmegaAll, ...
    'Confinement radius $r_w$ (mm)', ...
    'Interpreter','latex');

ylabel( ...
    axMeanOmegaAll, ...
    '$\langle \dot{\theta} \rangle$ (rad/s)', ...
    'Interpreter','latex');

title( ...
    axMeanOmegaAll, ...
    'All Hexbugs: $\langle \dot{\theta} \rangle$ vs $r_w$', ...
    'Interpreter','latex');

legend(axMeanOmegaAll,'Location','best');

%% =========================================================
% SAVE FIGURE
%% =========================================================

saveas( ...
    figMeanOmegaAll, ...
    fullfile(saveDir,'All_Hexbugs_Pitchfork.png'));

savefig( ...
    figMeanOmegaAll, ...
    fullfile(saveDir,'All_Hexbugs_Pitchfork.fig'));



%% =========================================================
% FIT EXPERIMENTAL PITCHFORK TO SHOSHANI THEORY
%% =========================================================

disp(' ');
disp('===========================================');
disp('Fitting experimental data to Shoshani theory');
disp('===========================================');

% ===== valid data =====
validMask = ...
    isfinite(radius_mm_all) & ...
    isfinite(meanThetaDot_all);

r_exp = radius_mm_all(validMask);
omega_exp = meanThetaDot_all(validMask);
rep_exp = repID_all(validMask);

% ===== remove very small noisy values if wanted =====
minOmegaForFit = 0.2;   % rad/s
fitMask = abs(omega_exp) > minOmegaForFit;

r_fit = r_exp(fitMask);
omega_fit = abs(omega_exp(fitMask));

% ===== Shoshani pitchfork model =====
% p(1) = Omega0 [rad/s]
% p(2) = r0 [mm]
modelFun = @(p,r) p(1) .* sqrt( ...
    max(0, ...
    (1 ./ (r./p(2)).^2) .* ...
    (1 - 1 ./ (r./p(2)).^2)));

% ===== initial guess =====
Omega0_guess = max(omega_fit);
r0_guess = 35;

p0 = [Omega0_guess, r0_guess];

% ===== bounds =====
lb = [0, 20];
ub = [50, 60];

% ===== fit =====
if exist('lsqcurvefit','file') == 2

    opts = optimoptions('lsqcurvefit', ...
        'Display','iter', ...
        'MaxFunctionEvaluations',5000, ...
        'MaxIterations',1000);

    p_fit = lsqcurvefit( ...
        modelFun, ...
        p0, ...
        r_fit, ...
        omega_fit, ...
        lb, ...
        ub, ...
        opts);

else

    warning('lsqcurvefit not found. Using fminsearch instead.');

    costFun = @(p) sum((omega_fit - modelFun(p,r_fit)).^2);

    p_fit = fminsearch(costFun,p0);

end

Omega0_fit = p_fit(1);
r0_fit     = p_fit(2);

% ===== goodness of fit =====
omega_pred = modelFun(p_fit,r_fit);

SSres = sum((omega_fit - omega_pred).^2);
SStot = sum((omega_fit - mean(omega_fit)).^2);

R2 = 1 - SSres/SStot;
RMSE = sqrt(mean((omega_fit - omega_pred).^2));

fprintf('\n=====================================\n');
fprintf('BEST FIT PARAMETERS\n');
fprintf('=====================================\n');
fprintf('r0      = %.4f mm\n', r0_fit);
fprintf('Omega0  = %.4f rad/s\n', Omega0_fit);
fprintf('R^2     = %.4f\n', R2);
fprintf('RMSE    = %.4f rad/s\n', RMSE);
fprintf('=====================================\n\n');

%% =========================================================
% NORMALIZED DATA
%% =========================================================

rw_norm = radius_mm_all ./ r0_fit;
omega_norm = meanThetaDot_all ./ Omega0_fit;

%% =========================================================
% THEORY CURVE
%% =========================================================

rw_theory = linspace(1, max(rw_norm)*1.05, 1000);

omega_theory = sqrt( ...
    (1 ./ rw_theory.^2) .* ...
    (1 - 1 ./ rw_theory.^2));

%% =========================================================
% FIGURE: NORMALIZED DATA + SHOSHANI THEORY
%% =========================================================

figFit = figure( ...
    'Name','Normalized Pitchfork vs Shoshani Theory', ...
    'Position',[300 150 950 600]);

axFit = axes(figFit);

hold(axFit,'on');
grid(axFit,'on');
set(axFit,'TickLabelInterpreter','latex');

% ===== theory branches =====
plot(axFit, rw_theory, omega_theory, ...
    'k-', ...
    'LineWidth',3, ...
    'DisplayName','Shoshani theory');

plot(axFit, rw_theory, -omega_theory, ...
    'k-', ...
    'LineWidth',3, ...
    'HandleVisibility','off');

% ===== zero branch =====
plot(axFit, [0 1], [0 0], ...
    'k--', ...
    'LineWidth',2, ...
    'DisplayName','$\omega=0$ branch');

% ===== experimental data =====
for rep = 1:4

    maskRep = ...
        (repID_all == rep) & ...
        isfinite(rw_norm) & ...
        isfinite(omega_norm);

    scatter(axFit, ...
        rw_norm(maskRep), ...
        omega_norm(maskRep), ...
        80, ...
        'filled', ...
        'MarkerFaceColor', bugColors(rep,:), ...
        'DisplayName', sprintf('Hexbug %d',rep));

end

xline(axFit,1,'r--','LineWidth',2, ...
    'DisplayName','$r_w/r_0=1$');

xlabel(axFit, ...
    '$r_w/r_0$', ...
    'Interpreter','latex', ...
    'FontSize',16);

ylabel(axFit, ...
    '$\langle \dot{\theta} \rangle/\Omega_0$', ...
    'Interpreter','latex', ...
    'FontSize',16);

title(axFit, ...
    sprintf('Normalized Pitchfork: r0 = %.2f mm, Omega0 = %.2f rad/s, R^2 = %.3f', ...
    r0_fit, Omega0_fit, R2), ...
    'Interpreter','none');

legend(axFit,'Location','best','Interpreter','latex');

%% =========================================================
% SAVE FIT FIGURE + TABLE
%% =========================================================

saveas(figFit, ...
    fullfile(saveDir,'Normalized_Pitchfork_vs_Shoshani.png'));

savefig(figFit, ...
    fullfile(saveDir,'Normalized_Pitchfork_vs_Shoshani.fig'));

FitSummary = table( ...
    r0_fit, ...
    Omega0_fit, ...
    R2, ...
    RMSE, ...
    'VariableNames', ...
    {'r0_mm','Omega0_rad_per_s','R2','RMSE'});

writetable(FitSummary, ...
    fullfile(saveDir,'Shoshani_Fit_Parameters.csv'));

NormalizedData = table( ...
    folderNames(:), ...
    diameter_mm_all, ...
    radius_mm_all, ...
    repID_all, ...
    meanThetaDot_all, ...
    rw_norm, ...
    omega_norm, ...
    'VariableNames', ...
    {'FolderName','Diameter_mm','Radius_mm','HexbugNumber', ...
    'MeanThetaDot_rad_per_s','rw_norm','omega_norm'});

writetable(NormalizedData, ...
    fullfile(saveDir,'Normalized_Data_vs_Shoshani.csv'));



%% =========================================================
% OUTLIER REJECTION + CLEAN FIT TO SHOSHANI THEORY
%% =========================================================

% This section does NOT delete the experimental data.
% It only marks points whose distance from the fitted theory is too large,
% removes them from a second fit, and shows them separately in the clean plot.

disp(' ');
disp('===========================================');
disp('Outlier rejection based on Shoshani residuals');
disp('===========================================');

%% ---------------------------------------------------------
% RESIDUALS FROM FIRST FIT
%% ---------------------------------------------------------

rw_fit_norm = r_fit ./ r0_fit;
omega_fit_norm_abs = omega_fit ./ Omega0_fit;

omega_theory_at_data = sqrt( ...
    max(0, ...
    (1 ./ rw_fit_norm.^2) .* ...
    (1 - 1 ./ rw_fit_norm.^2)));

residuals = omega_fit_norm_abs - omega_theory_at_data;

sigmaResidual = std(residuals,'omitnan');
outlierFactor = 2.0;   % אפשר לשנות ל-2.5 אם רוצים סינון פחות אגרסיבי

keepFit = abs(residuals) <= outlierFactor * sigmaResidual;

r_fit_clean = r_fit(keepFit);
omega_fit_clean = omega_fit(keepFit);

%% ---------------------------------------------------------
% SECOND FIT AFTER OUTLIER REMOVAL
%% ---------------------------------------------------------

p0_clean = [Omega0_fit, r0_fit];

if exist('lsqcurvefit','file') == 2

    optsClean = optimoptions('lsqcurvefit', ...
        'Display','iter', ...
        'MaxFunctionEvaluations',5000, ...
        'MaxIterations',1000);

    p_fit_clean = lsqcurvefit( ...
        modelFun, ...
        p0_clean, ...
        r_fit_clean, ...
        omega_fit_clean, ...
        lb, ...
        ub, ...
        optsClean);

else

    warning('lsqcurvefit not found. Using fminsearch for clean fit.');

    costFunClean = @(p) sum((omega_fit_clean - modelFun(p,r_fit_clean)).^2);

    p_fit_clean = fminsearch(costFunClean,p0_clean);

end

Omega0_clean = p_fit_clean(1);
r0_clean     = p_fit_clean(2);

omega_pred_clean = modelFun(p_fit_clean,r_fit_clean);

SSres_clean = sum((omega_fit_clean - omega_pred_clean).^2);
SStot_clean = sum((omega_fit_clean - mean(omega_fit_clean)).^2);

R2_clean = 1 - SSres_clean/SStot_clean;
RMSE_clean = sqrt(mean((omega_fit_clean - omega_pred_clean).^2));

fprintf('\n=====================================\n');
fprintf('CLEAN FIT PARAMETERS AFTER OUTLIER REMOVAL\n');
fprintf('=====================================\n');
fprintf('Outlier factor = %.2f sigma\n', outlierFactor);
fprintf('Removed points = %d out of %d fitted points\n', sum(~keepFit), numel(keepFit));
fprintf('r0 clean       = %.4f mm\n', r0_clean);
fprintf('Omega0 clean   = %.4f rad/s\n', Omega0_clean);
fprintf('R^2 clean      = %.4f\n', R2_clean);
fprintf('RMSE clean     = %.4f rad/s\n', RMSE_clean);
fprintf('=====================================\n\n');

%% ---------------------------------------------------------
% MAP REMOVED / KEPT POINTS BACK TO FULL DATA
%% ---------------------------------------------------------

validOriginalIndices = find(validMask);
fitOriginalIndices = validOriginalIndices(fitMask);

removedOriginalIndices = fitOriginalIndices(~keepFit);
keptOriginalIndices    = fitOriginalIndices(keepFit);

removedMaskFull = false(size(meanThetaDot_all));
keptMaskFull    = false(size(meanThetaDot_all));

removedMaskFull(removedOriginalIndices) = true;
keptMaskFull(keptOriginalIndices) = true;

%% ---------------------------------------------------------
% NORMALIZED DATA USING CLEAN FIT
%% ---------------------------------------------------------

rw_norm_clean = radius_mm_all ./ r0_clean;
omega_norm_clean = meanThetaDot_all ./ Omega0_clean;

rw_theory_clean = linspace(1, max(rw_norm_clean)*1.05, 1000);

omega_theory_clean = sqrt( ...
    (1 ./ rw_theory_clean.^2) .* ...
    (1 - 1 ./ rw_theory_clean.^2));

%% ---------------------------------------------------------
% FIGURE: CLEAN NORMALIZED DATA + THEORY
%% ---------------------------------------------------------

figClean = figure( ...
    'Name','Clean Normalized Pitchfork vs Shoshani Theory', ...
    'Position',[350 150 950 600]);

axClean = axes(figClean);

hold(axClean,'on');
grid(axClean,'on');
set(axClean,'TickLabelInterpreter','latex');

% Theory branches after clean fit
plot(axClean, rw_theory_clean, omega_theory_clean, ...
    'k-', ...
    'LineWidth',3, ...
    'DisplayName','Shoshani theory clean fit');

plot(axClean, rw_theory_clean, -omega_theory_clean, ...
    'k-', ...
    'LineWidth',3, ...
    'HandleVisibility','off');

% Zero branch
plot(axClean, [0 1], [0 0], ...
    'k--', ...
    'LineWidth',2, ...
    'DisplayName','$\omega=0$ branch');

% Kept experimental points
for rep = 1:4

    maskRepKept = ...
        (repID_all == rep) & ...
        keptMaskFull & ...
        isfinite(rw_norm_clean) & ...
        isfinite(omega_norm_clean);

    scatter(axClean, ...
        rw_norm_clean(maskRepKept), ...
        omega_norm_clean(maskRepKept), ...
        85, ...
        'filled', ...
        'MarkerFaceColor', bugColors(rep,:), ...
        'DisplayName', sprintf('Hexbug %d kept',rep));

end

% Removed experimental points are shown, not deleted
scatter(axClean, ...
    rw_norm_clean(removedMaskFull), ...
    omega_norm_clean(removedMaskFull), ...
    120, ...
    'o', ...
    'LineWidth',2, ...
    'MarkerEdgeColor',[0.4 0.4 0.4], ...
    'DisplayName','Removed outliers');

xline(axClean,1,'r--','LineWidth',2, ...
    'DisplayName','$r_w/r_0=1$');

xlabel(axClean, ...
    '$r_w/r_0$', ...
    'Interpreter','latex', ...
    'FontSize',16);

ylabel(axClean, ...
    '$\langle \dot{\theta} \rangle/\Omega_0$', ...
    'Interpreter','latex', ...
    'FontSize',16);

title(axClean, ...
    sprintf('Clean normalized pitchfork: r0 = %.2f mm, Omega0 = %.2f rad/s, R^2 = %.3f', ...
    r0_clean, Omega0_clean, R2_clean), ...
    'Interpreter','none');

legend(axClean,'Location','best','Interpreter','latex');

%% ---------------------------------------------------------
% SAVE CLEAN FIT FIGURE + TABLES
%% ---------------------------------------------------------

saveas(figClean, ...
    fullfile(saveDir,'Clean_Normalized_Pitchfork_vs_Shoshani.png'));

savefig(figClean, ...
    fullfile(saveDir,'Clean_Normalized_Pitchfork_vs_Shoshani.fig'));

CleanFitSummary = table( ...
    outlierFactor, ...
    sum(~keepFit), ...
    numel(keepFit), ...
    r0_clean, ...
    Omega0_clean, ...
    R2_clean, ...
    RMSE_clean, ...
    'VariableNames', ...
    {'OutlierFactorSigma','RemovedPoints','TotalFittedPoints', ...
    'r0_clean_mm','Omega0_clean_rad_per_s','R2_clean','RMSE_clean'});

writetable(CleanFitSummary, ...
    fullfile(saveDir,'Shoshani_Clean_Fit_Parameters.csv'));

OutlierTable = table( ...
    folderNames(:), ...
    diameter_mm_all, ...
    radius_mm_all, ...
    repID_all, ...
    meanThetaDot_all, ...
    rw_norm_clean, ...
    omega_norm_clean, ...
    removedMaskFull, ...
    keptMaskFull, ...
    'VariableNames', ...
    {'FolderName','Diameter_mm','Radius_mm','HexbugNumber', ...
    'MeanThetaDot_rad_per_s','rw_norm_clean','omega_norm_clean', ...
    'RemovedAsOutlier','UsedInCleanFit'});

writetable(OutlierTable, ...
    fullfile(saveDir,'Clean_Normalized_Data_vs_Shoshani.csv'));

%% =========================================================
% HELPERS
%% =========================================================

function [a,b,R] = fitCircleKasa(x,y)

A = [2*x(:) 2*y(:) ones(size(x(:)))];

b2 = x(:).^2 + y(:).^2;

sol = A\b2;

a = sol(1);

b = sol(2);

R = sqrt(max(0, a^2 + b^2 + sol(3)));

end

