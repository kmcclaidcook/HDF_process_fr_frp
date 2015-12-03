FUNCTION MODIS_PLANCK, TEMP, BAND, UNITS, NAME=NAME

;+
; DESCRIPTION:
;    Compute Planck radiance for a MODIS infrared band on
;    Terra or Aqua.
;
;    Spectral responses for each IR detector were obtained from MCST:
;    ftp://mcstftp.gsfc.nasa.gov/pub/permanent/MCST in
;    directories PFM_L1B_LUT_4-30-99 and FM1_RSR_LUT_07-10-01.
;
;    An average spectral response for each infrared band was
;    computed. The band-averaged spectral response data were used
;    to compute the effective central wavenumbers and temperature
;    correction coefficients included in this module.
;
; USAGE:
;    RESULT = MODIS_PLANCK(TEMP, BAND, UNITS)
;
; INPUT PARAMETERS:
;    TEMP          Brightness temperature (Kelvin)
;    BAND          MODIS IR band number (20-25, 27-36)
;    UNITS         Flag defining radiance units
;                  0 => milliWatts per square meter per steradian per
;                       inverse centimeter
;                  1 => Watts per square meter per steradian per micron
;
; OPTIONAL KEYWORDS:
;    NAME          Name of the satellite ('TERRA' or 'AQUA')
;
; OUTPUT PARAMETERS:
;    MODIS_PLANCK  Planck radiance (units are determined by UNITS)
;
; MODIFICATION HISTORY:
; Liam.Gumley@ssec.wisc.edu
; http://cimss.ssec.wisc.edu/~gumley
; $Id: modis_planck.pro,v 1.4 2002/09/03 19:08:45 gumley Exp $
;
; Copyright (C) 1999, 2000 Liam E. Gumley
;
; This program is free software; you can redistribute it and/or
; modify it under the terms of the GNU General Public License
; as published by the Free Software Foundation; either version 2
; of the License, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
;-

rcs_id = '$Id: modis_planck.pro,v 1.4 2002/09/03 19:08:45 gumley Exp $'

;- Check input parameters
if (n_params() ne 3) then $
  message, 'Usage: RESULT = MODIS_PLANCK(TEMP, BAND, UNITS)'
if (n_elements(temp) eq 0) then $
  message, 'Argument TEMP is undefined'
if (n_elements(band) eq 0) then $
  message, 'Argument BAND is undefined'
if (n_elements(units) eq 0) then $
  message, 'Argument UNITS is undefined'
if (band lt 20) or (band gt 36) or (band eq 26) then $
  message, 'Argument BAND must be in the range [20-25, 27-36]
if (n_elements(name) eq 0) then begin
  message, 'Satellite name not set; assuming TERRA', /continue
  name = 'TERRA'
endif
if (strupcase(name) ne 'TERRA') and (strupcase(name) ne 'AQUA') then $
  message, 'Satellite name must be TERRA or AQUA'

;-----------------------------------------------------------------------
;     BAND-AVERAGED MODIS SPECTRAL RESPONSE FUNCTIONS FOR TERRA
;     (LG 08-JAN-2002)
;     TEMPERATURE RANGE FOR FIT WAS  180.00 K TO  320.00 K
;
;     BANDS
;      20,  21,  22,  23,
;      24,  25,  27,  28,
;      29,  30,  31,  32,
;      33,  34,  35,  36,

;- Effective central wavenumbers (inverse centimeters)
cwn_terra = [$
  2.641775d+03, 2.505277d+03, 2.518028d+03, 2.465428d+03, $
  2.235815d+03, 2.200346d+03, 1.477967d+03, 1.362737d+03, $
  1.173190d+03, 1.027715d+03, 9.080884d+02, 8.315399d+02, $
  7.483394d+02, 7.308963d+02, 7.188681d+02, 7.045367d+02]

;- Temperature correction slopes (no units)
tcs_terra = [$
  9.993411d-01, 9.998646d-01, 9.998585d-01, 9.998682d-01, $
  9.998820d-01, 9.998845d-01, 9.994878d-01, 9.994918d-01, $
  9.995496d-01, 9.997399d-01, 9.995607d-01, 9.997256d-01, $
  9.999161d-01, 9.999167d-01, 9.999192d-01, 9.999282d-01]

;- Temperature correction intercepts (Kelvin)
tci_terra = [$
  4.770522d-01, 9.264053d-02, 9.756834d-02, 8.928794d-02, $
  7.309468d-02, 7.061112d-02, 2.204659d-01, 2.045902d-01, $
  1.599076d-01, 8.249532d-02, 1.302885d-01, 7.181662d-02, $
  1.970605d-02, 1.912743d-02, 1.816222d-02, 1.579983d-02]
;-----------------------------------------------------------------------
;     BAND-AVERAGED MODIS SPECTRAL RESPONSE FUNCTIONS FOR AQUA
;     (LG 08-JAN-2002)
;     TEMPERATURE RANGE FOR FIT WAS  180.00 K TO  320.00 K
;
;     BANDS
;      20,  21,  22,  23,
;      24,  25,  27,  28,
;      29,  30,  31,  32,
;      33,  34,  35,  36,

;- Effective central wavenumbers (inverse centimeters)
cwn_aqua = [$
  2.647409d+03, 2.511760d+03, 2.517908d+03, 2.462442d+03, $
  2.248296d+03, 2.209547d+03, 1.474262d+03, 1.361626d+03, $
  1.169626d+03, 1.028740d+03, 9.076813d+02, 8.308411d+02, $
  7.482978d+02, 7.307766d+02, 7.182094d+02, 7.035007d+02]

;- Temperature correction slopes (no units)
tcs_aqua = [$
  9.993363d-01, 9.998626d-01, 9.998627d-01, 9.998707d-01, $
  9.998737d-01, 9.998770d-01, 9.995694d-01, 9.994867d-01, $
  9.995270d-01, 9.997382d-01, 9.995270d-01, 9.997271d-01, $
  9.999173d-01, 9.999070d-01, 9.999198d-01, 9.999233d-01]

;- Temperature correction intercepts (Kelvin)
tci_aqua = [$
  4.818401d-01, 9.426663d-02, 9.458604d-02, 8.736613d-02, $
  7.873285d-02, 7.550804d-02, 1.848769d-01, 2.064384d-01, $
  1.674982d-01, 8.304364d-02, 1.343433d-01, 7.135051d-02, $
  1.948513d-02, 2.131043d-02, 1.804156d-02, 1.683156d-02]
;-----------------------------------------------------------------------

;- Get index into coefficient arrays
index = (band le 25) ? (band - 20) : (band - 21)

;- Get the coefficients for Terra or Aqua
case strupcase(name) of
  'TERRA' : begin
    cwn = cwn_terra[index]
    tcs = tcs_terra[index]
    tci = tci_terra[index]
  end
  'AQUA' : begin
    cwn = cwn_aqua[index]
    tcs = tcs_aqua[index]
    tci = tci_aqua[index]
  end
endcase

;- Compute Planck radiance

if (units eq 1) then begin

  ;- Radiance units are
  ;- Watts per square meter per steradian per micron
  result = planck_m(1.0d+4 / cwn, temp * tcs + tci)

endif else begin

  ;- Radiance units are
  ;- milliWatts per square meter per steradian per wavenumber
  result = planc_m(cwn, temp * tcs + tci)

endelse

;- Return result to caller
return, result

END