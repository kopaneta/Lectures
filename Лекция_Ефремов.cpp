bool get_next_assign_lex(std::vector<int> &A, int N, int M)
)
{
	std::vector<bool> fr;//занят - false
	fr.assign(N,true);
	int i;
	for (i=0; i<M; i++) fr[A[i]-1]=false;
	i = M;
	while (i>0 && get_next_assign_lex(fr, A[i-1]-1)==0)
	{
		fr[A[i-1]-1]=true;
		i--;
	}

	if (i==0) return false;
	fr[A[i-1]-1]=true;
	int q=1;
	get_first_free(fr, A[i-1]);
	fr[q]=false;
	A[i-1]=q+1;
	int k=1;
	for (int j = i+1; j < M; j++)
	{
		while (k<=N && fr[k-1]==false)
		{
			if (k>=N)
			{
				k=1;
			}
			else k++;
		}
		A[j-1]=k;
		fr[k-1]=false;
	}
	return true;
}

int get_first_free(const std::vector<bool> &v, int pos)
{
	while (pos<v.size())&&v[pos]==false
		pos++;
	return p<v.size() ? pos:0;
}

/*Следующая задача*/
/*как сделать ебовую индексацию
1) N+1 элемент std::vector 0,[1..N]
2) #include <map>
	std::map<int,int> A;
	A[1]=1;
*/

//Задано  N,M и номер L, найти размещения заданного номера
8div3=2
L=8mod3=2


заданы n m и A
L-> ?
A=3 4 5 N=5 M=3
2*A_4^2+...

Сочетания(выборки)
выбрать из 27 человек 5 автоматчиков сколькими способами это можно сделать

В размещениях важен порядок
Сочетания это выбор M элементов из N штук без учета порядка элеиентов

C_N^M=(N!)/(M!(N-M)!)

long get_comb_out(int N,int M)
{
	std::vector<int> prev_col, cur_col;
	cur_col.assign(N+1,1);
	prev_col=cur_col;
	
}