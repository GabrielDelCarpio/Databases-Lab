*******************
* Pontificia Universidad Católica del Perú   
* LABORATORIO DE CÓMPUTO: MANEJO DE BASES DE DATOS          
* Profesor: Diego Quispe Ortogorin
* Evaluación final - Grupo 10
*******************

* Limpieza de memoria
clear all

* Establecimiento de directorio
global final "/Users/gabriel/Documents/ARCHIVOS CATO/2023-1/Laboratorio de Bases de Datos/EXAMEN FINAL/DATOS"

use "CPV2017_POB", clear

***** Aqui realizamos grafico de barras de seguro de salud segun sexo y edad ******

*Gráfico "Afiliados a algún tipo de seguro de salud según el sexo"

gen mujer = c5_p2 == 2
label define lmujer 0 "Hombre" 1 "Mujer"
label values mujer lmujer


graph bar c5_p8_1 c5_p8_2 c5_p8_3 c5_p8_4 c5_p8_5 c5_p8_6, over(mujer) ytitle("Porcentaje") title("Afiliados a algún tipo de seguro de salud según el sexo") blabel (total, format (%9.3f) size (small)) yscale(range(0 1)) ylabel(0(0.25)1) ///
legend (label(1 "SIS") label(2 "EsSalud") label(3 "Seguro de fuerzas armadas o policiales") label(4 "Seguro Privado") label(5 "Otro seguro") label(6 "No tiene seguro"))
graph export "$final/gbarcolor_afil.png", replace

*Gráfico de los tipos de seguros a los que se encuentran afiliados la población peruana

graph pie c5_p8_1 c5_p8_2 c5_p8_3 c5_p8_4 c5_p8_5 c5_p8_6 , plabel(_all percent , color(white) format(%9.1f) size(small)) title ("Afiliados a algún tipo de seguro") ///
legend (label(1 "SIS") label(2 "EsSalud") label(3 "Seguro de fuerzas armadas o policiales") label(4 "Seguro Privado") label(5 "Otro seguro") label(6 "No tiene seguro"))
graph export "$final/gbarcolor_tipafil.png", replace

*Gráfico "Afiliados a algún tipo de seguro de salud según la edad"

gen sis = c5_p8_1 == 1
gen essalud = c5_p8_2 == 1
gen fuerzas_armadas = c5_p8_3 == 1
gen privado = c5_p8_4 == 1
gen otro= c5_p8_5 == 1

egen afiliados_seguro = rowtotal (sis essalud fuerzas_armadas privado otro)
replace afiliados_seguro = 1 if afiliados_seguro >=1
label define lafiliados_seguro 0 "No tiene seguro" 1 "Tiene seguro"
label values afiliados_seguro lafiliados_seguro

gen c1 = 1 if c5_p4_1 <= 1 
replace c1 = 0 if c5_p4_1 > 1

gen c14 = 1 if c5_p4_1 <= 14 & c5_p4_1 > 1 
replace c14 = 0 if c5_p4_1 > 14 
replace c14 = 0 if c5_p4_1 <= 1

gen c29 = 1 if c5_p4_1 <= 29  & c5_p4_1 > 14 
replace c29 = 0 if c5_p4_1 > 29
replace c29 = 0 if c5_p4_1 <= 14

gen c44 = 1 if c5_p4_1 <= 44  & c5_p4_1 > 29 
replace c44 = 0 if c5_p4_1 > 44
replace c44 = 0 if c5_p4_1 <=29 

gen c64 = 1 if c5_p4_1 <= 64  & c5_p4_1 > 44
replace c64 = 0 if c5_p4_1 > 64
replace c64 = 0 if c5_p4_1 <= 44

gen c115 = 1 if c5_p4_1 <= 115  & c5_p4_1 > 64 
replace c115 = 0 if c5_p4_1 <= 64


graph bar c1 c14 c29 c44 c64 c115, over(afiliados_seguro) ytitle("Porcentaje") title("Afiliados a algún tipo de seguro de salud según grupos de edad") blabel (total, format (%9.2f) size (small)) ///
legend (label(1 "Menores de 1 año") label(2 "De 1 a 14 años") label(3 "De 15 a 29 años") label(4 "De 30 a 44 años") label(5 "de 45 a 64 años") label(6 "De 65 a más años"))
graph export "$final/gbarcolor_afil_edad.png", replace

*Gráfico "Afiliados a algún tipo de seguro de salud según el área de residencia" 

graph bar c5_p8_1 c5_p8_2 c5_p8_3 c5_p8_4 c5_p8_5 c5_p8_6, over(encarea) ytitle("Porcentaje") title("Afiliados a algún tipo de seguro de salud según aréa urbana o rural") blabel (total, format (%9.3f) size (small)) yscale(range(0 1)) ylabel(0(0.25)1) ///
legend (label(1 "SIS") label(2 "EsSalud") label(3 "Seguro de fuerzas armadas o policiales") label(4 "Seguro Privado") label(5 "Otro seguro") label(6 "No tiene seguro"))
graph export "$final/gbarcolor_afil_area.png", replace

