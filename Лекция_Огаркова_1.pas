Хеширование
hashing - рассеивание
Хеширование
-внешние цепочки
-внутренние цепочки
-опробывание
	-линейное
	-квадратичное
	-двойное хеширование
Ключ - та часть инфрмации по которой в последствии идет поиск
например:

в базах данных есть уникальные и неуникальные(одинаков для двух разных информаций) ключи

информация - сведения о студентах
ключ - номер студенческого билета

H(key)=adress
adress - внутри хеш таблицы, те номер или индекс ячейки

Создать идеальную хеш функцию практически невозможно
идеальная хеш функция - разные ключи, разные адреса

k1!=k2, но хеш функция выдает одинаковые значения H(k1)=H(k2). Это называется коллизией

В любом из методов определяет тот или иной метод разрешения коллизий

Tkey = ...//задавать можно от составных до integer и char
TInfo = record
	key:Tkey;
	other:...
	....
	end;

Это был отдельный модуль например

const N=47 //размер хеш таблицы должен быть простым числом
//при непростом числе есть опасность попадать на одни и ите же ячейки
type 
	TIndex=0..N-1;

{или например так
Type
	 Tlist=^TNode;
	 TNode=record
	 info:TInfo;
	 next:TList;
	 end;
}
TCell = Tlist;
HashTable=array[TIndex] of TCell;

По сути любая хеш таблица является классом
Хеш таблицы нужно задавать через классы

инициализация хеш таблицы - пройти по таблице и всем проставить nil

function Hash(key:Tkey):TIndex;

Добавления может быть реальзовано как функция так и процедура
если запрещено добавлять повторно ключи - функция
если разрешено - процедура


для внешних цепочек тлист - отдельный класс
иниц списка
добавление
поиск
удаление
очисткаъ
печать списка
сохранение списка в файл

далее предполагаем что Tlist это отдельный класс

function Add(var HT:THashTable; info:TInfo):boolean;
var a:TIndex;
begin
	a:=Hash(info.key);
	result:=HT[a].Add(info);
end;

поиск идет не по инфе, а по ключу

function Find(var HT:THashTable, key:Tkey; var info:TInfo):boolean;
var
a:TIndex;
begin
	a:=Hash(key);
	result:=HT[a].Find(key,info);//find здесь идет от списка, а не от хешей
end;

тоже немаловажная штука
if HT.Find(key.info) then show(info)
	else ShowMessage(...)

function Delete(var HT:THashTable, key:Tkey):boolean;
var
a:TIndex;
begin
	a:=Hash(key);
	result:=HT[a].Delete(key,info);//find здесь идет от списка, а не от хешей
end;

еще нужы методы load и save

Внутренние цепочки 18.03.2013
и прочее

Во внутр цепочках адрес следующей ячейки не вычисляется оп формуле
Адрес следующей ячейки хранится в самой таблице

const 
	N=C1;
type
	TIndex=0..N-1;
	TExtIndex=-2..N-1;//-1 - признак конца цепочки
					 //При -2 - признак удаленной
	TCell = record
		inf:TInfo;//TInfo это класс, если nil то инфы нет
		next:TExtIndex;
	end;

constructor THashTable.Create;
var i:TIndex;
begin
	for i := 1 to N do 
	begin
		FTable[i].inf:=nil;
		FTable[i].next:=0;

	end;
	FCount:=0;
end;

Добавление данных в хэш таблицу
TIndex=1..N;
TExtIndex=-N..N; 0-конец цепочки
				 >0-адрес следующей
				 <0 уд, |..|-адр следующей

function THashTable.IndexOf(k:Tkey; var pa:TExtIndex):TExtIndex;
var a_0:TIndex; ok:boolean; stop:boolean;
begin
	pa:=0;
	result:=HashF(k);
	ok:=false;
	while not ok and (result<>0) do
	if FTable[result].inf<>nil and (FTable[result].inf.key=k) then ok:=true
	else
	begin
		pa:=result;
		result:=abs(FTable[result].next);
	end;
end;

