$TDate = Get-Date
$CurrentDate = $TDate.ToString('MMddyyyy_hhmmss')
Get-CalendarDiagnosticLog -Identity "userhere" Subject "Repeating -CalendarEventHere" -LogLocation C:\Users\USERHERE\Reports\RecurCalendarLog\