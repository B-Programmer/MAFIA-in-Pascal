(* A PASCAL - LANGUAGE IMPLEMENTATION OF MAFIA - MAXIMAL FREQUENT ITEMSET ALGORITHM*)
PROGRAM MAFIAInPascal(input, output);
Const
 	MAXITEM = 10;
	MAXTRANSACTION = 50;
 	SIZE = 256;

Type
	Itemset = ARRAY[1..SIZE] OF String;
        ItemTable = ARRAY[1..MAXITEM] OF String;
        TransactionTable = ARRAY[1..MAXTRANSACTION] OF String;
Var
	Item                        : ItemTable;
        Database                    :TransactionTable;
        M, N, L, Min_Sup, K, P 						:Integer;
        XItemset                                    :Itemset;
        FrequentItemset                             :Itemset;
        MaximalFrequentItemset		                :Itemset;
					
	(*Function to generate the Power set *)
Function Power(x : integer; n: integer): Integer;
Begin
	if(n <= 0)then 
		Power := 1
	else
		Power := x * Power(x, n-1)
End;
	(*Function to get last character*)
Function getLastChar(ch :string) :char;
Begin
     getLastChar :=  ch[length(ch)];
End;
	(*Function to get last character*)
Function getIndex(ch :ItemTable; n :Integer; str :string):Integer;
var  i :integer;
Begin
    for i := 1 to n do
    Begin
     if(str = ch[i]) then getIndex := i
    End     
End;
	(*Procedure for reading items *)
Procedure readItems(var I :ItemTable; var m: integer);
var  j: integer;
Begin
  Write('Read in the number of distinct items: '); readln(m);
  Writeln('Read in ',m,' distinct items into set I: ');
  for j := 1 to m do
  Begin
	Write('Read item: ',j,' : '); Readln(I[j]) End
End;
	(*Procedure for reading transactions *)
Procedure readTransactions(var D :TransactionTable; var n :Integer);
Var	j :Integer;
Begin
  Write('Read in the number of Transactions: '); Readln(n);
  Writeln('Read in ',n,' transaction into a Database D:');
  for j := 1 to n do
  Begin Write('Read transation: ',j,' : '); Readln(D[j]) End  
End;
	(*Procedure to generate Itemset *)
Procedure generateItemset(I :ItemTable; var X :Itemset; m :integer);
Var
  k, l, start, endl, j, p, f	:Integer;
  w, y	:string; 
Begin
  for k := 1 to m do
  Begin
        if(k = 1)then
        Begin                                    
             for  l := 1 to m do
                X[l] := I[l]; 
             start := 1; endl := m;
        End
        Else
        Begin
            for j := start to endl do
            Begin
                  w := X[j];
                  if(length(w) > 1)then y := getLastChar(w)
                  else
                      y := w;
                  p := getIndex(I, m, y);
                  for f := p+1 to m do 
		    Begin X[l] := w + I[f]; l := l+1; End;
            End;
            start := endl + 1; endl := l
        End
  End
End;	
	(*Procedure to generate frequent Itemset *)
Procedure generateFrequentItemset(X :Itemset; m :integer; D :TransactionTable; n :integer; var FI :Itemset;
 var k :integer; min_sup:integer);
label 20;
var
  l, noOfFreq, i, j	:Integer;
  itemI, itemJ :String; 
  itemsetI     :ItemTable;
  itemsetT     :Itemset;
Begin
  for i := 1  to power(2, m) do
  Begin
        noOfFreq := 0; itemI := X[i];
        for j := 1  to n do 
        Begin
              itemJ := D[j];
              for l := 1 to length(itemJ) do
                    itemsetI[l] := itemJ[l];
              generateItemset(itemsetI, itemsetT, length(itemJ));
              for l := 1 to power(2, length(itemJ)) do
              Begin
                  if(itemI = itemsetT[l]) then 
                    Begin   noOfFreq := noOfFreq + 1; goto 20 end;
              End; 
20:		(* This is a label line*)			  
        End;         
        if(noOfFreq >= min_sup)then
          Begin  FI[k] := itemI;  k := k + 1   End
  End 
End;
	(*Procedure to generate the Maximal Frequent Itemset *)
Procedure generateMaximalFrequentItemset(FI :Itemset; n :Integer;  var MFI :Itemset; var k :Integer);
label 10, 20;
var
  l, noOfFreq, i, j :Integer;
  itemI, itemJ :String;
  itemsetI     :ItemTable;
  itemsetT : Itemset;
Begin
  for i := n DownTo 1 do
  Begin
        noOfFreq := 0; itemI := FI[i]; 
        for j := n DownTo i+1 do
        Begin
              itemJ := FI[j];
              if(length(itemJ) = length(itemI)) then goto 20;
              if(length(itemJ) > length(itemI)) then
              Begin
                   for l := 1 to length(itemJ) do
                         itemsetI[l] := itemJ[l];
                   generateItemset(itemsetI, itemsetT, length(itemJ));
                   for l := 1 to power(2, length(itemJ)) do
                   Begin   
                       if(itemI = itemsetT[l]) then 
                        Begin   noOfFreq := noOfFreq + 1; goto 10; End
                   End;
              End;
10:
              if(noOfFreq > 0)then goto 20;
        End;
20:
        if(noOfFreq = 0) then
         Begin   MFI[k] := itemI; k := k + 1; End 
  End
End;
    (* Procedure to display the itemset generated*)
Procedure DisplayItemset(ch :Itemset;  n :Integer);
Var
    i :Integer;
Begin
    for i := 1 to n do
     Write(ch[i],', ');
    
    Writeln;
End;
	
 	(*Begin the main procedure for implementing MAFIA *)
Begin
	Writeln('Welcome to Pascal implementation of MAFIA - MAximal Frequent Itemsets Algorithm');
	Writeln('................................................................................');
    readItems(Item, M);
    readTransactions(Database, N);    
    generateItemset(Item, XItemset, M);
    Writeln('********** The Itemset X generated is: ');
	P := Power(2, M);
    DisplayItemset(XItemset, P);
    Writeln('Read in the threshold minimum support of Itemset X: '); 	
	Readln(Min_Sup);
    generateFrequentItemset(XItemset, M, Database, N, FrequentItemset, L, Min_Sup);
    Writeln(' ******The Frequent Itemset X generated is: ');
    DisplayItemset(FrequentItemset, L);
    generateMaximalFrequentItemset(FrequentItemset, L, MaximalFrequentItemset, K);
    Writeln(' ******The Maximal Frequent Itemset X generated is: ');
    DisplayItemset(MaximalFrequentItemset, K);
    Writeln('****** Press any Key to Continue ******');
    Readln;
End.
