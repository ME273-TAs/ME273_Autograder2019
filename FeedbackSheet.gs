// ----------------------------------------------------------------------------------
// File: FeedbackSheet.gs
// Author: Jared Hale
// Date: 28 August 2020
//
// Purpose: This function takes the information found in .csv file named 'ME273LabFeedback.csv' 
// that should be uploaded to your Google Drive and converts it into a file to be shared with
// students in which they can view feedback for labs.
//
// Inputs: The .csv containing the grades and feedback you want to send out should be
// uploaded to the Google Drive, and should be named 'ME273LabFeedback.csv'. When the
// program runs, it searches for all files in the Drive that are named 'ME273LabFeedback.csv',
// uses the newest one in this program and deletes all of the others. The file that is
// used is also ultimately deleted from the Google Drive.
//
// Outputs: This function will write to an **EXISTING** file of format LabXFeedback, where
// X is replaced with a single or two-digit number corresponding to the lab number.
//
// NOTES
//   1. This function works hand-in-hand with configAutograder.m. Changes in the 
// column assignment section of configAutograder.m will need to be made in this function
// as well, in the *** COLUMN ASSIGNMENTS *** section.
// ----------------------------------------------------------------------------------

function feedbackSheet() {
  // get feedback csv's
  var feedbackFiles = DriveApp.getFilesByName("ME273LabFeedback.csv");
  
  try {
    // if there is no matching file, this line will crash the program
    var fileNew = feedbackFiles.next(); 
  }
  catch (e) {
    console.error('No feedback .csv file found (must be named ME273LabFeedback.csv).');
    return;
  }
  
  // get the most recent one
  while(feedbackFiles.hasNext()) {
    var file = feedbackFiles.next();
    
    if (file.getLastUpdated() > fileNew.getLastUpdated()) {
      fileNew = file;
      file.setTrashed(true);
    }
  }
  
  // Create Super Temp File to just get the lab number
  var ssNew = SpreadsheetApp.create("LabNoReference");
  var csvData = Utilities.parseCsv(fileNew.getBlob().getDataAsString());
  var sheet = ssNew.getSheets()[0];
  sheet.getRange(1, 1, csvData.length, csvData[0].length).setValues(csvData);
  var dataRange = sheet.getDataRange();
  
  var LABSCORE = 5;
  
  // get data
  var data = dataRange.getValues();
  
  // parse out the lab number
  var labNumber = data[0][LABSCORE][3]; // get 4th number 
  if (!isNaN(parseFloat(data[0][LABSCORE][4])) && isFinite(data[0][LABSCORE][4])){
    labNumber += data[0][LABSCORE][4];
  }
  
  // Trash super-temp file
  var ssID = ssNew.getId();
  var ssFile = DriveApp.getFileById(ssID);
  ssFile.setTrashed(true);
  
  // Find Spreadsheet in Folder: 2020_Grading and prep to be written over
  var gradeFolder = DriveApp.getFoldersByName("2020_Grading")
  var folder = gradeFolder.next()
  var labFile = folder.getFilesByName("Lab" + labNumber + "Feedback")
  try{
    var file = labFile.next()
  }
  catch(e) {
    console.error("No Lab Feedback sheet found (must be named LabXFeedback). Please make a copy of Lab0Feedback and rename it with the desired Lab Number. Don't forget to share it with the students.");
    return;
  }
  
  // Set Sharing Permissions
  file.setSharing(DriveApp.Access.PRIVATE, DriveApp.Permission.NONE)
  
  // setup spreadsheet reference - because Google can't operate on the CSV directly
  var ssNew = SpreadsheetApp.openById(file.getId());
  var csvData = Utilities.parseCsv(fileNew.getBlob().getDataAsString());
  var sheet = ssNew.getSheets()[1];
  sheet.getRange(1, 1, csvData.length, csvData[0].length).setValues(csvData);
  var dataRange = sheet.getDataRange();
  
  
  // get data
  var data = dataRange.getValues();
  
  // *** COLUMN ASSIGNMENTS ***
  // Front-of-the-file fields
  var COURSEID = 0;
  var LASTNAME = 1;
  var FIRSTNAME = 2;
  var SECTIONNUMBER = 4;
  var LABSCORE = 5;
  var FEEDBACKFLAG = 6;
  var FIRSTDEADLINE = 7;
  var FINALDEADLINE = 8;
  // Back-of-the-file fields
  var EMAIL = 1;
  
  // Lab part constants
  var PARTSTART = 9;
  var PARTLENGTH_FRONT = 7;
  var PARTLENGTH_BACK = 3;
  
  var SUBCOUNT = 1;
  var SUBMITDATE = 2;
  var PARTSCORE = 3;
  var CODESCORE = 4;
  var HEADERSCORE = 5;
  var COMMENTSCORE = 6;
  
  var CODEFEEDBACK = 0;
  var HEADERFEEDBACK = 1;
  var COMMENTFEEDBACK = 2;
  // *** END COLUMN ASSIGNMENTS ***
  
  var row = data[1];
  var n = row.length;
  var p = (n - (PARTSTART + 1))/(PARTLENGTH_FRONT + PARTLENGTH_BACK);
  
  // Remove Unwanted Columns in Feedback Page
  sheet.deleteColumn(n)
  
  for (var j = p-1; j >= 0; j--){
    var startDelete = 10 + (PARTLENGTH_FRONT * j);
    sheet.deleteColumns(startDelete + 4, 3)
    sheet.deleteColumns(startDelete, 3)
  }
  
  sheet.deleteColumns(2, (PARTSTART -1))
  
  //Move Score Columns to Be with each Lab Part
  for (var w = 2; w <= p; w++){
    var startCol = 3;
    var finCol = 2 + (w * 3)
    //Logger.log(finCol)
    moveColumn(startCol, finCol, sheet)
  }
  
  //Insert Empty Columns Between Lab Parts
  for (var m = p - 1; m > 0; m--){
    sheet.insertColumns(2 + m * 4)
  }
  
  //Set Column Widths
  var sheet = ssNew.getSheets()[0];
  sheet.setColumnWidth(1, 250)
  
  var noCols = sheet.getLastColumn();
  for (var k = 2; k <= noCols; k++){
    sheet.setColumnWidth(k, 350)
  }
  
  //Freeze First Column & Row
  sheet.setFrozenColumns(1)
  sheet.setFrozenRows(1)
  
  //Format Text Wrapping
  var noRows = sheet.getLastRow();
  var range = sheet.getRange(1,1,noRows,noCols)
  range.setWrapStrategy(SpreadsheetApp.WrapStrategy.WRAP)
  
  //Format Text Allignment
  var range = sheet.getRange(1, 1, 1, noCols)
  range.setHorizontalAlignment("center")
  range.setFontSize(11)
  range.setFontWeight("bold")
  
  var range = sheet.getRange(1,1,noRows)
  range.setHorizontalAlignment("left")
  range.setFontSize(11)
  range.setFontWeight("bold")
  
  var range = sheet.getRange(2,2,noRows - 1, noCols - 1)
  range.setHorizontalAlignment("left")
  
  // Get Rid of Nans
  var sheet = ssNew.getSheets()[1];
  for (var u = 1; u <= noRows; u++){
    for (var v = 1; v <= noCols; v++){
      range = sheet.getRange(v, u);
      var cellVal = range.getValue()
      if (cellVal == "NaN"){
        range.setValue(" ")
      }
    }
  }
  
  // Format Scores as Percentages
  for (var t = 0; t <= p; t++){
    var scoreCol = 2 + (t * 5);
    var noCols = sheet.getLastColumn();
    var noRows = sheet.getLastRow();
    for (var grade = 2; grade <= noRows; grade++){
      range = sheet.getRange(grade,scoreCol)
      range.setNumberFormat("0.0%")
    }
    
  }
  
  // Hide sheet
  sheet.hideSheet()
  
  
  // Set Sharing Permissions
  file.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW)
  
  // Trash ME273LabFeedback.csv
  fileNew.setTrashed(true)


}

