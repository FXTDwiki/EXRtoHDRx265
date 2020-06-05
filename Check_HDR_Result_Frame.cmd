@Echo off

IF [%1]==[] (
IF [%2]==[] (
Echo The syntax is "capture_frame sourcevideo.ext frame_to_extract"
Echo Where sourcevideo.ext is the video where you want to extract the image
Echo And frame_to_extract is the frame to extract in the video
goto exit
)
)

IF [%1]==[] (
Echo Missing Filename
goto exit
) ELSE (
Set Filename=%1
)

IF [%2]==[] (
Echo Missing Frame Number to extract
goto exit
) ELSE (
Set Frame=%2
)

Set "File=%Filename:.=" & rem."%"
Set FPS=25
Set /a time=%Frame%/%FPS%

IF %Frame% LSS 100 SET Frame=0%Frame%

REM ffmpeg -i %Filename% -ss %time% -frames:v 1 -pix_fmt rgb48be -sws_flags +accurate_rnd+full_chroma_int "%File%-frame.%Frame%.png"

ffmpeg -i %Filename% -ss %time% -frames:v 1 -pix_fmt rgb48be -sws_flags +accurate_rnd+full_chroma_int "%File%-frame.%Frame%.png"

:exit
pause