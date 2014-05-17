FriendLocation
==============

see all your friends location who regists the app

## 1、Here is a php file work for the ios demo,but you should find medoo.php first.U can get it through the Internet.I won't display it.

<pre><code>
  
require('medoo.php');
$action = $_GET['action'];

$username = $_GET['username'];
$userid = $_GET['userid'];
if(!isset($username) && !isset($userid)){
  
  echo 'wrong';
  exit(0);

}
$database = new medoo(array(
  // required
  'database_type' => 'mysql',
  'database_name' => 'mydb',
  'server' => 'localhost',
  'username' => 'root',
  'password' => 'admin',
 
  // optional
  'port' => 3306,
  'charset' => 'utf8',
  // driver_option for connection, read more from http://www.php.net/manual/en/pdo.setattribute.php
  'option' => array(
    PDO::ATTR_CASE => PDO::CASE_NATURAL
  )
));

//$database = new medoo();

if($action == 'reg'){
  
  $sql = "select * from user where name= '$username';";
  $r = $database->query($sql)->fetchAll();  
  if($r){
    
    echo "用户已注册";
    exit(0);
  
  }
  $lati = $_GET['latitude'];
  $longi = $_GET['longitude'];
  $curtime = date("Y-m-d H:i:s");
  $userinfo = array('name'=>$username,'reg_time'=>$curtime);
  $rv = $database->insert("user",$userinfo);
  if($rv){
  
    $userlo = array('user_id'=>$rv, 'user_latitude'=>$lati, 'user_longitude'=>$longi,'last_update'=>$curtime,'forbidden'=>' ');
    $r = $database->insert("user_location",$userlo);
    echo $rv;
  }
}
else if ($action == 'login'){

  $id = $database->select('user',"*", array('name='=>$username));
  if($id){
  
    echo json_encode($id);
  }
  else
    echo 0;

  exit(0);

}
else if ($action == 'changeMyPermission') {
   
   $enable = $_GET['enable'];
   $userinfo = array('enable'=>$enable);
  
   $r = $database->update("user_location",$userinfo,array('user_id='=>$userid));
   echo $r; // 返回值：受影响的行数.
}

else if ($action == 'getMyPermisson') {
    $id = $database->select('user_location',"enable", array('user_id'=>$userid));
    if ($id) {
      echo $id[0];
    }
    else
      echo 0;
    exit(0);
}



else if ($action == 'changePermission'){

/*
  $userlist = $_POST['userlist'];
  $permit = $_GET['permit'];
  if(isset($userlist)){

    $userinfo = array('location_permit'=>$permit);
    $r = $database->update("user_friend",$userinfo,array('user_id='=>$userid));
    echo $r;    

  }
*/
  $userlist = $HTTP_RAW_POST_DATA;
  $permit = $_GET['permit'];
  $userlist = json_decode($userlist);
  $ids = $userlist->userlist;
    
  foreach($ids as $a){
    
    //echo $a->user_friend_id;
    $f_id =$a->user_friend_id;  
    $userinfo = array('location_permit'=>$permit);
    $r = $database->update("user_friend",$userinfo,array('user_id='=>$f_id));
    echo $r;            
  } 
}
else if ($action == 'getFriedsLocationById'){

  $userlist = $HTTP_RAW_POST_DATA;
  $userlist = json_decode($userlist);
  $ids = $userlist->userlist;
  $f_id = "(";
  foreach($ids as $a){
    
    $dd = $a->user_friend_id;
    //echo $a->user_friend_id;
    $sql = "select * from user_friends where user_friend_id=$dd and location_permit=1;";
    $r = $data = $database->query($sql)->fetchAll();
    if($r)
      $f_id =$f_id.$dd.",";
  
  } 
    $f_id = substr_replace($f_id,")",-1,1);

    $sql = "select * from user_location where user_id in ";
    $sql = $sql.$f_id;
    $data = $database->query($sql)->fetchAll();
    echo json_encode($data);  
}
else if ($action == 'addFriends'){

  
  $userlist = $HTTP_RAW_POST_DATA;
  $userlist = json_decode($userlist);
  $ids = $userlist->userlist;
    
  foreach($ids as $a){
    
    //echo $a->user_friend_id;
    $f_id =$a->user_friend_id;
    $userfriend = array('user_id'=>$userid, 'user_friend_id'=>$f_id, 'location_permit'=>1);
    $r = $database->insert("user_friends",$userfriend);
    echo $r;    
  }

}
else if ($action == 'getAllUser'){

  $data = $database->query("select * from user;")->fetchAll();
  echo json_encode($data);  

}
else if ($action == 'getFriedsLocation'){
  

//  $id = $database->select('user','id', array('name[=]'=>$username));
//  $userid = $id[0];
//  $friendsid = $database->select('user_friends','user_friend_id', array('user_id='=>$userid));
  $friendsid = $database->query("select user_friend_id from user_friends where user_id=$userid and location_permit=1;")->fetchAll();
//  echo json_encode($friendsid);
  $f_id = "(";
  foreach($friendsid as $v){
  
  //  $f_id = $f_id.$v.",";
    $f_id = $f_id.$v["user_friend_id"].",";
  }
  $f_id = substr_replace($f_id,")",-1,1);
//  echo json_encode($f_id);
  $sql = "select * from user_location where user_id in ";
  $sql = $sql.$f_id;
  $data = $database->query($sql)->fetchAll();
  echo json_encode($data);  

}
else if ($action == 'uploadMyLocation'){

  $latitude = $_GET['latitude'];
  $longitude = $_GET['longitude'];
  $userlo = array('user_latitude'=>$latitude, 'user_longitude'=>$longitude,'last_update'=>date("Y-m-d H:i:s"));
  $r = $database->update("user_location",$userlo,array('user_id='=>$userid));
  echo $r;
}
else if ($action == 'getAllUserLocaltion'){

$sql = 'SELECT user_location.id,user_location.user_id,user_location.user_latitude,user_location.user_longitude,user_location.last_update ,user_location.forbidden, user.name FROM user_location,user WHERE user_location.user_id = user.id and enable<>2'; 
  //$sql = "select * from user_location ";
  $data = $database->query($sql)->fetchAll();
  echo json_encode($data);
  
}
 
 // 不让某人看见我位置
