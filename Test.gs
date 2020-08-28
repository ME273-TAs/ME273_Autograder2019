// ----------------------------------------------------------------------------------
// File: Test.gs
// Author: Caleb Groves
// Date: 24 August 2018
//
// Purpose: This function sends out a few test emails using the Google Drive account and a .csv
// file named 'ME273LabFeedback.csv' that should be uploaded to your Google Drive.
//
// Inputs: The .csv containing the grades and feedback you want to send out should be
// uploaded to the Google Drive, and should be named 'ME273LabFeedback.csv'. When the
// program runs, it searches for all files in the Drive that are named 'ME273LabFeedback.csv',
// uses the newest one in this program and deletes all of the others. The file that is
// used is also ultimately deleted from the Google Drive.
//
// The variables defined in *** TESTING VARIABLES *** can be changed so that the test emails
// are sent to a different email, or to do a different number of test emails or start
// on a different row.
//
// Outputs: This function will send out grades and feedback to each student in the
// .csv file in the testing range specified in *** TESTING VARIABLES ***.
//
// NOTES:
//   1. Emails will be sent out until this Google account's daily email quota limit
// has been reached (100 normally for a 24-hour period), at which point no more emails
// will be sent out.
//
//   2. This function works hand-in-hand with configAutograder.m. Changes in the 
// column assignment section of configAutograder.m will need to be made in this function
// as well, in the *** COLUMN ASSIGNMENTS *** section.
//
//   3. Any rows of students in the .csv read in by this function will be skipped if
// their feedback flag is '0' or '2'.
// ----------------------------------------------------------------------------------

function gradingFeedbackTest() {
  // *** TESTING VARIABLES ***
  var testEmail = 'jaredhmt@gmail.com';
  var startTestStudent = 1;
  var numTestStudents = 3;
  // *** END TESTING VARIABLES ***
  Logger.log(testEmail)
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
  Logger.log(fileNew)
  // get the most recent one
  while(feedbackFiles.hasNext()) {
    var file = feedbackFiles.next();
    
    if (file.getLastUpdated() > fileNew.getLastUpdated()) {
      fileNew = file;
      file.setTrashed(true);
    }
  }
  
  
  // Find Spreadsheet in Folder: 2020_Grading and prep to be written over
  var gradeFolder = DriveApp.getFoldersByName("2020_Grading")
  var folder = gradeFolder.next()
  var labFile = folder.getFilesByName("Lab5Feedback")
  var file = labFile.next()
  
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
  var PARTLENGTH_FRONT = 6;
  var PARTLENGTH_BACK = 3;
  
  var LATE = 1;
  var PARTSCORE = 2;
  var CODESCORE = 3;
  var HEADERSCORE = 4;
  var COMMENTSCORE = 5;
  
  var CODEFEEDBACK = 0;
  var HEADERFEEDBACK = 1;
  var COMMENTFEEDBACK = 2;
  // *** END COLUMN ASSIGNMENTS ***
  
  // parse out the lab number
  var labNumber = data[0][LABSCORE][3]; // get 4th number 
  if (!isNaN(parseFloat(data[0][LABSCORE][4])) && isFinite(data[0][LABSCORE][4])){
    labNumber += data[0][LABSCORE][4];
    }
    
  var row = data[1];
  var n = row.length;
  var p = (n - (PARTSTART + 1))/(PARTLENGTH_FRONT + PARTLENGTH_BACK);
  
  // Remove Unwanted Columns in Feedback Page
  sheet.deleteColumn(n)
  
  for (var j = p-1; j >= 0; j--){
    var startDelete = 10 + (PARTLENGTH_FRONT * j);
    sheet.deleteColumns(startDelete, (PARTLENGTH_FRONT))
  }
  
  sheet.deleteColumns(2, (PARTSTART -1))
  
  //Set Column Widths
  var sheet = ssNew.getSheets()[0];
  sheet.setColumnWidth(1, 250)
  
  var noCols = sheet.getLastColumn();
  for (var k = 2; k <= noCols; k++){
    sheet.setColumnWidth(k, 350)
  }
  
  //for (var k = 0; k < p; k++){
  //  var refNum = 2 + (k * 3);
  //  sheet.setColumnWidth(refNum, 400)
  //  sheet.setColumnWidths(refNum + 1, 2, 200)
  //}
  
  
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
  range.setFontSize(11)
  range.setFontWeight("bold")
  
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
  
  
}