function moveColumn(iniCol, finCol, sh) {
  // From https://stackoverflow.com/questions/21145080/moving-a-column-in-google-spreadsheet
  // iniCol - Column of interest. (Integer)
  // finCol - Column where you move your initial column in front of.(Integer)
  // Ex:
  // Col A  B  C  D  
  //     1  2  3  4  5
  //     6  7  8  9  10
  //     11    12 13 14
  // Want to move Column B in between Column D/E.
  // moveColumn(2,4);
  // Col A  B  C  D  E
  //     1  3  4  2  5
  //     6  8  9  7  10
  //     11 12 13    14
  var lRow = sh.getMaxRows();
  if (finCol > iniCol) {
    sh.insertColumnAfter(finCol);
    var iniRange = sh.getRange(1, iniCol, lRow);
    var finRange = sh.getRange(1, finCol + 1, lRow);
    iniRange.copyTo(finRange, {contentsOnly:true});
    sh.deleteColumn(iniCol);
  }
  else {
    sh.insertColumnAfter(finCol);
    var iniRange = sh.getRange(1, iniCol + 1, lRow);
    var finRange = sh.getRange(1, finCol + 1, lRow);
    iniRange.copyTo(finRange, {contentsOnly:true});
    sh.deleteColumn(iniCol + 1);    
  }
}