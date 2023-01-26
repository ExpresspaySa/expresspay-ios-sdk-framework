

function doIt(validation){
    
    var runningAmount     = 1.01;
    var runningTotal    = function() { return runningAmount + runningPP; }
    var shippingOption = "";
    
    var subTotalDescr    = "Test Goodies";
    
    var paymentRequest = {
        countryCode: "SA",
        currencyCode: "SAR",
        merchantCapabilities: ["supports3DS","supportsCredit","supportsDebit"],
        supportedNetworks: ["visa","masterCard","mada"],
        total: {
            amount: 1.01,
            label: "Zohaib"
        }
    };
   
   var session = new ApplePaySession(1, paymentRequest);
   
   // Merchant Validation
   session.onvalidatemerchant = function (event) {
       logit(event);
       var json = JSON.parse(validation)
//       session.completeMerchantValidation(json);
   }

//   session.onshippingcontactselected = function(event) {
//       logit('starting session.onshippingcontactselected');
//       logit('NB: At this stage, apple only reveals the Country, Locality and 4 characters of the PostCode to protect the privacy of what is only a *prospective* customer at this point. This is enough for you to determine shipping costs, but not the full address of the customer.');
//       logit(event);
//
//       getShippingOptions( event.shippingContact.countryCode );
//
//       var status = ApplePaySession.STATUS_SUCCESS;
//       var newShippingMethods = shippingOption;
//       var newTotal = { type: 'final', label: '<?=PRODUCTION_DISPLAYNAME?>', amount: runningTotal() };
//       var newLineItems =[{type: 'final',label: subTotalDescr, amount: runningAmount }, {type: 'final',label: 'P&P', amount: runningPP }];
//
//       session.completeShippingContactSelection(status, newShippingMethods, newTotal, newLineItems );
//
//
//   }
//
//   session.onshippingmethodselected = function(event) {
//       logit('starting session.onshippingmethodselected');
//       logit(event);
//
//       getShippingCosts( event.shippingMethod.identifier, true );
//
//       var status = ApplePaySession.STATUS_SUCCESS;
//       var newTotal = { type: 'final', label: '<?=PRODUCTION_DISPLAYNAME?>', amount: runningTotal() };
//       var newLineItems =[{type: 'final',label: subTotalDescr, amount: runningAmount }, {type: 'final',label: 'P&P', amount: runningPP }];
//
//       session.completeShippingMethodSelection(status, newTotal, newLineItems );
//
//
//   }
   
//   session.onpaymentmethodselected = function(event) {
//       logit('starting session.onpaymentmethodselected');
//       logit(event);
//
//       var newTotal = { type: 'final', label: '<?=PRODUCTION_DISPLAYNAME?>', amount: runningTotal() };
//       var newLineItems =[{type: 'final',label: subTotalDescr, amount: runningAmount }, {type: 'final',label: 'P&P', amount: runningPP }];
//
//       session.completePaymentMethodSelection( newTotal, newLineItems );
//
//
//   }
   
   session.onpaymentauthorized = function (event) {

       logit('starting session.onpaymentauthorized');
       logit('NB: This is the first stage when you get the *full shipping address* of the customer, in the event.payment.shippingContact object');
       logit(event);

       var promise = sendPaymentToken(event.payment.token);
       promise.then(function (success) {
           var status;
           if (success){
               status = ApplePaySession.STATUS_SUCCESS;
               document.getElementById("applePay").style.display = "none";
               document.getElementById("success").style.display = "block";
           } else {
               status = ApplePaySession.STATUS_FAILURE;
           }
           
           logit( "result of sendPaymentToken() function =  " + success );
           session.completePayment(status);
       });
   }

   function sendPaymentToken(paymentToken) {
       return new Promise(function(resolve, reject) {
           logit('starting function sendPaymentToken()');
           logit(paymentToken);
           
           logit("this is where you would pass the payment token to your third-party payment provider to use the token to charge the card. Only if your provider tells you the payment was successful should you return a resolve(true) here. Otherwise reject;");
           logit("defaulting to resolve(true) here, just to show what a successfully completed transaction flow looks like");
           if ( debug == true )
           resolve(true);
           else
           reject;
       });
   }
   
   session.oncancel = function(event) {
       logit('starting session.cancel');
       logit(event);
   }
   
   session.begin();

};

function logit( data ){
    
    if( debug == true ){
        console.log(data);
    }

};
