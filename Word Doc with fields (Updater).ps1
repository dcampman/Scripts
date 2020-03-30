#filepaths
$docPath = "C:\Users\david.campman\Desktop\SUNY\AADC\Server Specs Report.docx"
$jsonFile = "C:\temp\ServerSpecs.json"
$GetServerSpecs = Invoke-WebRequest https://raw.githubusercontent.com/dcampman/Scripts/master/GetServerSpecs.ps1

#Make sure the json file is there
if (!(Test-Path $jsonFile)){
    #Go Make it
    Invoke-Expression $($GetServerSpecs.Content)
    #Import the Json file into a psobject
    $ComputerProperties = Get-Content -Raw -Path $jsonFile | ConvertFrom-Json
}
else{
    #Update it anyways
    Invoke-Expression $($GetServerSpecs.Content)
    #Import the Json file into a psobject
    $ComputerProperties = Get-Content -Raw -Path $jsonFile | ConvertFrom-Json
}

#Create a word app object
$WordApp = new-object -comObject Word.Application

#Open the doc and make is invisible
$doc = $WordApp.Documents.Add($docPath) 
$WordApp.Visible = $False

#Create the binding objects for the custom doc properties
$binding = "System.Reflection.BindingFlags" -as [type];
$CustomProperties = $doc.CustomDocumentProperties

#Loop through all the hashtable values and add properties to word doc
foreach ($prop in $ComputerProperties.psobject.properties)
{
    $CustomProperty = [System.__ComObject].InvokeMember("Item", $binding::GetProperty, $null, $CustomProperties, $prop.Name)
    [System.__ComObject].InvokeMember("Value",$binding::SetProperty,$null,$CustomProperty,$prop.Value)
}

#Update all the fields in the word doc (out-null to supress return value)
$WordApp.ActiveDocument.Fields.Update() | Out-Null

#Save the word doc
$doc.SaveAs([REF]$docPath)

#Close the doc and dispose of the word app object
$doc.Close()
$WordApp.Quit()