function THashTable.Add(info:TInfo):boolean;
var pa,a:TExtIndex;
begin
	result:=true;
	if FCount=N then result:=false
	else
		begin
			a:=IndexOf(info.key,pa);
			if a>0 then result:=false
			else
			begin
				if FTable[pa].inf=nil then
				begin
					FTable[pa].inf:=info;
					FTable[pa].next:=abs(FTable[pa].next);
				end
				else
					begin
						a:=pa;
						repeat
							a:=a mod N+1;
						until FTable[a].inf=nil;
						FTable[a].inf:=info;
						FTable[pa].next:=a;
					end;
			end;
		end;
end;

function THashTable.Delete(key:Tkey):boolean;
var pa,a:TExtIndex;
begin
	a:=IndexOf(key,pa);
	result:=a>0;
	if result then 
		if pa=0 then
			begin
				FreeAndNil(FTable[a].int);
				if FTable[a].next>0 then FTable[a].next:=-FTable[a].next;
			end
		else
			begin
				FreeAndNil(FTable[a].inf);
				FTable[pa].next:=FTable[a].next;
			end;
end;

Составление хэш функции - некий ключ перевести в integer
type 
	Tkey=...;

function HF(key:Tkey):integer;
var i:integer;
begin
	result:='';
	for i:=0 to length(s) do
		result:=result+ord(s[i]);
end;
//для штрих кода
function HF(key:Tkey):integer;
var i:integer;
begin
	result:='';
	for i:=0 to length(s) do
		result:=result+(ord(s[i])-ord('0'));//для букв -ord('а')
end;

function THashTableHashF(key:Tkey):TIndex;
begin
	result:=HF(key)modN; {0..N-1}
end;

Если ключ целое число, тогда не надо переводить

///

'275631400265'
делим по три 
2*100+7*10+5
потом +631
	+400
	+265

function HF(key:Tkey):integer;
var i:integer;
begin
	result:=0;
	i:=1;
	while(i<length(s)) do
	begin
		f:=0;
		k:=0;
		while (j<4) and (i+j<=length(s)) do
		begin
			k:=k*10+ord(s[i+j])-ord('0');//если про буквы то k*26
			inc(j);
		end;
		i:=i+j;
		result:=result+k;
	end;
end;

Анализ хэш функции 25.03.13

как оценить качество хэш функции

сколько раз мы будем попадать в каждую из ячеек
Равномерное попадание во все ячейки таблицы.
Есть константа C - не имеет никакого отношения к разрешению коллизий
Проводим эксперимент для c*N ключей
Количество испытаний должно в несколько раз превосходить размер таблицы

Сумма(a_i-c)^2, i=0,n-1;

var a:array[TIndex] of integer;
k:Tkey;
i:TIndex;
j:integer;
begin
	for i:=0 to N-1 do a[i]:=0;
	for i:=1 to n*c do
	begin
		GenerateKey(k);//cслучайным образом заполним переменную k
		i:=THashTable.HashF(k);
		inc(a[i]);
	end;
	//Далее можно считать оценку
end;

Рехеширование данных
Рехеширование - увеличение размера хэш таблицы без потери данных

THashTable = class
	private
		FTable:array of TCell;
		FCount:integer;
		FSize:integer;//FSize это старое N
	public 
		constructor Create(ASize:integer);
		{SetLength(FTable,ASize);
		FSize:=ASize;
		FCount:=0;
		for i:=0...}
		destructor Destroy; override;
end;

///где должно вызываться рехеширование таблицы
///проблема с добавлением на экзамен!!!!!!!!!!!!!!!!!!!!

procedure THashTable.Rehashing(NewSize:integer);
var 
k,i,j:integer;
A:array of TInfo;
//при рехешировании нельзя просто setlength
//забираем дынные из таблицы, увеличиваем таблицу, обратно все закидываем
begin
	SetLength(A,FCount);
	k:=0;
	for i:=0 to FSize-1 do
		if FTable[i].State=csFull then
		begin
			A[k]:=FTable[i].info;
			inc(k);
		end;
		Create(NewSize);
		for i:=0 to k-1 do
			Add(A[i]);//ВОТ ЭТО ПРОБЛЕМА ВНУТРИ ADD Надо по годному придумать как вызывать РЕХЕШИРОВАНИЕ
		Finalize(A);
end;