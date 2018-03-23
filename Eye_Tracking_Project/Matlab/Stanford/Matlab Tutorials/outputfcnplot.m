function stop = outputfcnplot(params,optimValues,state,numiters,data)

% function stop = outputfcnplot(params,optimValues,state,numiters,data)
%
% <params> is the current optimization parameter
% <optimValues>,<state> are optimization state stuff
% <numiters> (optional) is to plot after every this number of iterations.
%   default: 10.
% <data> (optional) is a (row or column) vector of values indicating 
%   the data that the optimizer is fitting
%
% in the 'init' state, make a new figure window.
% in the 'iter' and 'done' states, update two subplots
%   every <numiters> iterations.  in the first subplot, plot
%   the parameter history.  in the second subplot,
%   plot the current parameter values.  if 'q' is pressed
%   in this figure window, stop the optimization.
%   if 'p' is pressed, issue a keyboard command.
%
% if <data> is supplied, we actually make a third subplot
% showing the data and the current model fit.
%
% NOTE: this is a bare-bones version of the outputfcnplot.m
% function in the knkutils github repository.

% input
if ~exist('numiters','var') || isempty(numiters)
  numiters = 10;
end
if ~exist('data','var') || isempty(data)
  data = [];
end
data = data(:)';

% global stuff
global OUTPUTFCNPLOT_PARAMSHISTORY;

% calc
if isempty(data)
  nsubplots = 2;
else
  nsubplots = 3;
end

% do it
switch state
case 'init'
  OUTPUTFCNPLOT_PARAMSHISTORY = [];
  figure;
case {'iter' 'done'}
  OUTPUTFCNPLOT_PARAMSHISTORY = [OUTPUTFCNPLOT_PARAMSHISTORY; params];
  if mod(optimValues.iteration,numiters)==0
    clf;
    subplot(nsubplots,1,1); plot(OUTPUTFCNPLOT_PARAMSHISTORY); xlabel('Iteration number'); ylabel('Parameter value');
    subplot(nsubplots,1,2); bar(params); xlabel('Parameter number'); ylabel('Parameter value'); title(mat2str(params));
    if ~isempty(data)
      subplot(nsubplots,1,3); hold on;
      fit = optimValues.residual(:)' + data;  % what is the current fit?
      r = corr(fit(:),data(:));
      bar(data);
      plot(fit,'g-','LineWidth',2);
      ax = axis; axis([0 length(data)+1 ax(3:4)]);
      xlabel('Data point'); ylabel('Value');
      title(sprintf('r = %.3f',r));
    end
    drawnow;
    if isequal(get(gcf,'CurrentCharacter'),'q')
      stop = 1;
      return;
    end
    if isequal(get(gcf,'CurrentCharacter'),'p')
      keyboard;
    end
  end
end

% return
stop = 0;
