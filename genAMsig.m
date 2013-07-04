%Generates an AM signal from an input sound file.

%Arthur Gretton
%01/08/12


function [sigAM] = genAMsig(sig,fs,fMultiple,fTransmitMultiple,offset,envelopeScale);

%Upsample the signal to 2* the nyqist of the carrier
sig_upsample = interp(sig,fMultiple*fTransmitMultiple,1);

%Carrier frequency
fCarrier = fs*fMultiple;

%time axis and carrier signal
t = (1:length(sig_upsample))/(fs*fMultiple*fTransmitMultiple);
carrierSig = sin(2*pi*fCarrier*t);

%amplitude modulated signal
sigAM = carrierSig' .*(offset + sig_upsample*envelopeScale);
