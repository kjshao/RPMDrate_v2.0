      double precision FUNCTION brent(ax,bx,cx,f,tol,xmin)
      INTEGER ITMAX
      double precision ax,bx,cx,tol,xmin,CGOLD,ZEPS,f
c      PARAMETER (ITMAX=100,CGOLD=.3819660d0,ZEPS=1.0d-10)
      PARAMETER (ITMAX=200,CGOLD=.3819660d0,ZEPS=1.0d-9)
      INTEGER iter
      external f
      double precision a,b,d,e,etemp,fu,fv,fw,fx,p,q,r
     &                 ,tol1,tol2,u,v,w,x,xm
      a=min(ax,cx)
      b=max(ax,cx)
      v=bx
      w=v
      x=v
      e=0.d0
      fx=f(x)
      fv=fx
      fw=fx
      do 11 iter=1,ITMAX
        xm=0.5d0*(a+b)
        tol1=tol*abs(x)+ZEPS
        tol2=2.d0*tol1
        if(abs(x-xm).le.(tol2-.5d0*(b-a))) goto 3
        if(abs(e).gt.tol1) then
          r=(x-w)*(fx-fv)
          q=(x-v)*(fx-fw)
          p=(x-v)*q-(x-w)*r
          q=2.*(q-r)
          if(q.gt.0.) p=-p
          q=abs(q)
          etemp=e
          e=d
          if(abs(p).ge.abs(.5*q*etemp).or.p.le.q*(a-x).or.p.ge.q*(b-x)) 
     *goto 1
          d=p/q
          u=x+d
          if(u-a.lt.tol2 .or. b-u.lt.tol2) d=sign(tol1,xm-x)
          goto 2
        endif
1       if(x.ge.xm) then
          e=a-x
        else
          e=b-x
        endif
        d=CGOLD*e
2       if(abs(d).ge.tol1) then
          u=x+d
        else
          u=x+sign(tol1,d)
        endif
        fu=f(u)
        if(fu.le.fx) then
          if(u.ge.x) then
            a=x
          else
            b=x
          endif
          v=w
          fv=fw
          w=x
          fw=fx
          x=u
          fx=fu
        else
          if(u.lt.x) then
            a=u
          else
            b=u
          endif
          if(fu.le.fw .or. w.eq.x) then
            v=w
            fv=fw
            w=u
            fw=fu
          else if(fu.le.fv .or. v.eq.x .or. v.eq.w) then
            v=u
            fv=fu
          endif
        endif
11    continue
c      pause 'brent exceed maximum iterations'
3     xmin=x
      brent=fx
      return
      END
C  (C) Copr. 1986-92 Numerical Recipes Software <%8.
