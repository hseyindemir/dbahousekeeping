function Check-SqlServerDb {
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
        Write-Output "TimeStampt : $Date Checking the Sql Db Status of " $serverName.ToUpper()
        Write-Output "-------------------------------------------------------------------------"
        

    }
    
    process {
        
        #Check ServerName for DNS
        $PrimaryServerName = Invoke-Database_NameQuery -SqlInstance $serverName -Database master -Query "Select @@servername AS Primary_Server"
        

        #Check CPU Core for Server
        $CpuCores = Invoke-Database_NameQuery -SqlInstance $serverName -Database master -Query "SELECT cpu_count as CPU_Cores FROM [sys].[dm_os_sys_info]"

        #Check WhoisActive for Server
        $WhoisActive = Invoke-Database_NameQuery -SqlInstance $serverName -Database master -Query "exec sp_whoisactive2"
        #$ActiveSessions = $WhoisActive.Count

        #Check PLE 
        $PageLifeExpectancy = Invoke-Database_NameQuery -SqlInstance $serverName -Database master -Query "SELECT
        [cntr_value] as PLE_Value FROM sys.dm_os_performance_counters
        WHERE [object_name] LIKE '%Manager%'
        AND [counter_name] = 'Page life expectancy'"
        #$PageLifeExpectancy


        #Check CPU&Memory Load
        $CpuLoadAverage = Get-WmiObject -computer $serverName -class win32_processor | Measure-Object -property LoadPercentage -Average | Select-Object -ExpandProperty Average
        #$CpuLoadAverage
        $ComputerMemory = Get-WmiObject -ComputerName $serverName -Class win32_operatingsystem -ErrorAction Stop
        $Memory = ((($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory) * 100) / $ComputerMemory.TotalVisibleMemorySize)
        $RoundMemory = [math]::Round($Memory, 2)
        #$RoundMemory
        
    }
    
    end {
       
        
        $SqlCheckResult = New-Object -TypeName psobject
        $SqlCheckResult | Add-Member -MemberType NoteProperty -Name PrimaryServerName -Value $PrimaryServerName.Primary_Server
        $SqlCheckResult | Add-Member -MemberType NoteProperty -Name ActiveSessions -Value $Whoisactive.Count
        $SqlCheckResult | Add-Member -MemberType NoteProperty -Name ServerCPUCoreCount -Value $CpuCores.CPU_Cores
        $SqlCheckResult | Add-Member -MemberType NoteProperty -Name PageLifeExpectancy-seconds -Value $PageLifeExpectancy.PLE_Value
        $SqlCheckResult | Add-Member -MemberType NoteProperty -Name MemoryUsage-Percentage -Value $RoundMemory
        return $SqlCheckResult

        
        
    }
}






