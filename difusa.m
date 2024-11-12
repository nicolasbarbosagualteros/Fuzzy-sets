sistema_fis = readfis('main_fis_ajustado.fis');
load("audio_data.mat");

% RANGO DINÁMICO
if  dynamic_range >= 0.87
    bajo_params_input1 = [0 0 dynamic_range];
    moderado_params_input1 = [0 0.5 1];
    alto_params_input1 = [0.87 1 1];
elseif dynamic_range <= 0.8665926456451416&&dynamic_range>0.8
    bajo_params_input1 = [0 0 0.33];
    moderado_params_input1 = [0 dynamic_range 1];
    alto_params_input1 = [0.88 1 1];
elseif dynamic_range <= 0.79 
    bajo_params_input1 = [0 0 0.87];
    moderado_params_input1 = [0 0.5 1];
    alto_params_input1 = [0 dynamic_range 1];
end

% Parámetros de rango dinámico
sistema_fis.Inputs(1).MembershipFunctions(1).Parameters = bajo_params_input1;
sistema_fis.Inputs(1).MembershipFunctions(2).Parameters = moderado_params_input1;
sistema_fis.Inputs(1).MembershipFunctions(3).Parameters = alto_params_input1;

% VOLUMEN
if vol <= -16
    bajo_params_input2 = [vol-15 vol vol+15];
    moderado_params_input2 = [-25 0 25];
    alto_params_input2 = [5 30 55.02];
elseif vol <= -10
    bajo_params_input2 = [-55 -30 -5];
    moderado_params_input2 = [vol-15 vol vol+15];
    alto_params_input2 = [5 30 55.02];
else
    bajo_params_input2 = [-55 -30 -5];
    moderado_params_input2 = [-25 0 25];
    alto_params_input2 = [vol-15 vol vol+15];
end

% Parámetros del Volumen
sistema_fis.Inputs(2).MembershipFunctions(1).Parameters = bajo_params_input2;
sistema_fis.Inputs(2).MembershipFunctions(2).Parameters = moderado_params_input2;
sistema_fis.Inputs(2).MembershipFunctions(3).Parameters = alto_params_input2;

% DURACIÓN
if duracion <= 200
    corto_params_input3 = [max(-125, duracion*-1) 0 min(duracion, 125)];
    medio_params_input3 = [25 150 275];
    largo_params_input3 = [175 300 425];
elseif duracion <= 300
    corto_params_input3 = [-125 0 125];
    medio_params_input3 = [max(25, duracion-100) duracion min(duracion+100, 275)];
    largo_params_input3 = [175 300 425];
else
    corto_params_input3 = [-125 0 125];
    medio_params_input3 = [25 150 275];
    largo_params_input3 = [max(175, duracion-125) duracion min(duracion+125, 425)];
end

% Parámetros de la duración
sistema_fis.Inputs(3).MembershipFunctions(1).Parameters = corto_params_input3;
sistema_fis.Inputs(3).MembershipFunctions(2).Parameters = medio_params_input3;
sistema_fis.Inputs(3).MembershipFunctions(3).Parameters = largo_params_input3;

writeFIS(sistema_fis, 'main_fis_ajustado.fis');  

%Salida
output = evalfis(sistema_fis, [dynamic_range, vol, duracion]);

if output < 5.3&&output>4.51
    nivel_produccion = 'Medio';
elseif output >= 5.3 && output < 6.0
    nivel_produccion = 'Alto';
elseif output <4.50
    nivel_produccion = 'Bajo';
end

% Resultado
disp(['Nivel de producción: ', nivel_produccion]);

% Gráficas
figure;
subplot(3, 1, 1);
plotmf(sistema_fis, 'input', 1);
title('Funciones de Membresía para Rango dinámico');

subplot(3, 1, 2);
plotmf(sistema_fis, 'input', 2);
title('Funciones de Membresía para Volumen promédio');

subplot(3, 1, 3);
plotmf(sistema_fis, 'input', 3);
title('Funciones de Membresía para Duracion');