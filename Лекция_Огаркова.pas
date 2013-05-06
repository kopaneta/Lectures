function CheckWord(wrd: string):boolean;

procedure Tnode.PrintSomewords(const wrd:string);
	var ch: TIndex;
	begin
		if FPoint and CheckingWord(wrd) then writeln(wrd);
		for ch:=LowCh to HighCh do
		if FNext[ch]<>nil then FNext[ch].PrintSomewords(wrd+ch);
	end;

//если нет подходящих слов - программа ничего не выведет
//булевскую лучше сделать
procedure TTrie.PrintSomewords;
	begin
		if FPoint<>nil then FRoot.PrintSomewords('');
	end;

Посчитать к-во слов удовлетворяющих условию

function Tnode.CountSomeWords(const wrd:string):integer;//если считать нечетные то передавать длину
var ch:TIndex;
begin
	Result:=ord(FPoint and CheckWord(wrd));
	for ch:=LowCh to HighCh do
	if FNext[ch]<>nil then Result:=Result+FNext[ch].CountSomeWords(wrd+ch);
end;


Удалить слова удовлетворяющие какому-либо критерию

function Tnode.DeleteSomeWords(const wrd:string):boolean;
var ch:TIndex;
begin
	if FPoint and CheckWord(wrd) then FPoint:=false;
	for ch:=LowCh to HighCh do
	if (FNext[ch]<>nil) and FNext[ch].DeleteSomeWords(wrd+ch) then FreeAndNil(FNext[ch]);
	Result:=IsEmptyNode;

end;

procedure TTrie.DeleteSomeWords;
	begin
		if FRoot<>nil and FRoot.DeleteSomeWords then FreeAndNil(FRoot);
	end;

-создавать
-загружать
-сохранять в файл

в вкладке файл
-новый
-открыть
-сохранить
-сохранить как
- caption -
-выход

в вкладке правка
-добавить 
-удалить
_________
-очистить

if messagedlg('вы уверены?', mtConfirmation, [mbOk, mbCancel],0)=mrOk then ...

_________
mtConfirmation
mtInformation
mtError
mtWarning
mtCustom
_________


в вкладке поиск
-найти


TGUI_Trie = class(TTrie)
private
FFileName:string;
FModified:boolean;
protected
...
public
  procedure Add(wrd:string)//отследить какие методы повлияют на имя файла и модифицированность
property FileName:string read FFileName;
 _________





uses Classes
 procedure Tnode.ShowTree(SL:tstring; wrd:string)
  var ch:TIndex;
  begin
  	if FPoint then SL.Add(wrd);
  	for ch:=LowCh to HighCh do
  	if FNext[ch]<>nil then FNext[ch].ShowTree(SL,wrd+ch);
  end;
_________
memo.lines[i] - wrong
memo.lines.strings[i] - right
_________

procedure TTrie.ShowTree(SL:Tstrings);
	begin
		SL.Clear;
		if FRoot<>nil then FRoot.ShowTree(SL,'');
	end;

procedure TTrie.SaveToFile(FileName:string);
	var SL:Tstrings;
	begin
		SL:=Tstrings.Create;
		ShowTree(SL);
		SL.SaveToFile(FileName);
		SL.Destroy;
	end;

Примерный код TreeView

procedure Tnode.Show(TV:TTreeView; wrd:string; PN:TTreeNode);
	var ch:TIndex;
	N:TTreeNode;
	begin
		if FPoint then TV.Items.AddNode(PN,'.');
		for ch := LowCh to HighCh  do
		if FNext[ch]<>nil then
		begin
			N:=TV.Items.AddNode(PN,ch);
		end;
FNext[ch].Show(TV,N)

			end;
procedure TTrie.Show(TV:TTreeView);
	begin
		TV.Items.Clear;
		if FRoot<>nil then FRoot.Show(TV,nil);
		TV.FullExpand;//развертка
	end;








































