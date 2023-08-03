Set objExcel = CreateObject("Excel.Application")
Set objWorkbook = objExcel.Workbooks.Open("G:\AFP\IHACAll\IHAC\015 DDU\005 Covid reporting\0001 R Projects\transport_modes_table\Data\TfL\YOY_ALLMODES.xlsx")
objExcel.Calculate

objWorkbook.Close True 

\\Comment here

testing testing 