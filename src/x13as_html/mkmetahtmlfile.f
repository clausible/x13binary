      SUBROUTINE mkMetaHTMLFile(fh0,insrs,outsrs,datsrs,nopen,
     &                          unopnd,Ldata,mtafil,nmfil)
      IMPLICIT NONE
C-----------------------------------------------------------------------
      INCLUDE 'stdio.i'
      LOGICAL T,F
      PARAMETER(T=.true.,F=.false.)
C-----------------------------------------------------------------------
      CHARACTER Mtafil*(PFILCR),Outsrs*(PFILCR),Insrs*(PFILCR),
     &          Datsrs*(PFILCR),thisExt*(3),thisFile*(PFILCR),
     &          newoutf*(PFILCR)
      LOGICAL Ldata,iOK
      INTEGER fh0,nopen,unopnd,i,iopen,n1,n2,n3,n4,nmfil,nmfile,nnewf,
     &        nnewflst
      DIMENSION Outsrs(PSRS),Insrs(PSRS),Datsrs(PSRS),unopnd(PSRS)
C-----------------------------------------------------------------------
      INTEGER nblank,lstpth
      EXTERNAL nblank,lstpth
C-----------------------------------------------------------------------
      IF (Ldata) THEN
       thisExt='dta'
      ELSE
       thisExt='mta'
      END IF
      thisFile=Mtafil(1:nmfil)//'_'//thisExt//'.html'
      nmfile=nmfil+9
      OPEN(UNIT=fh0,FILE=thisFile(1:nmfile),STATUS='UNKNOWN',ERR=20)
      IF (Ldata) THEN
       CALL mkHead(fh0,thisFile(1:nmfile),'Index of '//PRGNAM//
     &             ' Data Meta File ('//Mtafil(1:nmfil)//'.dta)',
     &             F,2,-1,F)
       CALL writTagOneLine(fh0,'h1','center',
     &             'Index for Data Meta File '//Mtafil(1:nmfil)//'.dta')
      ELSE
       CALL mkHead(fh0,thisFile(1:nmfile),'Index of '//PRGNAM//
     &             '  Meta File ('//Mtafil(1:nmfil)//'.mta)',F,2,-1,F)
       CALL writTagOneLine(fh0,'h1','center',
     &                  'Index for Meta File '//Mtafil(1:nmfil)//'.mta')
      END IF
      CALL mkPOneLine(fh0,'@','&nbsp;')
      WRITE(fh0,1000)0
 1000 FORMAT(/,'<p class="right"><a href="skip',i5.5,'" ',
     &         'title="Skip navagation link" class="skiplinks">',
     &         '&nbsp;</a></p>')
      CALL writTagClass(fh0,'ul','indent')
      WRITE(fh0,1010)'#out',PRGNAM//' Output files generated by '//
     &               Mtafil(1:nmfil)//'.'//thisExt
      WRITE(fh0,1010)'#err',PRGNAM//' Error files generated by '//
     &               Mtafil(1:nmfil)//'.'//thisExt
      WRITE(fh0,1010)'#log','Log file entries for '//Mtafil(1:nmfil)//
     &               '_log.html'
      CALL writTag(fh0,'</ul>')
      CALL mkPOneLine(fh0,'@','&nbsp;')
 1010 FORMAT('<li> <a href="',a,'"> ',a,' </a> </li>')
      CALL makeAnchor(fh0,0,'skip')
C-----------------------------------------------------------------------
      CALL makeAnchor(fh0,-1,'out')
      CALL writTagOneLine(fh0,'h2','@',
     &      'Output files generated by '//Mtafil(1:nmfil)//'.'//thisExt)
      CALL writTagClass(fh0,'ul','indent')
      iopen=1
c        write(*,*)' Output files'
      DO i=1,Imeta
       newoutf=' '
       iOK=T
       IF(nopen.gt.0)THEN
        IF(unopnd(iopen).eq.i)THEN
         iOK=F
         IF(iopen.lt.nopen)iopen=iopen+1
        END IF
       END IF
       IF(iOK)THEN
        n1=nblank(outsrs(i))
        n4=lstpth(outsrs(i),n1)+1
        CALL cnvfil(outsrs(i),n1,newoutf,nnewf,nnewflst)
c        write(*,*)outsrs(i)(1:n1)
c        write(*,*)newoutf(1:nnewf)
        IF(Ldata)THEN
         n2=nblank(datsrs(i))
         n3=lstpth(datsrs(i),n2)+1
c         write(*,*)'  ',newoutf(1:nnewf)//'.html   Output   ',
c     &                  datsrs(i)(n3:n2)
c         write(*,*)'  n2, n3 = ',n2,' ',n3
         WRITE(fh0,1020)newoutf(1:nnewf)//'.html','Output',
     &                  datsrs(i)(n3:n2)
        ELSE
         n2=nblank(insrs(i))
         n3=lstpth(insrs(i),n2)+1
         WRITE(fh0,1020)newoutf(1:nnewf)//'.html','Output',
     &                  insrs(i)(n3:n2)//'.spc'
        END IF
       END IF
      END DO
 1020 FORMAT('<li> <a href="',a,'"> ',a,' file for ',a,'</a> </li>')
      CALL writTag(fh0,'</ul>')
      CALL mkPOneLine(fh0,'@','&nbsp;')
C-----------------------------------------------------------------------
      CALL makeAnchor(fh0,-1,'err')
      CALL writTagOneLine(fh0,'h2','@',
     &       'Error files generated by '//Mtafil(1:nmfil)//'.'//thisExt)
      CALL writTagClass(fh0,'ul','indent')
      iopen=1
      DO i=1,Imeta
       iOK=T
       IF(nopen.gt.0)THEN
c        write(*,*)'  iopen, unopnd(iopen), i = ',iopen, unopnd(iopen), i
        IF(unopnd(iopen).eq.i)THEN
         iOK=F
         IF(iopen.lt.nopen)iopen=iopen+1
c         write(*,*)'  iOK = F'
        END IF
       END IF
       IF(iOK)THEN
        n1=nblank(outsrs(i))
        CALL cnvfil(outsrs(i),n1,newoutf,nnewf,nnewflst)
        IF(Ldata)THEN
         n2=nblank(datsrs(i))
         n3=lstpth(datsrs(i),n2)+1
         WRITE(fh0,1030)newoutf(1:nnewf)//'_err.html','Error',
     &                  datsrs(i)(n3:n2)
        ELSE
         n2=nblank(insrs(i))
         n3=lstpth(insrs(i),n2)+1
         WRITE(fh0,1030)newoutf(1:nnewf)//'_err.html','Error',
     &                  insrs(i)(n3:n2)//'.spc'
        END IF
       END IF
      END DO
 1030 FORMAT('<li> <a href="',a,'"> ',a,' file for ',a,'</a> </li>')
      CALL writTag(fh0,'</ul>')
      CALL mkPOneLine(fh0,'@','&nbsp;')
C-----------------------------------------------------------------------
      CALL makeAnchor(fh0,-1,'log')
      CALL writTagOneLine(fh0,'h2','@',
     &            'Log file entries for '//Mtafil(1:nmfil)//'_log.html')
      CALL writTagClass(fh0,'ul','indent')
      iopen=1
      DO i=1,Imeta
       iOK=T
       IF(nopen.gt.0)THEN
        IF(unopnd(iopen).eq.i)THEN
         iOK=F
         IF(iopen.lt.nopen)iopen=iopen+1
        END IF
       END IF
       IF(iOK)THEN
        CALL cnvfil(Mtafil,nmfil,newoutf,nnewf,nnewflst)
        IF(Ldata)THEN
         n2=nblank(datsrs(i))
         n3=lstpth(datsrs(i),n2)+1
         WRITE(fh0,1040)newoutf(1:nnewf),'#pos',i,datsrs(i)(n3:n2)
        ELSE
         n2=nblank(insrs(i))
         n3=lstpth(insrs(i),n2)+1
         WRITE(fh0,1040)newoutf(1:nnewf),'#pos',i,insrs(i)(n3:n2)
        END IF
       END IF
      END DO
      CALL writTag(fh0,'</ul>')
      CALL mkPOneLine(fh0,'@','&nbsp;')
 1040 FORMAT('<li> <a href="',a,'_log.html',a,i5.5,'"> Log Entry for ',
     &       a,' </a> </li>')
C-----------------------------------------------------------------------
      CALL writTag(fh0,'</body>')
      CALL writTag(fh0,'</html>')
      RETURN
C-----------------------------------------------------------------------
   20 WRITE(STDERR,1025)' Unable to open '//Mtafil(1:nmfil)//'_'//
     &                  thisExt//'.html'
      CALL abend 
 1025 FORMAT(/,a)
C-----------------------------------------------------------------------
      END
        