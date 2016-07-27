
function update-xmlinventory{

    [cmdletbinding()]
    param(
    [parameter( mandatory = $true, valuefrompipeline = $true)]
    [string]$inputfilepath,
    [parameter( mandatory = $true, valuefrompipeline = $true)]
    [string]$outputfilepath
    )
    [xml]$xml = get-content $inpufilepath
    

    foreach($computer in $xml.computers.computer){

    #query information
    $bios= get-wmiobject -Class win32_bios -ComputerName $computer.name
    $sys = get-wmiobject -Class win32_computersystem -ComputerName $computer.name
    $os = get-wmiobject -Class win32_operatingsystem -ComputerName $computer.name
    #updatexml
    #add value to xml element
    $computer.biosserial = $bios.serialnumber

    #create new node for mfgr
    $new_node = $xml.CreateNode("element","manufacturer", "")
    $new_node.InnerText = $sys.manufacturer
    $computer.AppendChild($new_node) | out-null

    #create new attribte

    $new_attr = $xml.CreateAttribute('build')
    $new_attr.Value = $os.buildnumber
    $computer.SetAttributenode($new_attr) | out-null

    }

    $xml.Save($outputfilepath)
    #$xml.Save('C:\Users\nakatoch\Desktop\scrpts\serverdata.xml')
    <#$node = $xml.SelectSingleNode("//computer[@name='localhost']")
    write "node name is $($node.Name)" #>
}

#get-content C:\Users\nakatoch\Desktop\scrpts\serverdata.xml | convertto-xml | update-xmlinventory | out-file C:\Users\nakatoch\Desktop\scrpts\serverdata2.xml


#get-content C:\Users\nakatoch\Desktop\scrpts\serverdata.xml | convertto-xml | out-file C:\Users\nakatoch\Desktop\scrpts\serverdata2.xml

update-xmlinventory -inputfilepath C:\Users\nakatoch\Desktop\scrpts\serverdata.xml -outputfilepath C:\Users\nakatoch\Desktop\scrpts\serverdata2.xml



