function validateUnique(val, obj, errmsg){
  var kolom = document.getElementById(obj);
  if(val == kolom.value){
    alert(errmsg);
    kolom.focus();
    return false;
  }
  return true;
}

function validateNumberOnly(obj, errmsg){
  var val = document.getElementById(obj).value;
  for (i = 0; i < val.length; i++){
    if(val[i]<'0' || val[i]>'9'){
      alert(errmsg);
      document.getElementById(obj).focus();
      return false;
    }
  }
  return true;
}

function validateUniqueCustomer(){
  var customer_list = document.getElementById("customer-list").value;
  var customer_name = customer_list[0];
  var customer_phone = customer_list[1];

  if(!validateNumberOnly("phone", "Please input valid phone number")) return false;
  for (i = 0; i < customer_list.length; i++){
    if (!validateUnique(customer_name[i], "name", "Duplicate Name")) return false;
    if (!validateUnique(customer_phone[i], "phone", "Duplicate Phone Number")) return false;
  }
  return true;
}