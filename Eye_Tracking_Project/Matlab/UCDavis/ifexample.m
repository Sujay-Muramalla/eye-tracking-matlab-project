% class example for if

a = -1;
b = 0;

if a > 0
    b = 3;
    c = 'hey';
    d = true;
end

e = b +3; 
% careful! if b does not exist this will give you an error
% in this example we set b = 0 outside of if statement
% if we had not b would not exist since a is not > 0
% Note that if you run this as is, c and d will not exist
% you can try it

x =-3 ;
s = '';

if x > 0
    s = 'x is a positive number';
elseif x < 0 
    s = 'x is a negative number';
else
    s = 'x is 0.'
end

