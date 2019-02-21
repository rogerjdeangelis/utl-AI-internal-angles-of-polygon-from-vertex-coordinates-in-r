AI Internal angles of polygon from vertex coordinates in r

You don't need to know much about R to do this

github
https://tinyurl.com/y6yud2hs
https://github.com/rogerjdeangelis/utl-AI-internal-angles-of-polygon-from-vertex-coordinates-in-r

StackOverflow
https://tinyurl.com/y65nro39
https://stackoverflow.com/questions/54675128/calculate-internal-angles-of-polygon-from-vertex-coordinates-in-r

INPUT
=====

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
input x y poly;
cards4;
180 300 2
200 320 2
180 380 2
200 360 2
;;;;
run;quit;

SD1.HAVE total obs=4

   X      Y     POLY

  180    300      2
  200    320      2
  180    380      2
  200    360      2

      Y
      |        |
      |        |
  380 +        *
      |        |\
      |        | \
      |        |  \
      |        |   \
  360 +        |    \
      |        |     *
      |        |
    ...       ..
      |        |
      |        |      *
  320 +        |    /
      |        |   /
      |        |  /
      |        | /
      |        |/
  300 +        *
      |        |
      --+------+------+------+- X
       160    180    200    220

               X

EXAMPLE OUTPUT
--------------


      Y
      |        |
      |        |
  380 +        * 135
      |        |\
      |        | \
      |        |  \
      |        |45 \
  360 +        |    \
      |        |     *
      |        |
    ...       ..
      |        |
      |        |      *
  320 +        |    /
      |        |   /
      |        |45/
      |        | /
      |        |/
  300 +        * 135
      |        |
      --+------+------+------+- X
       160    180    200    220

               X

work WANT total obs=4

 ANGLES     X      Y     POLY

   135     180    300      2
    45     180    380      2
    45     200    320      2
   135     220    360      2

PROCESS
=======

%utl_submit_r64('
library(SASxport);
library(haven);
library(dplyr);
have<-read_sas("d:/sd1/have.sas7bdat");
aa <- have[ have$POLY == 2, ];
aa <- aa[ chull(aa[,1:2]), ];
ind <- seq_len(nrow(aa));
indm1 <- c(ind[-1], ind[1]);
indm1;
indp1 <- c(ind[length(ind)], ind[-length(ind)]);
angles <- ((atan2(aa$Y[indm1] - aa$Y[ind], aa$X[indm1] - aa$X[ind]) -
              atan2(aa$Y[indp1] - aa$Y[ind], aa$X[indp1] - aa$X[ind])) * 180 / pi) %% 360;
cbind(indm1,ind,indp1);
want<-as.data.frame(angles);
want;
write.xport(want,file="d:/xpt/want.xpt");
');

libname xpt xport "d:/xpt/want.xpt";
data want ;
   merge xpt.want have;
run;quit;
libname xpt clear;

proc print data=want;
run;quit;

