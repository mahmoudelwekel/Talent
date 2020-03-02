<?php
include "../dbinfo.php";
$cn=mysqli_connect(Host,UN,PW,DBname);
if($_POST["usertype"]==1&&isset($_POST["uname"])&&isset($_POST["pass"])&&isset($_POST["fname"]))
{
    $fname=$_POST["fname"];
    $pw=$_POST["pass"];
    $uname=$_POST["uname"];

    $pw=mysqli_real_escape_string($cn,$pw);
    $fname=mysqli_real_escape_string($cn,$fname);
    $uname=mysqli_real_escape_string($cn,$uname);
    $qry=mysqli_query($cn,"call registerusers('$fname','$uname','$pw','audience')");

    if( mysqli_error($cn)) echo mysqli_error($cn) ;

    else header("location:../index.php");
}
else if($_POST["usertype"]==2&&isset($_POST["uname"])&&isset($_POST["pass"])&&isset($_POST["fname"])&&isset($_POST["mob"])&&isset($_POST["adr"]))
{
    $fname=$_POST["fname"];
    $pw=$_POST["pass"];
    $uname=$_POST["uname"];
    $mob=$_POST["mob"];
    $address=$_POST["adr"];
    $talent_id=$_POST['tid'];
    $uname=mysqli_real_escape_string($cn,$uname);
    $pw=mysqli_real_escape_string($cn,$pw);
    $fname=mysqli_real_escape_string($cn,$fname);
    $mob=mysqli_real_escape_string($cn,$mob);
    $address=mysqli_real_escape_string($cn,$address);
    $talent_id=mysqli_real_escape_string($cn,$talent_id);

    if ($_FILES["img"]["size"] >0 )
    {
        $img_name ="../uimg/users/$uname" . date("Ymdhis").".".pathinfo($_FILES["img"]["name"],PATHINFO_EXTENSION  );
        $img_name1 ="uimg/users/$uname" . date("Ymdhis").".".pathinfo($_FILES["img"]["name"],PATHINFO_EXTENSION  );
        move_uploaded_file($_FILES["img"]["tmp_name"] , $img_name);
        $qry = mysqli_query($cn , "call registertalent('$fname','$uname','$pw','$mob','$address','$img_name1','$talent_id');");

        echo mysqli_error($cn);
    }
    if( mysqli_error($cn)) echo mysqli_error($cn) ;

   else header("location:../index.php");

}
else echo  header("location:../index.php?error=invalid");
