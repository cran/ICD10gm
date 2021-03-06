% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{icd_meta_codes}
\alias{icd_meta_codes}
\title{data.frame containing metadata for all ICD-10-GM codes}
\format{
A data.frame containing the following variables:
\describe{
\item{year}{Year of validity (from 2004)}
\item{level}{Level of the hierarchy (3, 4 or 5 digits)}
\item{terminal}{Whether the code is a terminal code (i.e. with no further subcodes) (T: yes; N: no)}
\item{subcode_type}{Whether the subcode is pre- or postcombinated (X: precombinated; S: postcombinated). Precombinated codes are listed directly under the three-digit ICD code, whereas postcombinated codes are lists of possible values for the fourth and fifth digits that are not specific to the particular code (e.g. the group E10-E14 shares a common list of postcombinated fourth and fifth digits)}
\item{chapter_nr}{Chapter number (arabic digits 1-22)}
\item{icd_block_first}{First code in the respective ICD block, can be used to join with the table ICD10gm::icd_meta_blocks}
\item{icd_code}{Full icd code (up to 7 characters) with all symbols except the "dagger" (for aetiological codes that can be combined with an "asterisk" code to denote the manifestation)}
\item{icd_normcode}{The ICD "normcode", consisting of up to 6 characters and without all symbols except the period (e.g. E11.30)}
\item{icd_sub}{Complete ICD code without any symbols or punctuation, consisting of up to 5 characters  (e.g. E1130)}
\item{label}{ICD label for the complete code.}
\item{label_icd3}{ICD label for the three-digit ICD code.}
\item{label_icd4}{ICD label for fourth digit of the ICD code.}
\item{label_icd5}{ICD label for the fifth digit of the ICD code.}
\item{usage_295}{Usage of the code in the ambulatory sector (Paragraph 295 SGB V) (P: primary code; O: only as a "star" code in conjunction with a "dagger" code for aetiology; Z: only an optional "!" code in conjunction with a primary code; V: not to be used for coding)}
\item{usage_301}{Usage of the code in the stationary (hospital) sector (Paragraph 301 SGB V) (P: primary code; O: only as a "star" code in conjunction with a "dagger" code for aetiology; Z: only an optional "!" code in conjunction with a primary code; V: not to be used for coding)}
\item{mort_list1}{Key to join with the WHO mortality list 1}
\item{mort_list2}{Key to join with the WHO mortality list 2}
\item{mort_list3}{Key to join with the WHO mortality list 3}
\item{mort_list4}{Key to join with the WHO mortality list 4}
\item{morb_list}{Key to join with the WHO morbidity list}
\item{gender_specific}{Whether the diagnosis is gender specific (M: male; W: female; 9: Not gender specific)}
\item{gender_error_type}{Type of error implied by the field \code{gender_specific} (9: irrelevant; K: possible error)}
\item{age_min}{Minimum age for which the diagnosis is plausible (T001: from one day; Y005: from five years)}
\item{age_max}{Maximum age for which the diagnosis is plausible (T010: up to 10 days; Y005: up to five years)}
\item{age_error_type}{Type of error resulting from implausible age (9: irrelevant; M: always an error ("Muss-Fehler"); K: possible error ("Kann-Fehler"))}
\item{rare_in_central_europe}{Indicates whether the diagnosis is rare in Central Europe (J: yes; N: no)}
\item{code_with_content}{Indicates whether the code has content associated with it (J: yes; N: no, leads to an error)}
\item{notifiable}{Indicates whether the diagnosis is notifiable in Germany (J: yes; N: no)}
\item{notifiable_lab}{Indicates whether the diagnosis is notifiable for laboratories in Germany (J: yes; N: no)}
}
}
\source{
The source data was downloaded from the official download centre
of the German Institute for Medical Documentation and Information (DIMDI).
See also \url{https://www.dimdi.de/dynamic/en/classifications/icd/icd-10-gm/tabular-list/#metadata}
}
\usage{
icd_meta_codes
}
\description{
DIMDI provide a CSV file with metadata on all valid codes. This table is
read in with only minor modifications to facilitate changes between versions.
}
\details{
This metadata is not suitable for operative coding and does not include all
relevant information concerning the codes. For example, the file contains
neither the inclusion and exclusion notes nor the detailed definitions
(where present, mainly in Chapter V). DIMDI provide additional reference
material for operative coding and detailed research.

The block U00-U49 contains reserved codes that can be allocated quickly for
the documentation of new diseases or epidemiological phenomena. Such usage
is allowed only when mandated by DIMDI. In particular, the codes may not be
utilised on the initiative of other parties, for example, for clinical trials
or contractual purposes. Notable uses of the reserved codes are for the Zika
and COVID-19 viruses. These are included in the DIMDI online documentation,
but not in the download files. They are therefore added manually to this
data set as documented in the \href{https://github.com/edonnachie/ICD10gm/blob/master/data-raw/additions/icd_meta_codes_additions.json}{package source}.

Die Schlüsselnummern U05.0-U05.9 dieser Kategorie sollen ein schnelles Reagieren auf aktuelle epidemiologische Phänomene ermöglichen. Sie dürfen nur zusätzlich benutzt werden, um einen anderenorts klassifizierten Zustand besonders zu kennzeichnen. Die Schlüsselnummern dieser Kategorie dürfen nur über das Deutsche Institut für Medizinische Dokumentation und Information (DIMDI) mit Inhalten belegt werden; eine Anwendung für andere Zwecke ist nicht erlaubt. DIMDI wird den Anwendungszeitraum solcher Schlüsselnummern bei Bedarf bekannt geben.
}
\seealso{
Other ICD-10-GM metadata: 
\code{\link{icd_meta_blocks}},
\code{\link{icd_meta_chapters}},
\code{\link{icd_meta_transition}}
}
\concept{ICD-10-GM metadata}
\keyword{datasets}
