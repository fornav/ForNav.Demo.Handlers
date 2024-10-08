page 50400 "Handler Sample"
{
    ApplicationArea = All;
    UsageCategory = None;

    actions
    {
        area(Processing)
        {
            action(UppercaseSample)
            {
                ApplicationArea = All;
                Caption = 'Uppercase Sample';
                ToolTip = 'Create a sample package';
                Image = ExportMessage;

                trigger OnAction()
                var
                    DirPrtQueue: Record "ForNAV DirPrt Queue";
                    packageJO: JsonObject;
                    resultJO: JsonObject;
                    resultToken: JsonToken;
                begin
                    CreateDirectPrinter('UppercaseSample', 'UppercaseHandler', true);

                    // Create the package for the local handler
                    packageJO.Add('inputtext', 'This is my sample text');

                    // Create a job on the queue
                    DirPrtQueue.CreatePackage('Uppercase sample', 'UppercaseSample', packageJO);
                    Commit(); // Commit so that the API can read the package from another session
                    if DirPrtQueue.WaitForResponse(10000, resultJO) then begin
                        // Read outputtext from result
                        if resultJO.Get('outputtext', resultToken) then
                            Message(resultToken.AsValue().AsText())
                        else
                            Error('The output was not found in the result.');
                    end else
                        Error('Request timed out');
                end;
            }

            action(Notepad)
            {
                ApplicationArea = All;
                Image = ExportMessage;
                Caption = 'Notepad Sample';
                ToolTip = 'Open notepad with a message';

                trigger OnAction()
                var
                    DirPrtQueue: Record "ForNAV DirPrt Queue";
                    tempBlob: Codeunit "Temp Blob";
                    fileContentBigText: BigText;
                    packageInStream: InStream;
                    packageOutStream: OutStream;
                begin
                    CreateDirectPrinter('NotepadSample', 'NotepadHandler', false);

                    // Create the package for the local handler
                    fileContentBigText.AddText('Hello World! The time is ' + Format(Time()));

                    // Create a print job
                    tempBlob.CreateOutStream(packageOutStream, TextEncoding::UTF8);
                    fileContentBigText.Write(packageOutStream);
                    tempBlob.CreateInStream(packageInStream);
                    DirPrtQueue.Create('Handler sample with Notepad',
                        'NotepadSample', packageInStream,
                        DirPrtQueue.ContentType::Package);
                end;
            }

            action(ExeHandler)
            {
                ApplicationArea = All;
                Image = ExportMessage;
                Caption = 'EXE Handler';
                ToolTip = 'Use an EXE handler';

                trigger OnAction()
                var
                    DirPrtQueue: Record "ForNAV DirPrt Queue";
                    tempBlob: Codeunit "Temp Blob";
                    fileContentBigText: BigText;
                    packageInStream: InStream;
                    packageOutStream: OutStream;
                begin
                    CreateDirectPrinter('ExeSample', 'ExeHandler', false);

                    // Create the package for the local handler
                    fileContentBigText.AddText('Hello World! The time is ' + Format(Time()));

                    // Create a print job
                    tempBlob.CreateOutStream(packageOutStream, TextEncoding::UTF8);
                    fileContentBigText.Write(packageOutStream);
                    tempBlob.CreateInStream(packageInStream);
                    DirPrtQueue.Create('Handler sample with executable',
                        'ExeSample', packageInStream,
                        DirPrtQueue.ContentType::Package);
                end;
            }
        }
    }

    local procedure CreateDirectPrinter(directPrinterName: Text[250]; localPrinterName: Text[250]; isServicePrint: Boolean)
    var
        localPrinter: Record "ForNAV Local Printer";
    begin
        localPrinter.SetRange("Cloud Printer Name", directPrinterName);
        localPrinter.DeleteAll();
        localPrinter.Init();
        localPrinter."Cloud Printer Name" := directPrinterName;
        localPrinter."Local Printer Name" := localPrinterName;
        localPrinter.IsPrintService := isServicePrint;
        localPrinter.Hidden := true;
        localPrinter.Insert();
    end;
}