else if ($action == 'forbidden') {
  // forbidden为好友姓名、查找好友 的ID
  $newForbidden = $_GET['forbidden'];
   $sql = "select id from user where name= '$newForbidden' ";
    
   $data = $database->query($sql)->fetchAll();
   //echo ($data[0]['id']);
   $friendID = $data[0]['id'];// 获取friendID

   $sql_searchFo = " select forbidden from user_location where user_id='$friendID' ";
   $data = $database->query($sql_searchFo)->fetchAll();
   $forbidden = $data[0]['forbidden'];

    if ($forbidden == NULL|| $forbidden == ' ') {
        $forbidden =  '|'.$userid.'|';
     }
     else{
        $forbidden = $forbidden.$userid.'|';
     }
   //  echo $forbidden;

   // 判断原有字符串是否已经包含了forbidden字符串
    $userFo = array('forbidden' => $forbidden );
     $r = $database->update("user_location",$userFo,array('user_id='=>$friendID));
     echo $r;
   
    
      
}
// 让某人看见我位置
else if ($action =='rmForbidden') {
     $rmForbidden = $_GET['forbidden'];
    $rmFoPerson = '|'.$rmFoPerson.'|';
   $sql = "select id from user where name= '$rmForbidden' ";
    
   $data = $database->query($sql)->fetchAll();
   //echo ($data[0]['id']);
   $friendID = $data[0]['id'];// 获取friendID

   // 把我的ID加上| |替换成|
   $userid = '|'.$userid.'|';

   $sql_searchFo = " select forbidden from user_location where user_id='$friendID' ";
   $data = $database->query($sql_searchFo)->fetchAll();
   $forbidden = $data[0]['forbidden'];
    
    $forbidden =   str_replace($userid,'|',$forbidden);
  //  echo($forbidden.'<br>');     
 $userFo = array('forbidden' => $forbidden );
     $r = $database->update("user_location",$userFo,array('user_id='=>$friendID));
     echo $r;
     
  }

// 查勘forbidden字符串
else if ($action == 'searchFobidden') {
   $sql = "select user_location.forbidden from user,user_location where user.id=user_location.user_id ";
   $r = $database->query($sql)->fetchAll();
   echo(json_encode($r));
}



else if ($action == 'uploadDeviceToken'){  // 上传苹果设备token
  $token = $_GET['token'];  
 
  $sql = "select * from user_token where token='$token';";
  $r = $database->query($sql)->fetchAll();
  if($r){
    echo "用户设备已经添加";
    exit(0);
  }
 

  $userinfo = array('token'=>$token);
  $rv = $database->insert("user_token",$userinfo);
   
   
  if($rv)
    echo "success";
  else
    echo "failed";
 
  
}
 
else {

  echo "niubi";
}

 

</code></pre>
## 2、 There are some function that i have not use it .
## 3、 In the ios demo,you can find your friends' location,at the same time ,you can also hide your location in order not to let others see you .
## 4、 If you want to see only one person's location,the map will appear his location only .
## 5、I sove a problem that the transform between baiduGPS with iosGPS.

<pre><code>
//  把火星坐标转换成百度坐标
-(CLLocationCoordinate2D)hhTrans_bdGPS:(CLLocationCoordinate2D)fireGps
{
    
    CLLocationCoordinate2D bdGps;
    
    double huo_x=fireGps.longitude;
    
    double huo_y=fireGps.latitude;
    
    double z = sqrt(huo_x * huo_x + huo_y * huo_y) + 0.00002 * sin(huo_y * x_pi);
    
    double theta = atan2(huo_y, huo_x) + 0.000003 * cos(huo_x * x_pi);
    
    bdGps.longitude = z * cos(theta) + 0.0065;
    
    bdGps.latitude = z * sin(theta) + 0.006;
    
    return bdGps;
    
}

// 百度转火星
-(CLLocationCoordinate2D)hhTrans_GCGPS:(CLLocationCoordinate2D)baiduGps
{
    
    CLLocationCoordinate2D googleGps;
    
    double bd_x=baiduGps.longitude - 0.0065;
    
    double bd_y=baiduGps.latitude - 0.006;
    
    double z = sqrt(bd_x * bd_x + bd_y * bd_y) - 0.00002 * sin(bd_y * x_pi);
    
    double theta = atan2(bd_y, bd_x) - 0.000003 * cos(bd_x * x_pi);
    
    googleGps.longitude = z * cos(theta);
    
    googleGps.latitude = z * sin(theta);
    
    return googleGps;
    
}

</code></pre>

## I may be add some other function a few days later.
# Thank you for suppoting me .
