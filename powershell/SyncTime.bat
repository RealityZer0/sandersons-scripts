net stop w32time
w32tm /unregister
w32tm /register
net start w32time

tzutil /s "Pacific Standard"

w32tm /config /syncfromflags:domhier /update
w32tm /resync

net stop w32time
net start w32time 