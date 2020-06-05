@Echo off

IF NOT [%1]==[] (
set Filename=%1
) ELSE (
goto :exit
)

set "Filename=%Filename:.=" & rem."%"

Echo.
Echo.
Echo EXR files named %Filename% will be compressed to HDR MKV file
Echo.
Echo.
Echo.

REM ###########################################################
REM ############### Compress EXR to HDR  ######################
REM ###########################################################

ffmpeg -hide_banner ^
-y ^
-i %Filename%.%%03d.exr ^
-pix_fmt yuv420p10le ^
-r 25 ^
-c:v libx265 -preset fast -crf 5 ^
-x265-params keyint=25:bframes=2:vbv-bufsize=50000:vbv-maxrate=50000:hdr-opt=1:no-open-gop=1:hrd=1:repeat-headers=1:colorprim=bt2020:transfer=smpte2084:colormatrix=bt2020nc:master-display="G(13250,34500)B(7500,3000)R(34000,16000)WP(15635,16450)L(10000000,500)":max-cll="1000,400" ^
-an ^
%Filename%.mkv

Echo.
Echo.
Echo.
Echo %Filename%.mkv is ready
Echo.
Echo.
Echo.
Echo Now we will transformed it back to SDR to check the conversion
Echo. 
Echo.
Echo.


REM ##############################################################
REM ############### Convert HDR MKV to SDR  ######################
REM ############## To check the video encoded ####################
REM ##############################################################

ffmpeg.exe -y -i "%Filename%.mkv" -vf zscale=t=linear:npl=100,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p -c:v libx265 -crf 21 -preset fast "%Filename%_SDR_Check.mkv"

Echo.
Echo.
Echo.
Echo %Filename%_SDR_Check.mkv is ready
Explorer %Filename%.mkv
exit

:exit
Echo Error - No filename entered
pause
