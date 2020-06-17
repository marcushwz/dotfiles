
#!/bin/bash

while true; do
    playing="$(mpc current -f "[%artist% - ]%title%")"
    if [ -z $playing ]; then
        playing=" ◼ Some Music?"
        echo "${playing}"
    else
        status="► Playing:"
        mpc | grep "\[paused\]" 1>/dev/null && status="▷ Paused:"
        playing="$status $playing"
        echo "${playing}"
    fi
    mpc idle player > /dev/null
done
