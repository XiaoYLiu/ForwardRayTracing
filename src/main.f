program main


use parameters
use constants
use tensors
use initial_conditions
use integrate

implicit none 

real(kind=dp),dimension(3) :: ki !Comoving beam direction vector. Magnitude 1.
real(kind=dp), dimension(3) :: xi !local vector location
real(kind=dp), dimension(3) :: xi_global !global vector location
real(kind=dp), dimension(6) :: v !Variables (r,theta,phi,t,pr,ptheta)

real(kind=dp) :: xglobal, yglobal, zglobal, w

real(kind=dp) :: rmag, mag_check1, mag_check2

integer(kind=dp) :: counter, j

real(kind=dp), dimension(int(1e8),6) :: AllData !Big array to save all data
real(kind=dp) :: mm, xC, yC, zC

!Set up save location
call get_environment_variable("RayTracingDir", path)






!Define tangent vector in cartesian components 
ki(1) = 1.0_dp*sin(psi)*cos(chi) !xdot
ki(2) = 1.0_dp*sin(psi)*sin(chi) !ydot
ki(3) = 1.0_dp*cos(psi) !zdot




!Define location of vector in local coordinates
rmag = RPSR_M
xi(1) = rmag*sin(psi)*cos(chi) !xdot
xi(2) = rmag*sin(psi)*sin(chi) !ydot
xi(3) = rmag*cos(psi) !zdot


!For now we take the 'location' of the vector as just being the COM.
!It is an open question 

xi_global(1) = rCOM
xi_global(2) = thetaCOM
xi_global(3) = phiCOM


call set_initial_conditions(ki,xi,xi_global,v)

counter = 1

!print *, v(1), dh



mm = sqrt(v(1)**2 + a**2)
xC = mm*sin(v(2))*cos(v(3))
yC = mm*sin(v(2))*sin(v(3))
zC = v(1)*cos(v(2))






!do while (counter .LT. 100)

do while (v(1) .GT. Rhor .and. v(1) .LT. 1000.0_dp)

call rk(v)


mm = sqrt(v(1)**2 + a**2)
xC = mm*sin(v(2))*cos(v(3))
yC = mm*sin(v(2))*sin(v(3))
zC = v(1)*cos(v(2))



!print *, 'X=', xC
!print *, xC,yC,zC


!print *, v(1), dh
AllData(counter,:) = v
counter = counter + 1
enddo


print *, 'Final r. Check for NaN:', v(1)







!Save output for plotting

    open(unit=20,file=trim(adjustl(path))//'test.txt',status='replace',form='formatted')

    do j = 1,counter-1
    xC = sqrt(AllData(j,1)**2 + a**2) * sin(AllData(j,2))*cos(AllData(j,3))
    yC = sqrt(AllData(j,1)**2 + a**2) * sin(AllData(j,2))*sin(AllData(j,3))
    zC = AllData(j,1) * cos(AllData(j,2))
   
    write(20, *) xC, yC, zC
    enddo
    close(20)










end program main
