function spingraph(filename, angles, delay, elev1, elev2, elev3)

    % Создает .gif с вращением текущего 3D-графика
    %   Copyright (c) 2026, x2DFox
    %
    %   Версия      | 1.0.0
    %   Разработчик | x2DFox
    %   GitHub      | https://github.com/x2DFox
    %   Telegram    | https://t.me/x2DFox
    %   Лицензия    | BSD 3-Clause (см. LICENSE в корне репозитория)
    %
    %   filename - имя файла, например, 'name.gif'
    %       !!! Если файл с таким именем уже существует, то функция его перезапишет
    %   angles:
    %       горизонтальный массив углов в градусах, например 0:10:360, где
    %       0   - Начальное значение (с какого угла начать)
    %       10  - Шаг (через сколько градусов делать кадр)
    %       360 - Конечное значение (каким уголом закончить)
    %   delay - задержка между кадрами в секундах, например 0.5
    %   elev1 - вертикальный угол в градусах для 1-го вращения (по умолчанию = 30)
    %   elev2 - вертикальный угол в градусах для 2-го вращения (опционально)
    %   elev3 - вертикальный угол в градусах для 3-го вращения (опционально)
    %
    %   Примеры:
    %   spingraph('name.gif', 0:30:180, 1.0)
    %   spingraph('name.gif', 90:10:360, 0.05, 30, 75)
    %   spingraph('name.gif', 0:1:90, 0.1, 30, 75, 90)

    % Проверка наличия графика
    if isempty(get(groot, 'CurrentFigure'))
        error('Сначала создайте 3D-график (surf, mesh и т.п.)');
    end

    % Проверка наличия параметров
    if nargin < 3
        error('Необходимо указать минимум 3 параметра: filename, angles, delay');
    end

    % Проверка наличия 1-го угла
    if nargin < 4
        elev1 = 30;
    end

    % 1-е вращение
    for ang = angles
        view(ang, elev1);
        drawnow;
        current_frame = getframe(gcf);
        rgb_image = frame2im(current_frame);
        [indexed_image, color_map] = rgb2ind(rgb_image, 256);
        if ang == 0
            imwrite(indexed_image, color_map, filename, 'gif', 'LoopCount', Inf, 'DelayTime', delay);
        else
            imwrite(indexed_image, color_map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', delay);
        end
    end

    % 2-е вращение
    if nargin >= 5
        for ang = angles
            view(ang, elev2);
            current_frame = getframe(gcf);
            rgb_image = frame2im(current_frame);
            [indexed_image, color_map] = rgb2ind(rgb_image, 256);
            imwrite(indexed_image, color_map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', delay);
        end
    end

    % 3-е вращение
    if nargin == 6
        for ang = angles
            view(ang, elev3);
            current_frame = getframe(gcf);
            rgb_image = frame2im(current_frame);
            [indexed_image, color_map] = rgb2ind(rgb_image, 256);
            imwrite(indexed_image, color_map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', delay);
        end
    end

    disp(['.gif сохранен как: ', filename]);
end
