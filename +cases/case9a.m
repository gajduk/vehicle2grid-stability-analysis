function mpc = case9a
%CASE9    Power flow data for 9 bus, 3 generator case.
%   Please see CASEFORMAT for details on the case file format.
%
%   Based on data from Joe H. Chow's book, p. 70.

%   MATPOWER
%   $Id: case9.m,v 1.11 2010/03/10 18:08:14 ray Exp $

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 100;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
	1	3	0	0	0	0	1	1	0	345	1	1.1	0.9;
	2	2	0	0	0	0	1	1	0	345	1	1.1	0.9;
	3	2	0	0	0	0	1	1	0	345	1	1.1	0.9;
	4	1	0	0	0	0	1	1	0	345	1	1.1	0.9;
	5	1	90	30	0	0	1	1	0	345	1	1.1	0.9;
	6	1	0	0	0	0	1	1	0	345	1	1.1	0.9;
	7	1	100	35	0	0	1	1	0	345	1	1.1	0.9;
	8	1	0	0	0	0	1	1	0	345	1	1.1	0.9;
	9	1	125	50	0	0	1	1	0	345	1	1.1	0.9;
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
	1	0	0	300	-300	1	100	1	250	10	0	0	0	0	0	0	0	0	0	0	0;
	2	163	0	300	-300	1	100	1	300	10	0	0	0	0	0	0	0	0	0	0	0;
	3	85	0	300	-300	1	100	1	270	10	0	0	0	0	0	0	0	0	0	0	0;
    % Vo sledniot red e dodaden fiktiven generator so koj se simulira kruta
    % mreza (infinite bus) koj vo nikoj slucaj ne moze da bide izvaden od
    % stabilna rabotna tocka (sekogas ke ima konstantna brzni na vrtenje).
    % Za da ne dojde do izmenuvanje na rabotnata tocka na drugite
    % generatori na ovoj generator mu e stavena moknost ednakva na nula (i
    % toa i aktivna i reaktivna).
	1	0	0	  0	   0	1	100	1  9999	10	0	0	0	0	0	0	0	0	0	0	0;
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
	1	4	0	0.0576	0	250	250	250	0	0	1	-360	360;
	4	5	0.017	0.092	0.158	250	250	250	0	0	1	-360	360;
	5	6	0.039	0.17	0.358	150	150	150	0	0	1	-360	360;
	3	6	0	0.0586	0	300	300	300	0	0	1	-360	360;
	6	7	0.0119	0.1008	0.209	150	150	150	0	0	1	-360	360;
	7	8	0.0085	0.072	0.149	250	250	250	0	0	1	-360	360;
	8	2	0	0.0625	0	250	250	250	0	0	1	-360	360;
	8	9	0.032	0.161	0.306	250	250	250	0	0	1	-360	360;
	9	4	0.01	0.085	0.176	250	250	250	0	0	1	-360	360;
];

%% dynamics data
mpc.f = 60;

mpc.dynamics = [
    % Bidejki za generatorite nema zadadeni podatoci za prividnata moknost
    % i reaktanciite na generatorite i nivnite transformatori jas gledajki
    % gi nivnite moknosti vo gornite podatoci (mpc.gen) oceniv deka tie
    % imaa moknosti od 100, 200 i 100 MVA. Vrednsta za XG od 0.3 pu e
    % tipicna vrednost za generatori vo termocentrali, a XT obicno e okolu
    % 0.1 pu. Konstantata H ja staviv 3 sekundi sto znaci deka ako moknosta
    % na turbinata e ednakva na nominalnata generatorot ke se zaleta od
    % miruvanje do nominalna brzina na vrtenje za 6 sekundi (sto e pak
    % tipicna brojka na takvi generatori).
%    S(MVA)   XG(pu)   XT(pu)       H(s)  D(MWs/rad)
       100     0.3      0.1          3     0
       200     0.3      0.1          3     0
       100     0.3      0.1          3     0
      % Vo sledniot red se dadeni parametrite na fiktivniot generator za
      % koj e zadadena mnogu golema moknost od 9999 MVA, mnogu mala
      % reaktancija od 1e-4 pu (so sto naponskiot generator e prakticno
      % idealen) i mnogu golema konstanta H od 1e4 sekundi so sto toj
      % prakticno ima beskonecen moment na inercija (koga nekoja turbina so
      % moknost od 9999 MW bi probala da go zaleta vakviot generator od
      % miruvanje do nominalna brzni na vrtenje (50 ili 60 vrtezi vo
      % sekunda) ke i treba vreme od 2e4 sekundi.
      9999     1e-4     0.0        1e4     0
];

% Varijanta 1 (malo poremetuvanje): ispad na potrosuvac vo jazelot 5,
% sistemot ne se vraka vo normalna sostojba (nema mpc.events(2).type = 99;)
% mpc.events(1).type = 2;
% mpc.events(1).time = 0;
% mpc.events(1).location = 5;

% Varijanta 2 (golemo poremetuvanje): trifazna kusa vrska kaj jazelot 2,
% sistemot se vraka vo normala po 0.1 sekunda (mpc.events(2).type = 99;)
mpc.events(1).type = 5;
mpc.events(1).time = 0;
mpc.events(1).location = 2;
mpc.events(2).type = 99;
mpc.events(2).time = 0.1;