****** Realizamos tabulacion estadistica de nivel educativo segun area urbana o ///
****** rural afiliados a algun tipo de seguro **********

**** creamos la varible nivel educativo alcanzado***
tab c5_p13_niv, nol
recode c5_p13_niv (1/1=1 "Sin nivel eduactivo") (2/3=2 "Primaria completa") (4/5=3 "Secundaria y basica especial") (6/7=4 "Superior no universitaria") (8/9=5 "Superior Universitaria") (10/10=6 "Maestria/Doctorado"), gen (Nivel_educ)
label var Nivel_educ "Nivel educativo alcanzado"

*resultado de la estimacion proporcional incluyendo el diseño muestral*
svyset [pweight= factor_pond], strata(area) psu(hog)

***** realaizamos una tabla bidimensional de Área geográfica y Nivel educativo alcanzado para las personas que cunetan con seguro de salud para el aaño 2017****
svy:tab area Nivel_educ if afil_seguro == 1, col format(%9.1f) percent

****** realizamos una tabla bidimensional de Estado Civl y Sexo para las personas que cuentan con seguro de salud para el año 2017******
svy:tab c5_p24 c5_p2 if afil_seguro == 1, col format(%9.1f) percent

*Ahora realizamos los graficos para los mapas departamentales, provinciales y distritales
cls
clear all

// Utilizamos solo las variables de interes para el estudio
use "$final/CPV2017_POB.dta", clear

egen afil_seguro = rowtotal(c5_p8_1 - c5_p8_5) 

replace afil_seguro = 1 if afil_seguro == 3
replace afil_seguro = 1 if afil_seguro == 2

label define lafil_seguro 0 "No afiliado a ningun tipo de seguro" 1 "Afiliado a algun tipo de seguro"
label values afil_seguro lafil_seguro 

gen mayores_3 = 1 if c5_p4_1 >= 3
replace mayores_3 = 0 if c5_p4_1 < 3
gen mayores_12 = 1 if c5_p4_1 >= 12
replace mayores_12 = 0 if c5_p4_1 < 12

gen idm_nacer = (c5_p11 == 10) 

keep ccdd ccpp ccdi area encarea viv thogar hog c5_p1 c5_p2 c5_p4_1 factor_pond afil_seguro id_viv_imp_f id_pob_imp_f id_hog_imp_f mayores_3 mayores_12 c5_p24 idm_nacer ubigeo2019

// ordenamos la base 
egen afiliados = mean(afil_seguro), by(ccdd ccpp ccdi)
rename ubigeo2019 ubigeo

save "$final/Var_interes", replace

******* Aqui armamos los merge y mapas para que se puedan mostrar las variables ///
******* de cantidad de afiliados a algun tipo de seguro de salud, afiliados ///
******* mayores de 3 años, mayores de 12 años y considerando el idioma al nacer 

**sPOR DEPARTAMENTO****

*** use "$final/Var_interes", clear
collapse (mean) afil_seguro mayores_3 mayores_12 idm_nacer, by(ccdd)
gen OBJECTID = real(ccdd)
save "$final/dept_mapas.dta", replace
/// hacemos merge con los archivos .shp convertidos anteriormente a dta
use perudpto, clear
merge 1:1 OBJECTID using "$final/dept_mapas.dta"
encode DEPARTAMEN, gen(dpto)

***hacemos el grafico de mapas 
//// afiliados a por lo menos un seguro 
format %7.3g afil_seguro
spmap afil_seguro using corrdpto.dta, id(id)  fcolor(Purples) clnumber(4) ///
title ("Afiliados a por lo menos un seguro de salud" "con vivienda particular") subtitle("Departamentos") note("Fuente: INEI" "Elaboracion propia") 
graph export "$final/g_afil_dept.png", replace

/// afiliados mayores de 3 años
format %7.3g mayores_3
spmap mayores_3 using corrdpto.dta, id(id)  fcolor(Blues) clnumber(4) ///
title ("Mayores de 3 años afiliados a seguro de" "salud") subtitle("Departamentos") note("Fuente: INEI" "Elaboracion propia")
graph export "$final/g_mayores3_dept.png", replace

/// afiliados mayores a 12 años
format %7.3g mayores_12
spmap mayores_12 using corrdpto.dta, id(id)  fcolor(Greens) clnumber(4) ///
title ("Mayores de 12 años afiliados a seguro de" "salud") subtitle("Departamentos") note("Fuente: INEI" "Elaboracion propia")
graph export "$final/g_mayores12_dept.png", replace

