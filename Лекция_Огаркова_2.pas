unit UInfo;
interface
type
	TKey=string[11];
	TKey = record
		operator:700...999;
		number: 0...9999999;
		end;

	TInfo = class
	private
	Fkey:TKey;
	...
	protected
	...
	public
	constructor Create;
	destructor Destroy; override;
	function LoadFromFile(var f:TextFile):boolean;
	procedure SaveToFile(var f:TextFile);
	function IsEqual(info1:TInfo):boolean;
	property key:TKey read Fkey;
	...
		
	end;

unit UHash;

interface
	const N=29;
uses
	SysUtils, Classes,UInfo,Grids;//Grids для TstringRead
	type
		TCellState=(csFree,csFull,csDel);
		TCell=record
			info:TInfo;
			state:TState;
		end;
	TIndex=0...N-1;
	TTable=array[TIndex] of TCell;

	THashTable=class
	private
		FTable:TTable;
		FC:integer;
		FCount:integer;
	protected
		function HashF(key:TKey):TIndex;
		function NextCell(a_0:integer; var i:integer):TIndex;
		function IndexOf(key:TKey):integer;
	public
		constructor Create(AC:integer);
		destructor Destroy; override;
		procedure Clear;//можно virtual
		function Add(info:TInfo):boolean;
		function Delete(key:TKey):boolean;//удаление по ключу возможно, если ключи уникальны
		function Find(key: TKey; var Info:TInfo):boolean;
		...
		procedure ShowToSG(SG:TStringRead)



implementation
	...Create:
	var i:TIndex;
	begin
		FCount:=0;
		FC:=HC;
		for i:=0 to N-1 do
			FTable[i].state:=csFree;
	end;

	...Clear:
	for i:=0 to N-1 do
	if FTable[i].state=csFull then
	begin
		FTable[i].info.Destroy;
		FTable[i].state:=csFree;
	end;
	FCount:=0;

	...Destroy
	Clear;
	inherited Destroy;

	...HashF
		...//если ключ как запись все здесь
			//если ключ как класс - никак
			//на уровне класса Tkey писать свою хэш функцию, возвращающюю
			//integer

	...NextCell
		inc(i);
		Result:=a_0+i*FC;

	function THashTable.IndexOf;
	var a_0,a:TIndex;//а0 - начальный, а - текущий
		i:integer;
		ok,stop:boolean;
	begin
		a_0:=HashF(key);
		a:=a_0;
		i:=0;
		ok:=false;
		stop:=false;
		repeat
			case FTable[a].state of 
			csFree: stop:=true;
			csDel: a:=NextCell(a_0,i);
			csFull:
				if FTable[a].Info.key.IsEqual(key) then
				ok:=true
				else
					a:=NextCell(a_0,i);
		until ok or stop or (i>N);//для избежания зацикливания
		if ok then Result:=a
		else Result:=-1;
		end;

	

	end;

	...Find:
	var
	 a:integer;
	 begin
	 	a:=IndexOf(key);
	 	result:=a>=0;
	 	if Result then info:=FTable[a].info;
	 end;


	...Delete:
	var a:integer;
	begin
		a:=IndexOf(key);
	 	result:=a>=0;
	 	if Result then
	 	begin
	 	 	FTable[a].info.Destroy;
	 	 	FTable[a].state:=csDel;
	 	 	//dec{fcount}
	 	 end; 
	end;


end.

	function THashTable.Add(info:TInfo):boolean;
	var
	a_0,a:TIndex;
	d,i:integer;
	ok,stop:boolean;
	begin
		if FCount=N then result:=false
		else
		begin
			a_0:=HashF(info.key);
			a:=a_0;
			i:=0;
			while (FTable[a].state=csFull) and (i<n) do
				a:=NextCell(a_0,i);
		end;
	end;

	function THashTable.Add(info:TInfo):boolean;
	var
	a_0,a:TIndex;
	d,i:integer;
	ok,stop:boolean;
	begin
		if FCount=N then result:=false
		else
		begin
			a_0:=HashF(info.key);
			a:=a_0;
			i:=0;
			d:=-1;
			ok1:=false;
			stop:=false;
			repeat
				case FTable[a].state of
				csFree:stop:=true;
				csDel:begin
					if d=-1 then d:=a;
					a:=NextCell(a_0,i);
				end;
				csFull:
				if FTable[a].info.key.IsEqual(info.key) then ok:=true
				else
				a:=NextCell(a_0,i)
				end;
			until ok or stop or (i>N);
			if ok then result:=false
			else
			begin
				if d=-1 and stop then d:=a;
				result:=d>-1;
				if result then 
				begin
					FTable[d].info:=info;
					FTable[a].state:=csFull;
					inc(FCount);
				end;
			end;
		end;
	end;


	procedure THashTable.ShowToSG(SG:TstringRead);
	var i:TIndex;
		j:TIndex;
	begin
		with SG do
		begin
			if FCount=0 then
			begin
				RowCount:=2;
				Rows[1].Clear;
			end
			else
			RowCount:=FCount+1;
			{количество столбцов + заголовки}
			///дальше чет вообще
			j:=0;
			for i:=0 to N do
				if FTable[i].state=csFull then
				begin
					j:=j+1;
					FTable[i].info.ShowToGrid(Rows[j])
				end;
			end;
	end;


a_i=a_0+c*i , где c=const
a_i=a_0+c_i+d_i^2, где c,d=const

Двойное хеширование
a_i=h(k)+h_2(k)*i
a_0=H_k
{TKey=class
private
  Let1:char;
  Num:1...999;
  FLet23:string[2];
  Freg:byte;
protected
	.....
	function GetAsString: string;
	procedure SetAsString(value:string);

public
	constructor Create;
	...
	function IsEqual(key:TKey):boolean;
	class function CheckKey(s:string):boolean;//функция одна для всех экземпляров класса
	...
	property AsString:string read GetAsString write SetAsString;
}
