Простые и составные ключи
Внутренняя сортировка и внешняя сортировка
Внутренняя - сортировка(хранится в оп памяти) сортировка массивов
Внешняя - сортировка файлов

_
Сортировки, которые не требуют доп памяти(сортировки на том же месте)


Которые требуют дополнительную память
- Сортировка подсчетом
- Распределяющий подсчет
- Вставки в список
- Двухпутевые вставки
- Вставки в список с вычислением адреса
- Простое и естественное слияние
- Турнирная сортировка

Простые сортировки
- Обмен
  - Сортировка пузырьком
  - Улучшенный пузырек 
  - Шейкерная сортировка
- Вставки
  - Простые вставки
  - Бинарные вставки
- Выбор
  - Сортировка простым выбором

Улучшенные сортировки
- Обмен
  - Быстрая сортировка(сортировка Хоара)
  - Обменная поразрядная
  - Параллельная сортировка Бэтчера
  - Пирамидальная сортировка
- Вставки
  - Сортировка Шелла(Сортировка с убывающим шагом)
  - Пирамидальная сортировка
- Выбор
  - Пирамидальная сортировка

// Сортировка подсчетом
const 
	N=...;
type
	TElem=integer;
	TMas=array[1..N] of TElem;
var
	B, Count:TMas;
	i,j:integer;
begin
	for i:=1 to N do Count[i]:=0;
	for i:=1 to N-1 do
		for j:=i+1 to N do
		if A[i]<=A[j] then inc(Count[j])
		else inc(Count[i]);
	for i:=1 to N do
	B[Count[i]+1]:=A[i];
	for i:=1 to N do
	A[i]:=B[i];
end;

//Распределяющий подсчет
const
	N=...;//количество элементов в массиве
	u=...;
	v=...;
type
	TKey=u..v;//диапазон ключей известен и невелик
	TElem= record
		key:TKey;
		info:...;
	end;
	TMas=array [1..N] of TElem;

procedure Sort2(var A:TMas);
var 
	CNT:array[TKey] of integer;
	B:TMas;
	i:integer;
begin
	for k:=u to v do
		CNT[k]:=0;
	for i:=1 to N do
		inc(CNT[A[i].key]);
	for k:=succ(u) to v do
		CNT[k]:=CNT[k]+CNT[pred(k)];
end;

//Пузырек
for i:=1 to N-1 do
	for j:=1 to N-1 do
	if A[j]>A[j+1]
	then
	A[j] меняем A[j+1]

//Улучшенная сортировка пузырьком


//Шейкерная сортировка
//У Вирта 

//Сортировка простыми вставками

for i:=1 to N do//i-какой элемент собираемся вставлять
	begin
		x:=A[i];
		j:=i-1;
		while (j>=1) and (A[j]>x) do
			begin
				A[j+1]:=A[j];
				dec(j);
			end;
			A[j+1]:=x;
	end;


//Бинарная вставка
for i:=2 to N do
begin
	l:=1;
	r:=i;
	repeat
	m:=(l+r)div2;
	if A[m]>A[i] then r:=m 
	else l:=m+1;
	x:=A[i];
	for j:=i-1 to r do
	A[j+1]:=A[j];
	A[r]:=x;
end;

//Двухпутевые вставки КНУТ

//Вставки в список с вычислением адреса

///пропустил

//сортировка Шелла(с убывающим шагом)

//h_1>h_2>...>h_t=1
// Желательно чтобы шаги не были кратными
// 7 15 6 3 8 2 4 5 12
// h_1=7 (шаг равный семи)
// h_2=3
// h_3=1
// Выбираются шаги, а потом сортировка методом простых вставок

// Существуют различные способы выбора шага
// h[k-1]=3h[k]+1, h[t]=1,t=log_3(N)-1
// h[t]=1
// h[t-1]=4
// h[t-2]=13

// h[k-1]=2h[k]+1, h[t]=1, t=log_2(N)

// 2^k-1

// 2^k+1

// (2^k-(-1)^k)/3

// (3^k-1)

// Числа фибоначчи

var 
	i,j,step,p,l,T:integer;
	Elem:TElem;
begin
	T:=trunc(ln(N)/ln(2));
	for j:=T downto 1 do
	begin
		step:=Pow(2,j)-1;
		for p:=1 to step do
		begin
			i:=p+step;
			while (i<=N) do
			begin
				Elem:=A[i];
				l:=i-step;
				while (l>=1) and (Elem<A[l]) do
				begin
					A[l-step]:=Elem;
					l:=l-step;
				end;
				A[l+step]:=Elem;
				i:=i+step;
			end;
		end;
	end;
end;

///

a:array[-h_1..n] of TElem;//чать ячеек используется для барьера, количество таких ячеек должно быть равно первому элементу

const
	t=4;
var
	i,j,k,s:integer;
	h:array[1..t] of integer;
begin
	h[1]:=9; h[2]:=5;h[3]:=3;h[4]:=1;
	for m:=1 to t do
	begin
		k:=h[m];
		s:=-k;
		for i:=k+1 to n do
		begin
			x:=a[i];
			j:=i-k;
			if s=0 then s:=-k 
			s:=s+1;
			a[s]:=x;
			while x<a[j] do
			begin
				a[j+k]:=a[j];
				j:=j-k;
			end;
			a[j+k]:=x;
		end;
	end;
end;