/// afiliados con idioma al nacer castellano, el resto de porcentaje son otros idiomas
format %7.3g idm_nacer 
spmap idm_nacer using corrdpto.dta, id(id)  fcolor(Oranges) clnumber(4) /// 
title ("Afiliados a seguro de salud cuyo idioma al" "nacer fue el castellano") subtitle("Departamentos") note("Fuente: INEI" "Elaboracion propia")
graph export "$final/g_idnacer_dept.png", replace 

**s* POR PROVINCIA ****

use "$final/Var_interes", clear
collapse (mean) afil_seguro mayores_3 mayores_12 idm_nacer, by(ccdd ccpp)
egen OBJECTID = seq(), from(1) to(196)
save "$final/prov_mapas.dta", replace

use peruprov.dta, clear
merge 1:1 OBJECTID using "$final/prov_mapas.dta"
encode PROVINCIA, gen(prov)
*** order prov

format %7.3g afil_seguro
spmap afil_seguro using corrprov.dta, id(id) fcolor(Purples) clnumber(4) ///
title ("Afiliados a por lo menos un seguro de salud" "con vivienda particular") subtitle("Provincial") note("Fuente: INEI" "Elaboracion propia")
graph export "$final/g_afil_prov.png", replace

format %7.3g mayores_3
spmap mayores_3 using corrprov.dta, id(id) fcolor(Blues) clnumber(4) ///
title ("Mayores de 3 años afiliados a seguro de" "salud") subtitle("Provincial") note("Fuente: INEI" "Elaboracion propia")
graph export "$final/g_mayores3_prov.png", replace

format %7.3g mayores_12
spmap mayores_12 using corrprov.dta, id(id)  fcolor(Greens) clnumber(4) ///
title ("Mayores de 12 años afiliados a seguro de" "salud") subtitle("Provincial") note("Fuente: INEI" "Elaboracion propia")
graph export "$final/g_mayores12_prov.png", replace

format %7.3g idm_nacer 
spmap idm_nacer using corrprov.dta, id(id)  fcolor(Oranges) clnumber(4) /// 
title ("Afiliados a seguro de salud cuyo idioma al" "nacer fue el castellano") subtitle("Provincial") note("Fuente: INEI" "Elaboracion propia")
graph export "$final/g_idnacer_prov.png", replace 

*** POR DISTRITOS ***

use "$final/Var_interes", clear
collapse (mean) afil_seguro mayores_3 mayores_12 idm_nacer, by(ccdd ccpp ccdi)
egen OBJECTID = seq(), from(1) to(1874)
save "$final/dist_mapas.dta", replace

use perudist.dta, clear
merge 1:1 OBJECTID using "$final/dist_mapas.dta", keep(match) 
encode DISTRITO, gen(dist)
***order dist

format %7.3g afil_seguro
spmap afil_seguro using coordist.dta, id(id) fcolor(Purples) clnumber(5) ///
title ("Afiliados a por lo menos un seguro de salud" "con vivienda particular") subtitle("Distrital") note("Fuente: INEI" "Elaboracion propia")
graph export "$final/g_afil_dist.png", replace

format %7.3g mayores_3
spmap mayores_3 using coordist.dta, id(id)  fcolor(Blues) clnumber(5) ///
title ("Mayores de 3 años afiliados a seguro de" "salud") subtitle("Distrital") note("Fuente: INEI" "Elaboracion propia")
graph export "$final/g_mayores3_dist.png", replace

format %7.3g mayores_12
spmap mayores_12 using coordist.dta, id(id)  fcolor(Greens) /// 
clnumber(5) title ("Mayores de 12 años afiliados a seguro de" "salud") subtitle("Distrital") note("Fuente: INEI" "Elaboracion propia")
graph export "$final/g_mayores12_dist.png", replace

format %7.3g idm_nacer 
spmap idm_nacer using coordist.dta, id(id)  fcolor(Oranges) clnumber(5) title ("Afiliados a seguro de salud cuyo idioma al" "nacer fue el castellano") subtitle("Distrital") note("Fuente: INEI" "Elaboracion propia")
graph export "$final/g_idnacer_dist.png", replace 

***Armamos graficos de barras departamental 

use "$final/perudpto.dta", clear
merge 1:1 OBJECTID using "$final/dept_mapas.dta"
encode DEPARTAMEN, gen(dpto)

gen dpto1 = lower(DEPARTAMEN)
replace dpto1 = upper(substr(dpto1, 1, 1)) + substr(dpto1, 2, .)

graph bar afil_seguro, over (dpto1, label(angle(vertical))) /// 
blabel(total , format(%7.2f) size(small)) ytitle("Porcentaje") title ("Afiliados a algún tipo de seguro")subtitle("Departamentos") caption("Fuente: INEI" "Elaboracion propia")
graph export "$final/gbar_afil.png", replace

