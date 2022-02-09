'[PowerPointExport.vbs]'

 With CreateObject("PowerPoint.Application")

    Set p = .Presentations.Open(WScript.Arguments(0))
    local = true

    With CreateObject("Scripting.FileSystemObject")

        For Each s In p.Slides

            s.Export .BuildPath(WScript.Arguments(1), s.SlideNumber & ".png"), "png"

        Next

    End With

    .Quit
 End With