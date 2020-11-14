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
  list_name = document.getElementById("list-customer-name").value.split(",");
  list_phone = document.getElementById("list-customer-phone").value.split(",");

  if(!validateNumberOnly("phone", "Please input valid phone number")) return false;

  for (i = 0; i < list_name.length; i++){
    if (!validateUnique(list_name[i], "name", "Duplicate Name, please check existing customer")) return false;
    if (!validateUnique(list_phone[i], "phone", "Duplicate Phone Number, please check existing customer")) return false;
  }
  return true;
}