%practicing tables 
load patients
patients = table(Age,Gender,Height,Weight,LastName);
T1 = patients(1:5,:);
rows = patients.Weight < 130;
vars = {'Gender','Weight'};
T3 = patients(rows,vars);
T3 = T3(1:5,1:2)
rows2 = patients({'Female'})
