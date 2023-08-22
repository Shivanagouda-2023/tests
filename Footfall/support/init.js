/**
 * @file   This files defines the functions which will used to run feature files
 * @since  09.05.2023
 * @author Divya S
 */
var apickli = require("apickli");
const { Before, After, Given, Then, When , setDefaultTimeout } = require("cucumber");
const fs = require("fs");
var apiUrl1 = "/v1/footfall/reports";
var tracking_id=trackingID();

setDefaultTimeout(20 * 1000);

//sets up correct URL and also standard headers
Before({ tags: '@OAuth' }, function () {
    this.apickli = new apickli.Apickli("https", "api-testb.business.bt.com/oauth");
});

Before({ tags: '(@Positive or @Negative)' }, function () {
    this.apickli = new apickli.Apickli("https", "api-testb.business.bt.com" + apiUrl1);
    this.spgApickli = new apickli.Apickli("https", "api-testa.business.bt.com/v2/spg-mocker");
});

// Below method will set time delay to set custom attributes
Given(/^I wait for (.*) seconds$/, { timeout: 30000 }, function (timeout, callback) {
    setTimeout(function () {
        callback();
    }, timeout * 1000);
});

Given(/^I Set Timeout for (.*) milliseconds$/, { timeout: 70000 }, function (timeoutMillis, callback) {
    console.log("Timeout for " + timeoutMillis / 1000 + " Seconds");
    setTimeout(function () {
        console.log("Thanks for waiting.. Lets continue..");
        callback();
    }, timeoutMillis);
});

Then(/^dump response (.*)$/, function (type, callback) {
    console.log("      ==============================================================");
    console.log("      Response ");
    if (type == 'all' || type.indexOf('status') >= 0) {
        console.log('         Status code     = ' + this.apickli.httpResponse.statusCode);
        console.log('         Status Message  = ' + this.apickli.httpResponse.statusMessage);
    }
    if (type == 'all' || type.indexOf('body') >= 0) {
        console.log('         Body            = ' + this.apickli.httpResponse.body);
    }
    if (type == 'all' || type.indexOf('headers') >= 0) {
        console.log('         Headers : ');
        for (var a in this.apickli.httpResponse.headers) {
            console.log('            ' + a + ' = ' + this.apickli.httpResponse.headers[a]);
        }
    }
    console.log("      ==============================================================");
    callback();
});

Then(/^dump request (.*)$/, function (type, callback) {
    console.log("      ==============================================================");
    console.log("      Request ");

    if (type == 'all' || type.indexOf('body') >= 0) {
        console.log('         Body = ' + JSON.stringify(this.apickli.request));
    }
    if (type == 'all' || type.indexOf('headers') >= 0) {
        console.log('         Headers : ');
        for (var a in this.apickli.headers) {
            console.log('            ' + a + ' = ' + this.apickli.headers[a]);
        }
    }
    console.log("      ==============================================================");
    callback();
});


/* =============================================================================================
    Check JSON values are of correct data type
============================================================================================= */
Then(/^response body typed field (.*) should be (.*)$/, function (path, value, callback) {
    var jsonBody = JSON.parse(this.apickli.httpResponse.body);
    var jsonValue = addQuotesToString(jsonBody[path]); 
    var re = new RegExp('^' + value + '$');
    if (!re.test(jsonValue)) {
        callback('Unexpected value for ' + path);
    }
    callback();
});

 Then('response body field $.data[0].(.*) should be (.*)$', function (param,value) {
    // Write code here that turns the phrase above into concrete actions
    var jsonBody = JSON.parse(this.apickli.httpResponse.body);
    var jsonValue = addQuotesToString(jsonBody[param]); 
    var re = new RegExp('^' + value + '$');
    if (!re.test(jsonValue)) {
        callback('Unexpected value for ' + param);
    }
    callback();
           
});


//========================Check the data type of response fields ===========================
Then(/^response body field (.*) should be of type (.*)$/, function (path, type, callback) {
    type = type.toLowerCase();
    type = (type == "integer" || type == "number" || type == "long" || type == "float") ? "number" : (type == "array" || type == "list") ? "Array" : type
    var evalValue = this.apickli.evaluatePathInResponseBody(path);
    var actual;
    if (Array.isArray(evalValue)) {
        actual = "Array"
    } else {
        actual = typeof evalValue;
    }
    var success = (actual == type);
    if (success) {
        return callback();
    } else {
        return callback(prettyJson.render({
            success: success.toString(),
            expected: type,
            actual: actual,
            response: {
                statusCode: this.apickli.getResponseObject().statusCode.toString(),
                body: "Invalid data type"
            }
        }));
    }
});

function addQuotesToString(s) {
    if (typeof s == 'string') {
        return '"' + s + '"';
    } else {
        return s;
    }
}

function trackingID() {
    var uuid = require('uuid');
    var tracking_id = uuid.v4();
    return tracking_id;
}
