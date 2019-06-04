function Check-AlwaysOn {
    <#
        .SYNOPSIS
        Veritabanı ilk-adım kontrolü ve kaynak kullanım kontrolü yapan fonksiyon - Gereklilikler : AlwaysOn ve Whoisactive
        .DESCRIPTION
        SQL Server Veritabanı seviyesinde veritabanı çalışırlığı ve kaynak kullanımını kullanıcıya sunan fonkisyondur.
        .EXAMPLE
        Check-SqlServerDb -serverName sunucu_ismi
        .EXAMPLE
        Check-AlwaysOn -serverName sunucu_ismi
        .NOTES
        Author: Hüseyin demir
        Date:   May 27, 2019  
    #>
    [CmdletBinding()]
    param 
    (
        [string]
        $serverName
        
    )
    
    begin {
        $Date = Get-Date
        Write-Output "-------------------------------------------------------------------------"
        Write-Output "TimeStampt : $Date Checking the AlwaysOn Status of " $serverName.ToUpper()
        Write-Output "-------------------------------------------------------------------------"

    }
    
    process {
        
        $AlwaysOnStatus = Invoke-DbaQuery -SqlInstance $serverName -Database Database_Name -Query "exec sp_AlwaysOnDataLoss" | Select-Object -Property ag_replica_server, ag_name, database_name, connected_state_desc, synchronization_health_desc, estimated_data_loss_time | Format-Table -AutoSize -Wrap

        
    }
    
    end {
       
        return $AlwaysOnStatus


    }
}