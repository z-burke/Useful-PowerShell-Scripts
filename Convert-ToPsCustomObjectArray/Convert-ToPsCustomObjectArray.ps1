function Convert-ToPsCustomObjectArray
{
    # Converts an object or collection  to an array of PSCustomObjects
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [Object]
        $InputObject
    )
    Begin
    {
        $OutputArray = [Collections.Generic.List[PSCustomObject]]::new()
        $ObjToPsObjConverter = {
            param($obj)
            # It's prefererable to use the .GetEnumerator method on the IEnumerable Interface, as it
            # seems to give better results than .PSObject.Properties.
            if ($obj -is [Collections.IEnumerable])
            {
                $rawProperties = $obj.GetEnumerator()
            }
            else {
                $rawProperties = $obj.PSObject.Properties
            }
            $properties = $rawProperties | ForEach-Object {$aggregator = [Collections.Specialized.OrderedDictionary]::new()} {
                if ($_.Value -ne $null)
                    {
                        $aggregator.Add($_.Name, $_.Value.ToString())
                    }
                } {[PSCustomObject]$aggregator}
            return $properties
        }
    }
    Process
    {
        if ($InputObject -is [Object[]]) 
        {
            for ($i = 0; $i -lt $InputObject.Count; $i++)
            {
                $PsObject = Invoke-Command -ScriptBlock $ObjToPsObjConverter -ArgumentList $InputObject[$i]
                $OutputArray.Add($PsObject)
            } 
        }
        else
        {
            $PsObject = Invoke-Command -ScriptBlock $ObjToPsObjConverter -ArgumentList $InputObject
            $OutputArray.Add($PsObject)
        }
    }
    End
    {
        return [PSCustomObject[]]$OutputArray
    }
}
