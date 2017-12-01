% programa para ler dados dos LISN (extensao .S4) e 
% plotar todos os PRN
% DAE/CEA - INPE - Sao Jose dos Campos

% revisao
% 30/11/2017 - ler dois arquivos em sequencia, e processar - Lazaro Camargo


% formato de entrada
% yy | Day_of_year | Seconds | Number_Records | 1o_PRN | 1o_S4 | 1o_Az |
% 1o_Elev | 2o PRN | ...


% formato da saida:
% yy | Day_of_year | time | PRN | S4 | Az | Elev

clear saida;
clear all

saida3 = [];


% le o primeiro arquivo
[arquivo,caminho] = uigetfile('*.s4');

arquivo_completo1 =fullfile(caminho,arquivo);

CP1 = dlmread(arquivo_completo1);

% le o segundo arquivo
[arquivo,caminho] = uigetfile('*.s4');

arquivo_completo2 =fullfile(caminho,arquivo);

CP2 = dlmread(arquivo_completo2);

CP = cat(1,CP1,CP2)

for m=1:length(CP)

    teste1 = CP(m,:);           %processa linha por linha

    saida = [];
    saida2 = [];
    
    time = (teste1(3))/3600;    %converte para horas
    
    j = 0;
    i = 1;

    for k=1:teste1(4)           %teste1(4) = Number_Records
   
            
        saida(i) =   teste1(4+j+1);     % PRN
        saida(i+1) = teste1(4+j+2);     % S4
        saida(i+2) = teste1(4+j+3);     % Az
        saida(i+3) = teste1(4+j+4);     % Elev
   
        saida2 = cat(1,saida2,[teste1(1) teste1(2) time saida(i) saida(i+1) saida(i+2) saida(i+3)]);
   
        i = i + 4; 
        j = j + 4;
    end

    saida3 = cat(1,saida3,saida2);  %empilha linha por linha
end

saida2


dia = saida3(:,2);
% hora=CP(:,2);

time = saida3(:,3);

prn_l=saida3(:,4);
s4=saida3(:,5);
elev=saida3(:,7);
% 
% dia=CP.dd;
% hora=CP.hh;
% minuto=CP.prn;
% prn_l=CP.prn;
% s4=CP.s4;
% elev=CP.el;




%%Ajustar horário UT 19h do dia anterior até as 7UT 


% Variavel usada para guardar os valores encontrados no arquivo no banco de
% dados

%%Tratar o Time:
%dia = num2str(dia);


tam = length(s4);

for tp=1:tam
    if dia(tp) == dia(1)
        time(tp) = time(tp);
    else 
        time(tp) = time(tp) + 24;
    end
end

%%%%

%time = ((hora*60) + minuto)/60;

% prn=CP(:,4);
% s4=CP(:,5);
% el=CP(:,6);
templist = [time, prn_l, s4, elev];

% O comando abaixo retira da lista os S4 com valores nao desejados

list = templist(find((templist(:, 3) > 0) & (templist(:, 3) < 1.5)), :, :, :);


%%%%%%%%%%%%%%%%%%%%%%% Inicializacao das variaveis %%%%%%%%%%%%%%%%%%%%%%

% A variavel 'pos' guarda um matriz com a posicao dos 32 subplots
pos=[.05 .87 .22 .11; .05 .75 .22 .11; .05 .63 .22 .11; .05 .51 .22 .11; .05 .39 .22 .11; .05 .27 .22 .11; .05 .15 .22 .11; .05 .03 .22 .11;
        .28 .87 .22 .11; .28 .75 .22 .11; .28 .63 .22 .11; .28 .51 .22 .11; .28 .39 .22 .11; .28 .27 .22 .11; .28 .15 .22 .11; .28 .03 .22 .11;
        .51 .87 .22 .11; .51 .75 .22 .11; .51 .63 .22 .11; .51 .51 .22 .11; .51 .39 .22 .11; .51 .27 .22 .11; .51 .15 .22 .11; .51 .03 .22 .11;
        .74 .87 .22 .11; .74 .75 .22 .11; .74 .63 .22 .11; .74 .51 .22 .11; .74 .39 .22 .11; .74 .27 .22 .11; .74 .15 .22 .11; .74 .03 .22 .11];

set(gcf, 'Units', 'Normalized', 'Position', [0 1 1 0.83]);
%set(gcf, 'PaperSize', [297 210], 'PaperPosition', [.05 .1 11.5 8]);
set(gcf, 'PaperType', 'A4', 'PaperOrientation', 'Landscape', 'PaperPosition', [.05 .1 11.5 8]);

%%%%%%%%%%%%%%%%%%%%%%%%%% Plotando o cabecalho %%%%%%%%%%%%%%%%%%%%%%%%%%

subplot('Position', pos(1, :));
axis off;
% text(0, 1.00, ['Lisn 01/09/2014 - Natal', ], 'FontName' , 'Arial', 'FontSize', 12, 'VerticalAlignment', 'Top');
text(0, 1.00, arquivo, 'FontName' , 'Arial', 'FontSize', 12, 'VerticalAlignment', 'Top');
text(0, 0.75, 'LISN', 'FontName' , 'Arial', 'FontSize', 12, 'VerticalAlignment', 'Top');
text(0, 0.55, '', 'FontName' , 'Arial', 'FontSize', 12, 'VerticalAlignment', 'Top');



%%%%%%%%%%%%%%%%%%%%%%%%%% Geracao dos 31 plots %%%%%%%%%%%%%%%%%%%%%%%%%%

for prn = 1:31
       subplot('Position', pos(prn+1, :));
       hold on;
       set (gca, 'Box', 'On', 'FontName' , 'Arial', 'FontSize', 6);
       set (gca, 'XLim', [19 31], 'XTick', [19, 20, 22, 24, 26, 28, 30, 31], 'XGrid', 'on', 'XTickLabel', '');
       set (gca, 'YLim', [0 1.2], 'YTick', [0.0, 0.2, 0.4, 0.6, 0.8, 1.0, 1.2], 'YGrid', 'on', 'YTickLabel', '');
       if (prn >= 24) set (gca, 'YTickLabel', {'', '15', '30', '45', '60', '75', ''}, 'YAxisLocation', 'right'); end;
       if (prn <= 8) set (gca, 'YTickLabel', {'', '0.2', '0.4', '0.6', '0.8', '1.0', ''}); end;
       if (prn == 7) | (prn == 15) | (prn == 23) | (prn == 31) set(gca, 'XTickLabel', {''; '20h'; '22h'; '0h'; '2h'; '4h'; '6h'; ''}); end;

       ax = axis;
       text(ax(1,1), ax(1,4), [' ', num2str(prn)], 'FontName', 'Arial', 'FontSize', 10, 'VerticalAlignment', 'Top');
       
       prnlist = list(find(list(:, 2) == prn), :, :,:);
       
       
       
       
       plot(prnlist(:, 1), prnlist(:, 3), '.r', prnlist(:, 1), (prnlist(:, 4)*1.2/90), '.b');
            
end
   
%set(gcf,'PaperPositionMode','auto')
%%%%%%%%%%%%%%%%%%%%%%%%% Geracao da imagem PNG %%%%%%%%%%%%%%%%%%%%%%%%%%

%eval(['print -dpng -r100 ''', regexprep( 'CP.txt', '.txt', '.png', 'ignorecase'), '''']);

eval(['print -dpng -r100 ''', regexprep( arquivo, '.s4', '.png', 'ignorecase'), '''']);