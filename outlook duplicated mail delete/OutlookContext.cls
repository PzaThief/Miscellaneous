VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "OutlookContext"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'----------------------------------------------------------------
' Goal        : class bean "OutlookContext"
'               save the outlook "context" when using macro
'               "DeleteDuplicatedEntries"
'
' Author      : J.-C. Stritt
' Environment : VBA for Outlook 2007 on Windows XP
' Releases    : V1.0 / 22-JUN-2009 (creation, first release)
'               V1.1 / 18-SEP-2009 (better key management)
'
' Remark      : see "DeleteDuplicatedEntries" macro for an example
'
' Licence     : You can copy this code freely, but it should
'               be left accompanied by these comments.
'-----------------------------------------------------------------
' Edited by Minha, Jeong / 2021.02.07
' Make AddBlanks faster
' Using .SenderEmailAddress instead of .SenderName
' Add mail keys '.Senton', '.Recipients', 'attachments' and increase STR_COMPARE_LIMIT to 100
' There is no reason for cutting short string, vba can handle it over 2bil length
' Make key array for checking more than double duplicated
'-----------------------------------------------------------------
Option Explicit
Const DATETIME_FORMAT = "yyyy.mm.dd hh:mm:ss"

Private op As Integer
Private typeName As String
Private sortKey As String
Private question As String
Private message As String
Private dateTimeFormat As String

Private session As Outlook.NameSpace
Private folder As Outlook.MAPIFolder

'constructor after a new
Public Sub Create(ByVal operation As Integer)
  op = operation
  Select Case op
      Case 1
         typeName = "MailItem"
         sortKey = "ReceivedTime"
         question = "Ok to delete duplicates emails ?"
         message = "emails messages were deleted."
      Case 2
         typeName = "AppointmentItem"
         sortKey = "Start"
         question = "Ok to delete duplicates items in calendar ?"
         message = "calendar items were deleted."
      Case 3
         typeName = "TaskItem"
         sortKey = "Subject"
         question = "Ok to delete duplicates tasks ?"
         message = "tasks were deleted."
      Case 4
         typeName = "ContactItem"
         sortKey = "FullName"
         question = "Ok to delete duplicates contacts ?"
         message = "contacts were deleted."
  End Select
  dateTimeFormat = DATETIME_FORMAT
  Set session = Application.GetNamespace("MAPI")
  Set folder = session.GetDefaultFolder(olFolderInbox)
  
'  Dim myItems As Outlook.Items
'  Dim props As ItemProperties
'  Dim prop As ItemProperty
'  Set myItems = folder.Items
'  Set props = myItems(1).ItemProperties
'  For Each prop In props
'    Debug.Print prop.Name
'  Next

End Sub

'return the type name of an item
Public Function GetTypeName() As String
  GetTypeName = typeName
End Function

'return the sort key name
Public Function GetSortKey() As String
  GetSortKey = sortKey
End Function

'return the right question for the view
Public Function GetQuestion() As String
  GetQuestion = question
End Function

'return the final message for the view
Public Function GetMessage() As String
  GetMessage = message
End Function

'return the date time format for sorting
Public Function GetDateTimeFormat() As String
  GetDateTimeFormat = dateTimeFormat
End Function

'return the current selected folder
Public Function GetFolder() As Outlook.MAPIFolder
  Set GetFolder = folder
End Function

'set the current folder
Public Sub SetFolder(ByVal newFolder As Outlook.MAPIFolder)
  Set folder = newFolder
End Sub

'set a start folder and return true if OK
Public Function SetStartFolder() As Boolean
  Select Case op
    Case 1: Set folder = session.PickFolder
    Case 2: Set folder = session.GetDefaultFolder(olFolderCalendar)
    Case 3: Set folder = session.GetDefaultFolder(olFolderTasks)
    Case 4: Set folder = session.GetDefaultFolder(olFolderContacts)
  End Select
  SetStartFolder = Not IsNull(folder)
End Function
Function Repeat$(ByVal n&, s$)
    Dim r&
    r = Len(s)
    If n < 1 Then Exit Function
    If r = 0 Then Exit Function
    If r = 1 Then Repeat = String$(n, s): Exit Function
    Repeat = Space$(n * r)
    Mid$(Repeat, 1) = s: If n > 1 Then Mid$(Repeat, r + 1) = Repeat
End Function
Function Callitem(ByRef item) As String
    Dim s As String
    Dim i As Integer
    s = ""
    If item.Count() > 0 Then
    For i = 1 To item.Count()
    If item.Class = olAttachments Then
    s = s + item.item(i).FileName + " "
    Else
    s = s + item.item(i).Name + " "
    End If
    Next
    End If
    Callitem = s
End Function
'add blanks at the ending of a string
Private Function AddBlanks(ByVal s As String, ByVal L As Integer) As String
  Dim i As Integer, Diff As Integer
  s = LTrim(s)
  Diff = L - Len(s)
  If Diff > 0 Then
      s = s + Repeat(Diff, " ")
  ElseIf Diff < 0 Then
    s = Left(s, L)
  End If
  AddBlanks = s
End Function

'get a current string key
Public Function GetCurrKey(ByVal item As Object) As String
  Const STR_COMPARE_LIMIT = 100 'check only first N characters for strings
  Dim strNewKey As String
  
  With item
    Select Case op
      Case 1
        strNewKey = AddBlanks(.SenderEmailAddress, STR_COMPARE_LIMIT) _
                  & AddBlanks(Callitem(.Recipients), STR_COMPARE_LIMIT) _
                  & AddBlanks(.Subject, STR_COMPARE_LIMIT) _
                  & AddBlanks(Callitem(.Attachments), STR_COMPARE_LIMIT) _
                  & Format(.ReceivedTime, DATETIME_FORMAT) _
                  & Format(.SentOn, DATETIME_FORMAT)
      Case 2
        strNewKey = AddBlanks(.Subject, STR_COMPARE_LIMIT) & " " _
                  & Format(.Start, DATETIME_FORMAT) & " " _
                  & Format(.End, DATETIME_FORMAT)
      Case 3
        strNewKey = AddBlanks(.Subject, STR_COMPARE_LIMIT) & " " _
                  & AddBlanks(.Body, STR_COMPARE_LIMIT) & " " _
                  & Format(.DueDate, DATETIME_FORMAT) & " " _
                  & Format(.DateCompleted, DATETIME_FORMAT) & " " _
                  & .Importance & " " _
                  & .PercentComplete
      Case 4
        strNewKey = AddBlanks(.FullName, STR_COMPARE_LIMIT) & " " _
                  & AddBlanks(.CompanyName, STR_COMPARE_LIMIT) & " " _
                  & .BusinessTelephoneNumber & " " _
                  & .HomeTelephoneNumber & " " _
                  & .Email1Address & " " _
                  & .BusinessTelephoneNumber
    End Select
    Debug.Print (strNewKey)
  End With
  GetCurrKey = strNewKey
End Function

