Invoke-Webrequest -Uri "https://resource.roomsketcher.com/prod/install/windows/RoomSketcherSetup.exe" -Outfile "C:\temp\RoomSketcherSetup.exe"
cd C:\temp
.\RoomSketcherSetup.exe --prefix "C:\Program Files (x86)\RoomSketcher" --mode "unattended" --unattendedmodeui "none"