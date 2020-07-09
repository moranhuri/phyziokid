
function signInBTN() {
    console.log("piubemhv נלחץ");
    //get game code
    var emailUser = $("#emailUser").val();
    var passwordUser = $("#passwordUser").val();
    //var stepValue = 0;

    localStorage.setItem("textvalue", emailUser);
    //call to handler
    $.get("signInHandler.ashx", {
        UserEmail: emailUser, //sent game code
        password: passwordUser
        //stepValue: stepValue
    },

        function (data, status) {
            console.log("הכפתור נלחץ");
            console.log(status);
            if (status == "success") {

                //printing  the response in the console
                console.log(data);
 
                //if game not found or not publish
                if (data != "") {

                    var obj = JSON.parse(data);

                    if (obj == "הוזנו פרטים לא נכונים") {
                        $("#feedback").html("הפרטים לא נכונים");
                    }
                    else {
                        var kidNameStorage = JSON.parse(obj[1]);
                        localStorage.setItem("kidNameValue", kidNameStorage);
                        var kidAgeStorage = obj[2];
                        localStorage.setItem("kidAgeValue", kidAgeStorage);
                        var stepNum = obj[0].toString();
                        localStorage.setItem("stepValue", stepNum);
                        window.location = 'step' + stepNum + '.html';
                        var userNameStorage = JSON.parse(obj[3]);
                        localStorage.setItem("userNameValue", userNameStorage);
                        var KidBday = obj[4];
                        localStorage.setItem("kidBdayValue", KidBday);
                        console.log(obj[4]);

                        console.log(obj[0]);
                        console.log(obj[1]);
                        console.log(obj[2]);
                    }
                }
                else {
                    //convert response to json format
                    console.log("נכנס");

                    //printing the game name
                    $("#feedback").html("לא קיימים פרטים");

                }
            }
        });

}

function goBackPersonal() {
    var stepNum = JSON.parse(localStorage.getItem("stepValue"));
    window.location = 'step' + stepNum + '.html';
}

function logOut() {
    localStorage.setItem("textvalue", "");
   window.location = "signIn.html";
}

function signUp() {
    //get game code

    var emailUser = $("#emailUser").val();
    var passwordUser = $("#passwordUser").val();
    var userName = $("#userName").val();
    var kidName = $("#kidName").val();
    var KidBirthday = $("#KidBday").val();
    var KidStep = $("#KidStep").val();
    var partnerEmail = $("#partnerEmail").val();

    localStorage.setItem("textvalue", emailUser);
        //call to handler
        $.get("signUpHandler.ashx", {
            UserEmail: emailUser, //sent game code
            password: passwordUser,
            userName: userName,
            kidName: kidName,
            KidBday: KidBirthday,
            KidStep: KidStep,
            partnerEmail: partnerEmail

        },

            function (data, status) {
                console.log("הכפתור נלחץ");

                if (status == "success") {

                    //printing  the response in the console
                    console.log(data);

                    //if game not found or not publish
                    if (data != "") {
                       

                        if (data == "חסרים פרטים") {
                            console.log("בדיקה תנאי פנימי");
                            $("#feedback2").html(data);
                        }

                        else if (data == "כתובת האימייל שהזנת נמצאת בשימוש") {
                            $("#feedback2").html(data);
                        }

                        
                        else {

                            
                            var atpos = emailUser.indexOf("@");
                            var dotpos = emailUser.lastIndexOf(".");
                            if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= emailUser.length) {
                                $("#feedback2").html("האימייל שהזנת לא קיים");
                                    return false;
                                }
                            

                            var obj = JSON.parse(data);
                            
                            var stepNum = obj[0].toString();
                            localStorage.setItem("stepValue", stepNum);
                            var kidNameStorage = obj[1];
                            localStorage.setItem("kidNameValue", kidNameStorage);
                            var kidAgeStorage = obj[2];
                            localStorage.setItem("kidAgeValue", kidAgeStorage);
                   
                            
                           window.location = 'step' + stepNum + '.html';
                        }
 
                        //printing the message to the screen
                       
                        
                    }
                    else {
                        //convert response to json format
                        console.log("נכנס");

                        //כשאין בכלל פרטים בשום תיבה
                        $("#feedback2").html("לא מילאת פרטי הרשמה ");

                    }
                    
                }
            });
  
}

