<?php include  "header.php";?>
<!-- page content -->
<?php
if(isset($_GET['s']))
    $s=$_GET['s'];
else
    header("location:index.php");
$cnsearch=mysqli_connect(Host,UN,PW,DBname);
$rsltsearch=mysqli_query($cnsearch,"select m.id,m.upload_date,m.description,u.fullname,m.media_type from media m join talented t on(t.id=m.talent_id)  join users u on(u.id=m.talent_id) join talents ts on(ts.id=t.talent_cat_id) where m.state like 'accepted' and concat(m.description,' ',u.fullname,' ',ts.tname) like '%$s%' order by  m.upload_date desc")
?>


<div class="border border-secondary border-top-0" style="background-color:#2a81c9;color:#FFFFFF;padding-top:100px;padding-bottom:50px;">
    <div class="container text-center " style="">
        <form method="get" action="search.php">
                        <div class="input-group mb-5">

                            <input class="form-control  rounded-right" aria-describedby="basic-addon1"  name="s"     ID="loginusername" placeholder="أدخل كلمة البحث" AutoCompleteType="None" autofocus
                                requiredtype="text" />
                            <span class="input-group-addon  rounded-left" id="basic-addon1"><button type="button" onclick="submit()"     class="btn btn-success  rounded-left" ID="Button1"><i
                                       class="fas fa-search"></i></button></span>
                            </form>
                        </div>
        <div class="card-columns"  >

            <?php
            $t=0;
            while ($arrsearch=mysqli_fetch_array($rsltsearch))
            {
                $t=1;
                if($arrsearch[4]=="video")
                    $rsltimg=mysqli_query($cnsearch,"select video from videos where id =$arrsearch[0]");
                else if($arrsearch[4]=="images")
                    $rsltimg=mysqli_query($cnsearch,"select  img from images where media_id=$arrsearch[0] limit 1");

                $arrimg=mysqli_fetch_array($rsltimg);

                ?>
                <div class="bg-white text-primary card ">
                   <a href="<?php if($arrsearch[4]=='video')echo "video.php?mid=$arrsearch[0]"; else echo "image.php?mid=$arrsearch[0]"; ?>">
                       <?php if($arrsearch[4]=='video') { ?>
                       <video width="320" height="240" >
                           <source src="<?php echo $arrimg[0]; ?>" type="video/mp4">
                           <source src="<?php echo $arrimg[0]; ?>" type="video/mkv">
                           <source src="<?php echo $arrimg[0]; ?>" type="video/avi">
                       </video>
                       <?php } else {?>
                        <img class="img-fluid img-thumbnail  w-75 mx-auto mt-3" src="<?php echo $arrimg[0]; ?>" alt="Card image">
                       <?php } ?>


                       <div class="card-body">
                        <h4 class="card-title"><?php echo $arrsearch[3] ?></h4>
                        <p class=""><?php echo $arrsearch[1] ?></p>
                        <p class=""><?php echo $arrsearch[2] ?> </p>
                    </div></a>
                </div>
            <?php }
            ?>


        </div>


    <?php if($t==0)
        echo '<div class="alert alert-light" role="alert">
! لا يوجد نتائج للبحث
</div>'; ?>



    </div>
</div>


    <script>
        $('.card-columns').paginate({
            scope: $('.card'),

            // how many items per page
            perPage:6,
        });
    </script>


<?php include  "footer.php";?>