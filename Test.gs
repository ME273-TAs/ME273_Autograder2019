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
  
  //var ssID = ssNew.getId()
  //var ssFile = DriveApp.getFileById(ssID)
  //Logger.log(ssID)
  //Logger.log(ssFile)
  //var newFile = ssFile.makeCopy('Lab5Feedback', folder)
  //DriveApp.getFileById(ssID).setTrashed(true)
  
  
  // setup spreadsheet reference - because Google can't operate on the CSV directly
  var ssNew = SpreadsheetApp.openById(file.getId());
  var csvData = Utilities.parseCsv(fileNew.getBlob().getDataAsString());
  var sheet = ssNew.getSheets()[0];
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
  for (var j = p-1; j >= 0; j--){
    var startDelete = 10 + (PARTLENGTH_FRONT * j);
    sheet.deleteColumns(startDelete, (PARTLENGTH_FRONT))
  }

  /*
  // For each student
  for (var i = startTestStudent; i < (startTestStudent + numTestStudents); i++) // test line
  {    
    var row = data[i];
    var n = row.length;
    var p = (n - (PARTSTART + 1))/(PARTLENGTH_FRONT + PARTLENGTH_BACK);
    Logger.log(i)
    var courseID = row[COURSEID];
    var lastName = row[LASTNAME];
    var firstName = row[FIRSTNAME];
    var labScore = Math.round(row[LABSCORE]*4);
    var feedbackFlag = parseInt(row[FEEDBACKFLAG])
    var email = row[row.length - EMAIL];
    Logger.log(p)
    Logger.log(feedbackFlag)
    if (feedbackFlag != 1) {
      continue;
    }
    
    // get info for each assignment
    var assignmentBreakdown = '';
    
    for (var j = 1; j <= p; j++)
    {
      var c = PARTSTART + (j-1)*PARTLENGTH_FRONT;
      Logger.log(j)
      // get lab part name and scores
      var labPartName = row[c];
      var late = row[c + LATE];
      var labPartScore = Math.round(row[c + PARTSCORE]*100);
      var codeScore = Math.round(row[c + CODESCORE]*100);
      var headerScore = Math.round(row[c+HEADERSCORE]*100);
      var commentScore = Math.round(row[c+COMMENTSCORE]*100);
      
      // get the right index for lab part feedback
      c = n - (p - (j-1))*PARTLENGTH_BACK - 1;
      
      // get lab part feedback
      var codeFeedback = row[c + CODEFEEDBACK];
      var headerFeedback = row[c + HEADERFEEDBACK];
      var commentFeedback = row[c + COMMENTFEEDBACK];
      
      // formulate feedback string
      var line1 = labPartName + ' Assignment ---------------------------------\n';
      var line2 = 'Total Score:\t' + labPartScore + ' % \n';
      var line3 = 'Code Score:\t' + codeScore + ' % \n';
      var line4 = 'Code Feedback: ' + codeFeedback + '\n';
      var line5 = 'Header Score:\t' + headerScore + ' % \n';
      var line6 = 'Header Feedback: ' + headerFeedback + '\n';
      var line7 = 'Comment Score:\t' + commentScore + ' % \n';
      var line8 = 'Comment Feedback: ' + commentFeedback + '\n';
      var line9 = '---------------------------------------------------------------\n\n';
      
      // Add in late notice if applicable
      if (late == 1){
        line8 += 'Note: Based on the date of your submission, this part of the lab was graded as ' + 
          'resubmission and is subject to the regrading policy.\n';
      }
      
      assignmentBreakdown += line1 + line2 + line3 + line4 + line5 + line6 + line7 + line8 + line9;
    }
    
    /*
    hook together text
    var opener = firstName + ' ' + lastName + ':\n\n';
    var intro = 'The following feedback was automatically generated from your recent lab ' + labNumber + ' submission. \n\n';
    */
    // var line1 = '///////////////////*** Lab ' + labNumber + ' Breakdown ***//////////////////\n\n';
    /*
    var line2 = 'Overall Lab ' + labNumber + ' Score:\t' + labScore + ' % \n\n';    
    var line3 = '**************Assignment Breakdown*****************\n';
    var line4 = assignmentBreakdown;
    
    var ending = '**If you have any questions on your assignment grade, please go whine to your mom, I don\'t want to hear it.**';    
    
    var text = opener + intro + line1 + line2 + line3 + line4 + ending;
    var subject = 'ME 273 Lab ' + labNumber + ' Grade';
    
    // send email
    // Logger.log(text)
    // MailApp.sendEmail(testEmail,subject,text); // test line    
    */
    /*
  }
  */
  
  
//   delete files
//  fileNew.setTrashed(true);
//  var ssID = ssNew.getId();
//  var ssFile = DriveApp.getFileById(ssID);
//  ssFile.setTrashed(true);
}

