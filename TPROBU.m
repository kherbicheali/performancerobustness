clear all
close all

% Trac� d'un gabarit g�n�rique pour le TP

%% Param�trage :

w1 = 1; % Intersection de l'asymptote basse fr�quence avec l'axe des abscisses
n1 = 1; % Pente (*20dB/dec) de l'asymptote basse fr�quence

w2 = 1.37; % bande passante [0;w2] sur T / bande att�nu�e sur S
a2 = 1-(1/sqrt(2)); % facteur d'att�nuation dans la bande att�nu�e de S

a3 = 100*exp(0.91*pi/(sqrt(1-0.91^2))); % norme Hinfinie maximale sur S//
%a3 = 100*exp(0.8*pi/(sqrt(1-0.8^2)));
w4 = 200*pi; % bande att�nu�e [w4;inf] sur T / canal de bande passante sur S //
a4_1 =0.999 ; % minimum d'amplitude dans le canal de bande passante sur S//
a4_2 = 1.001; % maximum d'amplitude dans le canal de bande passante sur S//

%% Trac� du gabarit dans le diagramme de bode de S :

wlogmin = -3;
wlogmax = 4;
wmin = 10^wlogmin;
wmax = 10^wlogmax;
Gmin = -80;
Gmax = 60;
w = logspace(wlogmin,wlogmax,2000); % Echantillon de fr�quences en �chelle log
figure(1);
ha = axes;
set(ha,'XScale','log');

hold on
h1=line([wmin w1 w1],[n1*20*log10(wmin/w1) 0 Gmax]);
h2=line([wmin w2 w2],[20*log10(a2) 20*log10(a2) Gmax]);
h3=line([wmin wmax],[20*log10(a3) 20*log10(a3)]);
h4_1=line([w4 w4 wmax],[Gmin 20*log10(a4_1) 20*log10(a4_1)]);
h4_2=line([w4 w4 wmax],[Gmax 20*log10(a4_2) 20*log10(a4_2)]);

%set([h1;h2;h3],'Color',[0 1 0]);
%set([h4_1;h4_2],'Color',[1 0 0]);

figure(2)
hab = axes;
set(hab,'XScale','log');

hold on
% h1b=patch([wmin w1 w1 wmin],[n1*20*log10(wmin/w1) 0 Gmax Gmax],[0.7 1 0.7]);
% print -dpdf gabarit1
h2b=patch([wmin w2 w2 wmin],[20*log10(a2) 20*log10(a2) Gmax Gmax],[0.7 1 0.7]);
%print -dpdf gabarit2
% h3b=patch([wmin wmax wmax wmin],[20*log10(a3) 20*log10(a3) Gmax Gmax],[0.7 1 0.7]);
% print -dpdf gabarit3
% h4_1b=patch([w4 w4 wmax wmax],[Gmin 20*log10(a4_1) 20*log10(a4_1) Gmin],[1 0.7 0.7]);
% h4_2b=patch([w4 w4 wmax wmax],[Gmax 20*log10(a4_2) 20*log10(a4_2) Gmax],[1 0.7 0.7]);
% print -dpdf gabarit4
grid on
%set([h1b;h2b;h3b],'FaceAlpha',0.2);
%set([h4_1b;h4_2b],'FaceAlpha',0.2);

%% Trace initial du diagramme de Bode de S
%%kk=0.335;
kk=0.3713;
%max 2.3
%a=20/6.75 = 2.963 qu'il ne faut absolument pas d�passer

a=2.703;


%%tt=a*kk;
tt=1.1;
ng=[16 20];
dg=[1 7 12.75 6.75];
nk=[kk*tt kk];
dk=[tt 0];
%%%Boucle ouverte
zs=tf(ng,dg)*tf(nk,dk);
%% Sensibilite
ss=1/(1+zs);
%% T 
t=zs*ss;  % cosensibilite
%%S = tf([1 2 0],[1 1 5]);
%%GS = 20*log10(squeeze(abs(freqresp(S,w))));
GS = 20*log10(squeeze(abs(freqresp(ss,w))));
hBodeS = plot(w,GS,'b-');
grid on

%print -djpeg touslesgabarits

%% Iteration du trace

%%S = tf([1 2 0],[1 1 5]);
%%GS = 20*log10(squeeze(abs(freqresp(S,w))));
%GS = 20*log10(squeeze(abs(freqresp(ss,w))));
set(hBodeS,'YData',GS);



%GSS = 20*log10(squeeze(abs(freqresp(t,w))));

%%Bode de T pour trouver wc pulsation de coupure
figure(3)
bodemag (t);
grid on
%hBodeS = plot(w,GSS,'b-');



%% Feedback de T    question 12

feed= feedback(t,1);
%feed2= feedback(tf(kk,[1 0]),1);
figure(4)
step(feed);
%hold on 
%step(feed2);
grid on

%%Feedback de S question 12
feed3= feedback(ss,1);
figure (8)
step(feed3);

%% Bode asymptotique question 2
bod=tf(nk,dk);
figure (5)
bode(bod)
grid on

%% Black boucle ouverte 
figure (6)
nichols(zs);

%% Nyquist de S pour dire que notre systeme est stable loin du popint -1 question 11
figure (7)
nyquist(ss);
