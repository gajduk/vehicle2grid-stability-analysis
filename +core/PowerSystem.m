classdef PowerSystem
    %A description of a power system case.
    
    properties
        baseMVA;  
        Ybus;
        THETA0_GEN;
        nb;
        ng;   
        EMF;
        Pm;
        M;
        D;
        SL;
        V0;
        THETA0_BUS;
        IG_EMF;
    end
    
    methods
        function this = PowerSystem(baseMVA,Ybus,THETA0_GEN,nb,ng,EMF,Pm,M,D,SL,V0,THETA0_BUS,IG_EMF)
           if nargin > 0 
                this.baseMVA = baseMVA;  
                this.Ybus = Ybus;
                this.THETA0_GEN = THETA0_GEN;
                this.nb = nb;
                this.ng = ng;   
                this.EMF = EMF;
                this.Pm = Pm;
                this.M = M;
                this.D = D;
                this.SL = SL;
                this.V0 = V0;
                this.THETA0_BUS = THETA0_BUS;
                this.IG_EMF = IG_EMF;
           end
        end
    end
    
end

