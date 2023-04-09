function [Input] = get_spectra(Input, lambda, bandwidth)

spectra = readmatrix(Input.filename);

% illumination wavelength in nanometers
wavelength = spectra(:,1);

% excitation normalized to percentage
excitation = 100.*(spectra(:,2)/max(spectra(:,2)));

% emission normalized to percentage
emission = 100.*(spectra(:,3)/max(spectra(:,3)));

% calculate brightness of the fluorophore at peak excitation
brightness = Input.EC * Input.QY;

% calculate brightness of fluorophore at illumination wavelenth
brightness_normalized = brightness * (interp1(wavelength,excitation,lambda)/100);

% calculate total emission AUC
total_AUC = trapz(wavelength, emission);

% calculate emission AUC within the filter bandwidth
collected_AUC = trapz(interp1(wavelength, emission, bandwidth));

% calculate total collected brightness at illuminatino wavelength
collected_brightness = brightness_normalized * (collected_AUC/total_AUC);

% write calculated variables to structure array for output
Input.wavelength = wavelength;
Input.excitation = excitation;
Input.emission = emission;
Input.collected_brightness = collected_brightness;
Input.brightness_normalized = collected_brightness;

end