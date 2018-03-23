
% Open file in append mode
[outfile message] = fopen('test.txt', 'a');

if outfile == -1
    fprintf ('Couldn''t open output file. \n%s\n', message);
end

subjectname = input ('Subject name : ', 's');
subjectno = input ('Subject number : ');
runtype = input ('Run type - enter 1 for practice, 2 for full experiment: ');
% Currently this does not do anything but you could use it later to set
% different numbers of trials
ntrials = 5;
thedate = date;

filename = [num2str(subjectno)];

% Writing subject info
fprintf (outfile,'\nSubject name: %s\nSubject number: %d\nDate: %s\nRun type: %d\r\n\r\n', ...
    subjectname, subjectno, thedate, runtype);

% Writing header row
fprintf (outfile, 'trial\thand\taccuracy\tRT\r\n');

% Going through trials - as an example we are making up data and conditions
% You can combine with previous examples to collect real data
for i=1:ntrials
    acc = round(rand());% making up data 0 or 1
    rt = rand(); % still making up data between 0 and 1
    if round(rand()) == 0, % flipping a coin for experimental trial
        hand = 'left';
    else
        hand = 'right';
    end;
    fprintf (outfile, '%d\t%s\t%d\t%f\r\n', i, hand, acc, rt);
    % \n also works for new line for most systems/text editors
    % except Notepad does not recognize it so we are using \r\n
end

% Adds a new line
fprintf (outfile, '\r\n');

fclose (outfile);



    

