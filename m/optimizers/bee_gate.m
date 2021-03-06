function [x,f,exitflag,obj]=bee_gate(PROBLEM)
%  BEE_GATE attempts to find the global minimum of a constrained function of
%  several variables.
%   BEE_GATE attempts to solve problems of the form:
%    min F(X)  subject to:  LB <= X <= UB   (bounds)
%     X
%
%   RES = BEE_GATE(FUN,X0,LB,UB) starts at X0 and finds a minimum X to the
%   function FUN, subject to the bound constraints LB and UB. FUN accepts
%   input X and returns a scalar function value F evaluated at X. X0 may be
%   a scalar or a vector.
%
%   [X,F,OBJ] = BEE_GATE(FUN,X0,LB,UB,OPTIONS) optimizes the function FUN under the
%   optimization options set under the structure OPTIONS. The fields of
%   this structure could be all or any of the following:
%       - 'colony_size': this the number of different elements in the group
%       that will share information with each other in order to find better
%       solutions. The default is 20
%       - 'max_iter': the maximum number of iterations. The default is 1000
%       - 'max_time': The time budget in seconds. The default is 3600
%       - 'max_fcount': the maximum number of function evaluations. The
%       default is inf
%       - 'rand_seed': the seed number for the random draws
%    X if the optimum, F is the value of the objective at X, OBJ is an
%    object with more information
%
%   Optimization stops when one of the following happens:
%   1- the number of iterations exceeds max_iter
%   2- the number of function counts exceeds max_fcount
%   3- the time elapsed exceeds max_time
%   4- the user write anything in and saves the automatically generated
%   file called "ManualStopping.txt"
%
%   Examples
%     FUN can be specified using @:
%        X = bee_gate(@myfunc,...)
%     In this case, F = myfunc(X) returns the scalar function value F of
%     the MYFUNC function evaluated at X.
%
%     FUN can also be an anonymous function:
%        X = bee_gate(@(x) 3*sin(x(1))+exp(x(2)),[1;1],[],[],[],[],[0 0])
%     returns X = [0;0].
%
%     FUN=inline('sum(x.^2)'); n=100;
%     lb=-20*ones(n,1); ub=-lb; x0=lb+(ub-lb).*rand(n,1);
%     optimpot=struct('colony_size',20,'max_iter',1000,'max_time',60,...
%     'max_fcount',inf);
%     x=bee_gate(@(x) FUN(x),x0,lb,ub,optimpot)

%   Copyright 2011 Junior Maih (junior.maih@gmail.com).
%   $Revision: 7 $  $Date: 2011/05/26 11:23 $

% OtherProblemFields={'Aineq','bineq','Aeq','beq','nonlcon'};
Objective=PROBLEM.objective;
x0=PROBLEM.x0;
lb=PROBLEM.lb;
ub=PROBLEM.ub;
options=PROBLEM.options;

 fields=fieldnames(options);
 bee_options=[];
 for ii=1:numel(fields)
     fi=fields{ii};
     if (strcmpi(fi,'max_iter')||strcmpi(fi,'MaxIter'))&&~isempty(options.(fi))
         bee_options.max_iter=options.(fi);
     elseif (strcmpi(fi,'MaxFunEvals')||strcmpi(fi,'max_fcount'))&&~isempty(options.(fi)) 
         bee_options.max_fcount=options.(fi);
     elseif (strcmpi(fi,'max_time')||strcmpi(fi,'MaxTime'))&&~isempty(options.(fi)) 
         bee_options.max_time=options.(fi);
     elseif (strcmpi(fi,'MaxNodes')||strcmpi(fi,'colony_size') )&&~isempty(options.(fi))
         bee_options.colony_size=options.(fi);
     end
 end
bee_options.restrictions=PROBLEM.nonlcon;

obj=bee(Objective,x0,[],lb,ub,bee_options);

x=obj.best;
f=obj.best_fit;

if obj.iter>=obj.max_iter || ...
        obj.fcount>=obj.max_fcount || ...
        etime(obj.finish_time,obj.start_time)>=obj.max_time
    exitflag=0; % disp('Too many function evaluations or iterations.')
else
    exitflag=-1; % disp('Stopped by output/plot function.')
end
        
                    
