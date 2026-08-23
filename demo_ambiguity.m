% Демонстрация работы модуля spingraph.m
%   Copyright (c) 2026, x2DFox
%
%   Разработчик | x2DFox
%   GitHub      | https://github.com/x2DFox
%   Telegram    | https://t.me/x2DFox
%   Лицензия    | BSD 3-Clause (см. LICENSE в корне репозитория)

% Очистка MATLAB Workspace
clear all

% Количество отсчетов
N = 10;

% Формируем прямоугольный импульс
impulse = [zeros(1, N), ones(1, N)];

% Фигура для графика прямоугольного импульса
figure('color', 'white');
stairs(0:length(impulse)-1, impulse, 'b');
xlim([0, 19])
ylim([-0.5, 1.5])
title('Прямоугольный импульс')
xlabel('Номер отсчета, \it\tau');
ylabel('амплитуда');
grid on;

% Инициализируем массив и цикл для АКФ
impulse_result = [];
for ii = 1:2*N+1
    shift = ii - (N+1);                                    % Сдвиг от -N до N
    shifted_impulse = circshift(impulse, [0, shift]);      % Сдвигаем сигнал
    impulse_result(ii) = sum(impulse .* shifted_impulse);  % Вычисляем корреляцию
end

% Фигура для графика АКФ
figure('color', 'white');
plot(-N:N, impulse_result, 'b');
title('АКФ на основе прямоугольного импульса')
xlabel('временной сдвиг, \it\tau');
ylabel('амплитуда');
grid on;

% Параметры для диапазона частотных сдвигов
frequency_shift = linspace(-0.5, 0.5, 101);

ambiguity = [];
for ii = 1:length(frequency_shift)
    expon = exp(-j * 2 * pi * (frequency_shift(ii)) * (0:length(impulse)-1));
    ambiguity(ii) = abs(sum(impulse .* expon));
end
ambiguity = ambiguity/max(ambiguity);

% Фигура для графика ФН (сечение по частоте)
figure('color', 'white');
plot(frequency_shift, ambiguity, 'b');
title('Частотная ФН на основе прямоугольного импульса');
xlabel('частотный сдвиг, \it f');
ylabel('нормированная амплитуда');
grid on;

% Диапазон временных сдвигов
tau = linspace(-N, N, 2*N+1);

% Цикл для функции неопределенности
ambiguity_3d = [];
for i = 1:length(tau)
    for j = 1:length(frequency_shift)
        shifted_signal = circshift(impulse, [0, round(tau(i))]);                 % Сдвигаем сигнал по времени
        expon = exp(-1j * 2 * pi * frequency_shift(j) * (0:length(impulse)-1));  % Применяем частотный сдвиг
        ambiguity_3d(i, j) = abs(sum(impulse .* shifted_signal .* expon));       % Вычисляем ФН
    end
end

% Фигура для графика ФН
figure('color', 'white');
surf(tau, frequency_shift, ambiguity_3d.');
title('Частотно-временная ФН сигнала на основе прямоугольного импульса');
xlabel('временное сечение,\it τ');
ylabel('частотное сечение,\it f');
zlabel('aмплитуда');
colormap turbo;
shading interp;

% Создание GIF-Изображения графика
spingraph('ambiguity.gif', 0:10:360, 0.5, 30, 75, 90)
