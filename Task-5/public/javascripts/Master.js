function redirect(url){
  window.location.href = url;
}

function validateDelete(url){
  if(confirm('Are you sure?')){
    redirect(url);
  }
}
