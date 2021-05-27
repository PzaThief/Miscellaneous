
$app = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell1.0\powershell.exe'
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]

$Template = [Windows.UI.Notifications.ToastTemplateType]::ToastImageAndText01

#Gets the Template XML so we can manipulate the values
[xml]$ToastTemplate = ([Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent($Template).GetXml())

[xml]$ToastTemplate = @"
<toast launch='app-defined-string'>
    <visual>
        <binding template='ToastGeneric'>
            <image placement='todays_menu' src='file:./1621900807.png'/>
            <text>오늘의 메뉴가 업데이트되었습니다.</text>
            <text>맛점각?!</text>
        </binding>
    </visual>
</toast>
"@

$ToastXml = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
$ToastXml.LoadXml($ToastTemplate.OuterXml)

$notify = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($app)

$notify.Show($ToastXml)
