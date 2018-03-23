Visual Search

This code runs a standard visual search task.  It is currently set up to do a "T among L" search task.  On each trial, the subject should press "p" if a T is present in the display, and "a" if the T is absent.



To modify the code for your experiment:

Put your target and distractor images in the images folder.  Change the image names in the settingsVisualSearch.m file.  Currently, the code only allows for one target and one distractor, but you can choose to randomly rotate the distractors to add more variation.

You can change the set sizes in the settingsVisualSearch.m file, and choose whether different set sizes are blocked or interleaved.  You can also modify timing, response keys, and some other parameters in the settingsVisualSearch.m file.