function update() {
    //get game code

    var userName = $("#userName").val();
    var kidName = $("#kidName").val();
    var KidBday = $("#KidBday").val();
    var KidStep = $("#KidStep").val();
    var partnerEmail = $("#partnerEmail").val();
    var result = $("#result").html();
   

    //call to handler
    $.get("profilSetting.ashx", {
        userName: userName,
        kidName: kidName,
        KidBday: KidBday,
        KidStep: KidStep,
        partnerEmail: partnerEmail,
        result: result
    },

        function (data, status) {
            console.log("update");
           
            if (status == "success") {

                //printing  the response in the console
                console.log(data);

                //if game not found or not publish
                if (data != "") {

                    var obj2 = JSON.parse(data);
                    $("#feedbackUpdate").html("הפרטים עודכנו בהצלחה");
                    var stepNum = obj2[0].toString();
                    localStorage.setItem("stepValue", stepNum);
                    var kidNameStorage = obj2[1];
                    localStorage.setItem("kidNameValue", kidNameStorage);
                    var kidAgeStorage = obj2[2];
                    localStorage.setItem("kidAgeValue", kidAgeStorage);
                    var userNameStorage = obj2[3];
                    localStorage.setItem("userNameValue", userNameStorage);
                    var birthdayDateStorage = obj2[4];
                    localStorage.setItem("kidBdayValue", birthdayDateStorage);

                    window.location = 'step' + stepNum + '.html';

                    console.log(obj2);
                    //להוסיף שליפה מחדש של השם והגיל מהדאטה בייס
                }
                else {
                 
                    $("#feedbackUpdate").html("לא שונו פרטים");

                }
            }
        });
}



function savePartnerConf() {
    var emailUser = $("#emailUser").val();
    var password = $("#passwordUser").val();
    var userName = $("#userName").val();
    var newPassword = $("#newPassword").val();
    //call to handler
    $.get("partnerConfirmation.ashx", {
        UserEmail: emailUser, //sent game code
        password: password,
        userName: userName,
        newPassword: newPassword
    },

        function (data, status) {
            console.log("הכפתור נלחץ");

            if (status == "success") {

                //printing  the response in the console
                console.log(data);

                //if game not found or not publish
                if (data != "") {

                    var obj = JSON.parse(data);
                    //printing the message to the screen
                    $("#feedback").html(obj);

                    window.location = 'step' + data.toString() + '.html';

                }
                else {
                    //convert response to json format
                    console.log("נכנס");

                    //printing the game name
                    $("#feedback").html("לא קיימים פרטים");

                }
            }
        });
}


//הוספה של מעקב התקדמות לתיק האישי
function addCommentBTN() {

    var comment = $("#comment").val();
    var postDate = $("#postDate").val();
    var emailUser = localStorage.getItem("textvalue");
    console.log(emailUser);
  // localStorage.setItem("textvalue", emailUser);
    //call to handler
    $.get("addComment.ashx", {
        comment: comment, //sent game code
        postDate: postDate,
        emailUser: emailUser
  
    },

        function (data, status) {
            console.log("הכפתור נלחץ");

            if (status == "success") {

                console.log(data);

               
                    window.location = 'personalFile.html';

                    
                }
             
            
        });
}

//כפתור מעבר לתיק אישי מדף התחברות
function goToPersonalFileBTN() {


    var emailUser = $("#emailUser").val();

    localStorage.setItem("textvalue", emailUser);

    window.location = 'personalFile.html';
   


}

//כפתור לא נרשמתי מדף הכניסה
function goToSignUpBTN() {

    window.location = 'signUp.html';

}
//כפתור חזור אחורה להתחברות מדף שכחתי סיסמא
function goBack() {
    window.history.back();
}

function plusCommentBTN() {

    window.location = 'addComment.html';
}

function passwordForgotBTN() {

    window.location = 'forgotPassword.html';

}

function sendPswEmail() {

    var emailUser = $("#emailUser").val();

    //call to handler
    $.get("forgotPassword.ashx", {
        UserEmail: emailUser //sent game code
        //stepValue: stepValue
    },

        function (data, status) {
            console.log("הכפתור נלחץ");

            if (status == "success") {

                //printing  the response in the console
                console.log(data);

                //if game not found or not publish
                if (data != "") {

                    var obj = JSON.parse(data);
                    //printing the message to the screen

                    if (obj == "המשתמש לא נכון") {
                        $("#feedback").html("לא קיים משתמש");
                    }
                    else {
                        $("#feedback").html(obj);

                        console.log(obj);
                    }
                    
                }
                else {
                    //convert response to json format
                    

                    //printing the game name
                    $("#feedback").html("הסיסמה נשלחה לאימייל שהוזן");

                }
            }
        });
}


