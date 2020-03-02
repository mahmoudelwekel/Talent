<?php include "header.php"; ?>
<?php
    $cnt=mysqli_connect(Host,UN,PW,DBname);
    $rslt=mysqli_query($cnt,"select * from talents");
    $n=$rslt->num_rows;
    $arr=mysqli_fetch_all($rslt);

?>
    <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
        <ol class="carousel-indicators">
            <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
            <?php
                for ($i=1;$i<$n;$i++) {
                    ?>
                    <li data-target="#carouselExampleIndicators" data-slide-to="<?php echo $i;?>"></li>
                    <?php
                }
                    ?>


        </ol>

        <div class="carousel-inner">
            <div class="carousel-item active">
                <img class="d-block w-100" src="<?php echo $arr[0][2];?>" alt="First slide">
                <div class="carousel-caption d-none d-md-block">
                    <h5 class="text-primary"><?php echo $arr[0][1];?> </h5>
                    <p class="text-primary"><?php echo $arr[0][3];?> </p>
                    <?php $x=$arr[0][0];?>
                    <a href='<?php echo"viewtalent.php?tid=$x" ?>' class="btn btn-outline-warning">شاهد الموهبه</a>
                </div>
            </div>
            <?php
            for ($i=1;$i<$n;$i++) {
                ?>
                <div class="carousel-item ">
                    <img class="d-block w-100" src="<?php echo $arr[$i][2];?>" alt="First slide">
                    <div class="carousel-caption d-none d-md-block">
                        <h5 class="text-primary"><?php echo $arr[$i][1];?> </h5>
                        <p class="text-primary"><?php echo $arr[$i][3];?> </p>
                        <?php $x=$arr[$i][0];?>
                        <a href='<?php echo"viewtalent.php?tid=$x" ?>' class="btn btn-outline-warning">شاهد الموهبه</a>
                    </div>
                </div>
            <?php
            }
            ?>
        </div>
        <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
        </a>
    </div>


    <div>
        <img class="d-block w-100" src="img\0.jpg" alt="Second slide">
    </div>

    <div class="text-center">
        <div class="row m-0 text-light text-center">
            <div class="col-md p-0 ">
                <div class="card rounded-0" style="background-color: #102e66">
                    <div class="card-body p-5">
                        <h3 class="card-title">خدماتنا</h3>
                        <hr>
                        <p class="card-text">الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة
                            الموهبة
                            الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة
                            الموهبة
                            الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة
                            الموهبة
                        </p>
                        <br>
                        <div class="row text-right">
                            <div class="col">
                                <p class="d-inline"> مشاهدة عالية <i class="fas fa-home"></i></p>
                            </div>
                            <div class="col">
                                <p class="d-inline"> نقد بناء <i class="fas fa-home"></i></p>
                            </div>
                        </div>
                        <br>
                        <div class="row text-right">
                            <div class="col">
                                <p class="d-inline"> نصائح و خبرات <i class="fas fa-home"></i></p>
                            </div>
                            <div class="col">
                                <p class="d-inline"> شارك موهبتك <i class="fas fa-home"></i></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md p-0 ">
                <div class="card rounded-0" style="background-color: #2a81c9">
                    <div class="card-body p-5">
                        <h3 class="card-title">عن الموقع</h3>
                        <hr>
                        <p class="card-text">الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة
                            الموهبة
                            الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة
                            الموهبة
                            الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة الموهبة
                            الموهبة
                        </p>
                        <br>
                        <div class="row text-right">
                            <div class="col">
                                <p class="d-inline"> سجل محتواك <i class="fas fa-home"></i></p>
                            </div>
                            <div class="col">
                                <p class="d-inline"> أرفع المحتوى <i class="fas fa-home"></i></p>
                            </div>
                        </div>
                        <br>
                        <div class="row text-right">
                            <div class="col">
                                <p class="d-inline"> تابع الأراء <i class="fas fa-home"></i></p>
                            </div>
                            <div class="col">
                                <p class="d-inline"> طور موهبتك <i class="fas fa-home"></i></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="bg-secondary text-center p-5">
        <h1>
            مواهب مواهب
        </h1>
        <hr>
        <br>
        <div class="owl-carousel owl-theme">
<?php
for ($i=0;$i<$n;$i++) {
    ?>
            <div class="item">
                <div class="card">
                    <div class="card-img-overlay align-items-center d-flex">
                        <h4 class="w-100 text-center mb-0 text-primary"><b><?php echo $arr[$i][1]?></b></h4>
                    </div>
                    <img class="img-fluid w-100 rounded" src="<?php echo $arr[$i][2]?>" alt="Card image">
                </div>
            </div>
           <?php } ?>
        </div>
    </div>

   

<?php include  "footer.php";?>