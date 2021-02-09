Attribute VB_Name = "OutlookMacro"
'-------------------------------------------------------------------------
' Goal        : VBA macro "DeleteDuplicatedEntries" to delete
'               duplicated entries in Microsoft Outlook
'              (emails, calendar's items, tasks, contacts).
'
' Author      : J.-C. Stritt
' Environment : tested with VBA for Outlook 2007 on Windows XP
' Releases    : V1.0 / 31-OCT-2002 (first release)
'               V1.1 / 19-MAY-2009 (duplicated contacts remove added)
'               V2.0 / 22-JUN-2009 (rewriting all with a class module)
'               V2.1 / 24-JUN-2009 (small modifications)
'               V2.2 / 18-SEP-2009 (better key management and progressbox)
'
' Remarks     : - first based on Microsoft Q294457 - OL2002
'                 "How to Programmatically Search a Folder Tree"
'
'               - delete duplicates algorithm is based
'                 on a sort in a folder collection items
'                 and a string compare key
'
'               - for emails, these macro give you the possibility
'                 to pickup an entry folder. Then, the macro process
'                 each entry (delete if match) in the folder
'                 and recursivly to all subfolders
'
' Licence     : You can copy this code freely, but it should
'               be left accompanied by these comments.
'-------------------------------------------------------------------------
' Edited by Minha, Jeong / 2021.02.07
'-----------------------------------------------------------------
Option Explicit

Dim lCount As Long 'to count the deleted items


'the macro that delete the duplicated entries
Public Sub DeleteDuplicatedEntries()
  Dim rep As String, choice As Integer
  Dim olCtx As OutlookContext

  'loop for user interaction
  Do
    rep = InputBox("This macro delete duplicates entries" & vbNewLine _
                 & "for a given category of items." & vbNewLine & vbNewLine _
                 & "1 = emails" & vbNewLine _
                 & "2 = calendar" & vbNewLine _
                 & "3 = tasks" & vbNewLine _
                 & "4 = contacts" & vbNewLine & vbNewLine _
                 & "q = quit the macro", "Question")
    If IsNumeric(rep) Then
      choice = CInt(rep)
      If (choice >= 1) And (choice <= 4) Then
        'initialize some global var
        lCount = 0
      
        'get a reference to the Outlook application and session.
        Set olCtx = New OutlookContext
        olCtx.Create (choice)
      
        'ok to begin process ?
        If MsgBox(olCtx.GetQuestion(), vbYesNo + vbQuestion, "Question") = vbYes Then
      
          'set a start folder
          If (olCtx.SetStartFolder()) Then
      
            'process the first folder (and other by recursive calls to ProcessFolder)
            ProgressBox.Show
            Call ProcessFolder(olCtx)
            ProgressBox.Hide
            Call MsgBox(CStr(lCount) & " " & olCtx.GetMessage(), vbOKOnly, "Info")
      
          End If
        End If
        Set olCtx = Nothing
      End If
    End If
  Loop Until UCase(rep) = "Q"
End Sub

'the process folder : each folder item is compared to the previous to delete duplicated entries
Private Sub ProcessFolder(olCtx As OutlookContext)
  Dim i, j As Long
  Dim strLastKey(4) As String
  Dim strNewKey As String
  Dim olNewFolder As Outlook.MAPIFolder
  Dim olTempItem As Object     'could be various item types
  Dim myItems As Outlook.Items 'a local copy of the collection
   
  'copy the collection (it's obligatory for the sort) and sort them
  Set myItems = olCtx.GetFolder().Items
  On Error Resume Next
  Call myItems.Sort("[" & olCtx.GetSortKey() & "]", True)
  On Error GoTo 0
  
  'loop through the items in the current folder (backwards in this case of items to delete)
  For i = myItems.Count To 1 Step -1
    Set olTempItem = myItems(i)
    
    'process only if type is OK
    If typeName(olTempItem) = olCtx.GetTypeName() Then
      With olTempItem
        strNewKey = olCtx.GetCurrKey(olTempItem)
        
        'uncomment next lines for debugging
        'Debug.Print strNewKey
        'Debug.Print strLastKey
        'Debug.Print
        
        'update percent in progressbox
        ProgressBox.Increment (myItems.Count - i + 1) / myItems.Count * 100
        
        'check to see if a match is found
        For j = LBound(strLastKey) To UBound(strLastKey)
            If strNewKey = strLastKey(j) Then
            olTempItem.Delete
            'count deleted items
            lCount = lCount + 1
            Exit For
            End If
        Next
        
        'memorize last key found
        strLastKey(lCount Mod 5) = strNewKey
      End With
    End If
  Next

  'loop through and search each subfolder of the current folder.
  For Each olNewFolder In olCtx.GetFolder().Folders
    Call olCtx.SetFolder(olNewFolder)
    Call ProcessFolder(olCtx)
  Next

End Sub
