function GazeData = ParseGazeData(gazedataleft, gazedataright)
%PARSEGAZEDATA is used to parse the gazedata from each eye.

    if ~isempty(gazedataleft)
        GazeData.left_eye_position_3d.x = gazedataleft(1);
        GazeData.left_eye_position_3d.y = gazedataleft(2);
        GazeData.left_eye_position_3d.z = gazedataleft(3);
        GazeData.left_eye_position_3d_relative.x = gazedataleft(4);
        GazeData.left_eye_position_3d_relative.y = gazedataleft(5);
        GazeData.left_eye_position_3d_relative.z = gazedataleft(6);
        GazeData.left_gaze_point_2d.x = gazedataleft(7);
        GazeData.left_gaze_point_2d.y = gazedataleft(8);
        GazeData.left_gaze_point_3d.x = gazedataleft(9);
        GazeData.left_gaze_point_3d.y = gazedataleft(10);
        GazeData.left_gaze_point_3d.z = gazedataleft(11);
        GazeData.left_pupil_diameter = gazedataleft(12);
        GazeData.left_validity = gazedataleft(13);
    end

    if ~isempty(gazedataright)
        GazeData.right_eye_position_3d.x = gazedataright(1);
        GazeData.right_eye_position_3d.y = gazedataright(2);
        GazeData.right_eye_position_3d.z = gazedataright(3);
        GazeData.right_eye_position_3d_relative.x = gazedataright(4);
        GazeData.right_eye_position_3d_relative.y = gazedataright(5);
        GazeData.right_eye_position_3d_relative.z = gazedataright(6);
        GazeData.right_gaze_point_2d.x = gazedataright(7);
        GazeData.right_gaze_point_2d.y = gazedataright(8);
        GazeData.right_gaze_point_3d.x = gazedataright(9);
        GazeData.right_gaze_point_3d.y = gazedataright(10);
        GazeData.right_gaze_point_3d.z = gazedataright(11);
        GazeData.right_pupil_diameter = gazedataright(12);
        GazeData.right_validity = gazedataright(13);
    end
end
