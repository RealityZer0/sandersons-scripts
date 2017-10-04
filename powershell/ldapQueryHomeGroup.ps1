$ObjFilter = '(&(objectCategory=person)(objectCategory=User)(samaccountname=' +"$env:USERNAME"+'))' 
    $objSearch = New-Object System.DirectoryServices.DirectorySearcher 
    $objSearch.PageSize = 15000 
    $objSearch.Filter = $ObjFilter  
    $objSearch.SearchRoot = "LDAP://dc=domain,dc=com" 
    $AllObj = $objSearch.FindAll() 
    foreach ($Obj in $AllObj) 
           {
            $objItemS = $Obj.Properties
            Write-Host $objItemS.samaccountname
            Write-Host $objItemS.homedirectory
            }