// Ahora lo haremos en base a las relaciones con el jefe del hogar, sexo y estado civil, tambien mayores de 50 años

use "$final/Var_interes", clear
gen par_jefe_h = (c5_p1 == 1)
***tabulate par_jefe_h c5_p2
gen jefe_mujer = par_jefe_h == 1 if c5_p2 == 2
replace jefe_mujer = 0 if jefe_mujer ==.
gen jefe_hombre = par_jefe_h == 1 if c5_p2 == 1
replace jefe_hombre = 0 if jefe_hombre ==.

gen jefe_mujer_afil = (afil_seguro == 1) & (jefe_mujer == 1) // aqui definimos mujeres jefes del hogar con seguro de salud
gen jefe_hombre_afil = (afil_seguro ==1) & (jefe_hombre ==1) // hombres jefes del hogar con seguro de salud

/* gen par_espos = (c5_p1 == 2)
gen esposa = par_espos == 1 if c5_p2 == 2
replace esposa = 0 if esposa ==.
gen esposo = par_espos == 1 if c5_p2 == 1
replace esposo = 0 if esposo ==.
gen esposa_afiliado = (afil_seguro ==1 ) & (esposa == 1) /// esposas afiliadas
gen esposo_afiliado = (afil_seguro == 1) & (esposo == 1) /// esposos afiliados
gen par_hijo = (c5_p1 == 3)
gen hija = par_hijo == 1 if c5_p2 == 2
replace hija = 0 if hija==.
gen hijo = par_hijo == 1 if c5_p2 == 1
replace hijo = 0 if hijo==. 
gen hija_afil = (afil_seguro==1) & (hija==1)
gen hijo_afil = (afil_seguro==1) & (hijo==1) */

keep ubigeo c5_p1 c5_p2 c5_p4_1 afil_seguro jefe_mujer_afil jefe_hombre_afil ccdd ccdi ccpp
collapse (mean) jefe_mujer_afil jefe_hombre_afil, by(ccdd)
gen OBJECTID = real(ccdd)

save "$final/parentesco_sexo_afil.dta", replace

// Armamos grafico de barras de personas afiliadas por paretesco y sexo
use perudpto.dta, clear
merge 1:1 OBJECTID using "$final/parentesco_sexo_afil.dta"
gen dpto2 = lower(DEPARTAMEN)
replace dpto2 = upper(substr(dpto2, 1, 1)) + substr(dpto2, 2, .)

///grafico de barras de jefes hombres afiliados
graph bar (mean) jefe_mujer_afil, over (dpto2, label(angle(vertical))). ///
blabel(total , format(%7.2f) size(small)) ytitle("Porcentaje") /// 
title ("Jefes del hogar mujeres afiliadas a algún tipo" "de seguro")subtitle("Departamentos") caption("Fuente: INEI" "Elaboracion propia")
graph export "$final/gbar_paren_sex1.png", replace

/// grafico de barras de jefes mujeres afiliadas
graph bar (mean) jefe_hombre_afil, over (dpto2, label(angle(vertical))) ///
blabel(total, format(%7.2f) size(small)) ytitle("Porcentaje") /// 
title ("Jefes del hogar hombres afiliados a algún tipo" "de seguro")subtitle("Departamentos") caption("Fuente: INEI" "Elaboracion propia")
graph export "$final/gbar_paren_sex2.png", replace

****** Ahora realizamos tabulacion estadistica de nivel educativo segun area ///
****** urbano o rural afiliados a algun tipo de seguro **********

**** creamos la varible nivel educativo alcanzado***
use "$final/CPV2017_POB.dta", clear
tab c5_p13_niv, nol
recode c5_p13_niv (1/1=1 "Sin nivel eduactivo") (2/3=2 "Primaria completa") (4/5=3 "Secundaria y basica especial") (6/7=4 "Superior no universitaria") (8/9=5 "Superior Universitaria") (10/10=6 "Maestria/Doctorado"), gen (Nivel_educ)
label var Nivel_educ "Nivel educativo alcanzado"

*resultado de la estimacion proporcional incluyendo el diseño muestral*
svyset [pweight= factor_pond], strata(area) psu(hog)

***** realaizamos una tabla bidimensional de Área geográfica y Nivel educativo alcanzado para las personas que cunetan con seguro de salud para el aaño 2017****
svy:tab area Nivel_educ if afil_seguro == 1, col format(%9.1f) percent

****** realizamos una tabla bidimensional de Estado Civl y Sexo para las personas que cuentan con seguro de salud para el año 2017******
svy:tab c5_p24 c5_p2 if afil_seguro == 1, col format(%9.1f) percent

