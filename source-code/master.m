clear; close all; clc

% define platform properties
lambda = 488;
bandwidth = 505:545;

% define properties for the fluorophore with defined units
FL1.filename = 'data/FITC.csv';
FL1.EC = 75000;  % molar extinction coefficient at peak excitation
FL1.QY = 0.92; % quantum yield

[FL1] = get_spectra(FL1, lambda, bandwidth);

% define properties for the fluorophore to assign units to
FL2.filename = 'data/SYBR Gold.csv';
FL2.EC = 57000; % molar extinction coefficient at peak excitation
FL2.QY = 0.6; % quantum yield

[FL2] = get_spectra(FL2, lambda, bandwidth);

% factor used to reassign units. This cofactor represents how many units
% FL2 is compared to FL1. Multiply the assigned units by the 'norm_factor'
% to reassign units on that platform. 
norm_factor = FL2.collected_brightness/FL1.collected_brightness;

% create figure
fig = figure;
ax = nexttile;
hold(ax,'on')
plot(FL1.wavelength, FL1.emission .* FL1.brightness_normalized/max(FL1.emission), '-k','linewidth',2)
plot(FL2.wavelength, FL2.emission .* FL2.brightness_normalized/max(FL2.emission), '-b','linewidth',2)
fill([min(bandwidth) max(bandwidth) max(bandwidth) min(bandwidth)],[0 0 repmat(ax.YLim(2),1,2)],[0 0.5 0],'FaceAlpha',0.2)

xlim([400 700])
xlabel('Wavelength (nm)')
ylabel('Brightness')
set(gca,'LineWidth',2,'fontsize',14)
xline(ax, ax.XLim(2),'color','k','linewidth',2)
yline(ax, ax.YLim(2),'color','k','linewidth',2)
legend({'FL1','FL2','Filter'},'box','off','fontsize',14)
title(['Difference in brightness FL2/FL1 = ', num2str(round(norm_factor,3))])
print(fig,'Spectral Conversion','-djpeg','-r300')