$TDate = Get-Date
$CurrentDate = $TDate.ToString('MMddyyyy_hhmmss')
Get-CalendarDiagnosticAnalysis -LogLocation "\\exch01-srvr\temp\RecurCalendarLog\user@domain.com" -DetailLevel Advanced > "C:\Users\USERHERE\Reports\RecurCalendarLog\output-user-$CurrentDate.csv"