// Огаркова лекция 06.05.13
// многопутевое слияние
// f1 1 2 7 ' 4 19 ' 10 15 ' 6 27 ' 20 21 ' 14 18 30 ' 25
// f1 1 2 7 10 15 20 21 25
// f2 4 19 6 27 14 18 30

function Merge(f1,f2,f0: TSequence):integer;
begin
	f1.StartRead;
	f2.StartRead;
	f0.StartWrite;
	Result:=0;
	while not f1.eof and not f2.eof do
	begin
		while not f1.eor and not f2.eor do
		if f1.elem<=f2.elem then 
			f1.Copy(f0)
		else
			f2.Copy(f0);
		if not f1.eor then 
			f1.CopyRun(f0)
		else
			f2.CopyRun(f0);
		inc(Result);
		f1.StartRun;
		f2.StartRun;
	end;
	
	while not f1.eof do
	begin
		f1.CopyRun(f0);
		inc(Result);
	end;
	
	while not f2.eof do
	begin
		f2.CopyRun(f0);
		inc(Result);
	end;

	f1.Close;
	f2.Close;
	f0.Close;
end;

// процедура Sort переделанная
repeat
	Distribute(f0,f1,f2)
until Merge(f1,f2,f0)=1;//если файл пуст, то Merge должен быть<=1


// слияние должно быть сбалансированным по сериям, а не по файлам

// Для сбалансированного слияния
Distribute
// 1. Необходимо открыть файл
// 2. f0.CopyRun(f1);
// 	  if not f0.eof then f0.CopyRun(f2)
//  то есть в каждый из вспомогательных файлов отправить по одной серии
// 3. while not f0.eof do
// 	  begin
// 		если серия из f0 является продолжением серии из f1 то
// 			в f1 надо записать 2 серии из f0
// 		иначе в f1 записать одну серию из f0
// 		if not f0.eof then
// 			begin
// 				if f0.elem>=f2.elem then
// 					begin
// 						f0.CopyRun(f2);
// 						if not f0.eof then
// 							f0.CopyRun(f2);
// 					end;
// 				else f0.CopyRun(f2);
// 			end;
// 	  end;
// 4. Закрыть файл


// Многопутевое простое двухфазное слияние

// f0: 2 7 5 11 9 8 6 1 2 11
// f1: 2 9 3
// f2: 7 8 11
// f3: 5 6
// f4: 11 1

// f0: 2 5 7 11 1 6 8 9 3 11
// f1: 2 5 7 11
// f2: 1 6 8 9
// f3: 3 11
// f4:

// f0:1 2 3 4 5 6 7 8 11 11

TSequence = class
private
	FSeq: array of TSequence;
	FCnt:integer; //количество вспомогательных файлов
protected
	

public
	constructor Create(Names: array of string);
	destructor Destroy; override;
	// пригодились бы StartRead, StartWrite, Close, Erase, StartRun
	function Merge(f0:TSequence; var len:integer):integer;
	///
end;

function TSequence.FillMap(var map: array of integer):integer;
var 
	i:integer;
	len:integer;
begin
	Result:=0;
	for i:=0 to FCnt-1 do
		begin
			FSeq[i].StartRun(len);
			if not FSeq[i].eof then
			begin
				map.Result:=i
				inc(Result);
			end;
		end;
end;

procedure TSequence.MergeRun(f0:TSequence; len:integer);
var
// некрасивый код, например
// Карту индексов лучше делать полем TSequence
	map: array of integer;
	m:integer;
begin
	SetLength(map, FCnt);
	m:=FillMap(map,len);//слияние будет идти до тех пор пока в карте индексов больше чем один элемент
	while (m>1) do
	begin
		imin:=0;
		for i:=1 to m-1 do
			if FSeq[m[i]]<FSeq[map[imin]]
				then imin:=l;
		FSeq[map[imin]].Copy(f0);
		if FSeq[map[imin]].eor
			then begin
				map[imin]:=map[m-1];
				dec(m);
			end;		
	end;
	FSeq[map[0]].CopyRun(f0);
end;

function TSequence.Merge(var len:integer):integer;
begin
	StartRead(len);
	f0.StartWrite;
	m:=FillMap(map, len);
	while m>0 do
		begin
			MergeRun(f0,len);
			m:=FillMap(map,len);
		end;
		Close;
		f0.Close;
		len:=len*FCnt;
end;
