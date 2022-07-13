# Elevator
Функционирование лифта:
Изначально лифт находится на 1 этаже с закрытыми дверьми
1) едет на этаж где нажата кнопка(если кнопка нажата на этаже где находится лифт, то остаёмся на месте)
2) открывает двери
3) ждет 10 секунд, закрывает двери
4) если кнопка внутри лифта нажата - едет на соответствующий этаж, иначе остается на этаже ждать вызов.

Интерфейс блока:

    Входные данные:
clk , rst_n
[2:0] butt_el - кнопки в лифте
butt_up_down - кнопка вызова на этаже
[2:0] pass_f - номер этажа на котором пассажир вызвал лифт
    Выходные:
elev_f_o - этаж на котором находится лифт(стартовая позиция лифта - 1 этаж)
busy_o - состояние лифта(свободен/занят)
    Внутренние:
state - принимает значение этапов (IDLE, WAIT, MOVE)
next - указатель на следующий этап
flag - идентификатор состояния лифта

Конечный автомат в два always блока, состоящий из 3х этапов: IDLE, WAIT, MOVE:
   IDLE: обнуление flag, сброс elev_f_o в положение по умолчанию(1 этаж)
   WAIT: при butt_up_down==1, flag переходит в состояние 1 и лифт начинает движение до этажа пассажира(через тернарный оператор проверяем: если пассажир выше лифта увеличиваем переменную elev_f_o, иначе уменьшаем).
Если кнопка не нажата (butt_up_down==0), то находится в состоянии ожидания flag = 0
   MOVE: Если в лифте нажата кнопка(butt_el == *значение*), так же через тернарный оператор едем до этажа, в противном случае, если кнопку не нажали переходим в состояние ожидания WAIT.
