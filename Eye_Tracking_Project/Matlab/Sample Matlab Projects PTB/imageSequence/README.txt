Image Sequence

On each trial this code shows one image, along with (optionally) a text string, and then (optionally) waits for a subject response.  The example is set up to run a search task: on each trial you are prompted to look for an object, then you are shown a scene, and you must respond whether the target is present or absent by pressing y or n.



To modify the code for your experiment:

Put your images in the images folder.  Your results will be saved in the results folder.

If you want to include text in your experiment, replace the text file with your own list of text items.  The code assumes that the text file and images are in the same order (line 1 of the text file will appear on the same trial as the first image, line 2 with the second image, etc.).  To ensure that the text appears with the right image, I strongly recommend that you start each image file name with a number.

Modify the settings in the file settingsImageSequence.m to suit your experiment.



For memory experiments:

If you just want to show a series of images (like for the training phase of a memory experiment), turn off the text option and the response option, and set the trial timeout to the presentation time for your images.  You can make these changes in the settings file, no need to modify the main program.