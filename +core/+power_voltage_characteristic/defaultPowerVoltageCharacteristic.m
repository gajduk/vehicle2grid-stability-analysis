function S = defaultPowerVoltageCharacteristic(V,Y)
%calculates the power as S = V^2 * Y
S = (V.*conj(V)).*Y;    
end

