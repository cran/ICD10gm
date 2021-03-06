#' Historize a list of ICD codes to cover the specified years
#'
#' The function `icd_history` takes the result of `icd_expand`,
#' specified for a particular year, and returns a data.frame
#' containing all corresponding codes for the specified years
#' (from 2003). To do this, it applies the ICD-10-GM transition
#' tables to map codes between successive ICD-10-GM versions.
#' Only automatic transitions are followed.
#'
#' @param icd_expand A data.frame (e.g. as generated by the function icd_expand)
#' @param years Years to historize (e.g. 2005:2014)
#' @param custom_transitions (Optional) A data.frame containing custom transitions to complement the official transitions provided by `icd_meta_transition`.
#' @return data.frame with columns YEAR, ICD_CODE, ICD_COMPRESSED, ICD_LABEL and, if specified, DIAG_GROUP
#' #' @seealso [icd_expand()] to generate the necessary input
#' @examples
#' # Between 2018 and 2019, causalgia (G56.4) was reclassified
#' # under G90 as a complex regional pain syndrome
#' icd_meta <- data.frame(ICD = "G56.4", ICD_LABEL = "Causalgia")
#' icd_meta_expanded <- icd_expand(icd_meta, year = 2018, col_meta = "ICD_LABEL")
#' icd_history(icd_meta_expanded, years = 2018:2019)
#' @export
icd_history <- function(icd_expand, years, custom_transitions = NULL){
  cols_transition <- c("year_from", "year_to",
                       "icd_from", "icd_to",
                       "automatic_forward", "automatic_backward")
  icd_hist <- ICD10gm::icd_meta_transition[, cols_transition]

  if (!is.null(custom_transitions) && is.data.frame(custom_transitions)) {
    if (!all(cols_transition %in% names(custom_transitions))) {
      stop(paste("custom_transitions must be a data.frame with columns:",
                 paste(cols_transition, collapse = ", ")))
    }

    # Convert factors to character, to avoid annoying warnings
    # (https://stackoverflow.com/questions/2851015/convert-data-frame-columns-from-factors-to-characters)
    custom_transitions[] <- lapply(custom_transitions,
                                   function(x) {
                                     if (is.factor(x))
                                       as.character(x)
                                     else
                                       x
                                    })
    # Now merge DIMDI transitions with custom transitions
    icd_hist <- dplyr::bind_rows(icd_hist, custom_transitions)
  }

	stopifnot(
						all(grepl("^\\d{4}$", years)),
						all(years %in% unique(c(icd_hist$year_to, icd_hist$year_from))),
						all(c("year", "icd_code") %in% names(icd_expand))
						)

	# Identify and store combination of icd_spec and col_meta
	# col_meta contains any columns not returned by icd_expand() itself
	col_meta <- names(icd_expand)[
	  !(names(icd_expand) %in% c("icd_spec", "year", "icd3", "icd_code",
	                             "icd_normcode", "icd_sub", "label"))
	  ]
	spec_meta <- unique(icd_expand[, c("icd_spec", col_meta), drop = FALSE])


  # Make sure icd_expand is not a tibble, otherwise merge might return error
  # (shoud be fixed in current tibble versions, but better safe than sorry)
	# Remote metadata so that codes are identified only through year and icd_code
  icd_expand <- as.data.frame(icd_expand)[, c("icd_spec", "year", "icd_code")]

	icd_back <- function(icd_expand, icd_hist){
		out <- merge(
		  icd_expand,
		  icd_hist[icd_hist$automatic_backward == "A", ],
			by.x = c("year", "icd_code"),
			by.y = c("year_to", "icd_to"),
			all.x = FALSE, all.y = FALSE)

		# Replace YEAR with year_from
		# and ICD_CODE with icd_from
		out <- out[, which(!(names(out) %in% c("year", "icd_code")))]
		names(out)[which(names(out) == "year_from")] <- "year"
		names(out)[which(names(out) == "icd_from")] <- "icd_code"
		out <- out[, names(icd_expand)]
		return(unique(out))
	}

	icd_forward <- function(icd_expand, icd_hist){
		out <- merge(icd_expand,
		             icd_hist[icd_hist$automatic_forward == "A", ],
					by.x = c("year", "icd_code"),
					by.y = c("year_from", "icd_from"),
					all.x = FALSE, all.y = FALSE)

		# Replace YEAR with year_to
		# and ICD_CODE with icd_to
		out <- out[, which(!(names(out) %in% c("year", "icd_code")))]
		names(out)[which(names(out) == "year_to")] <- "year"
		names(out)[which(names(out) == "icd_to")] <- "icd_code"
		out <- out[, names(icd_expand)]
		return(unique(out))
	}

	# Determine starting year from input data
	year_init <- icd_expand[1, "year"]

	# Initialise output list
	icd_hist_out <- list()
	icd_hist_out[[as.character(year_init)]] <- icd_expand

	# Historise each year in vector years prior to starting year
	years_back <- years[years < year_init]
	for (y in sort(years_back, decreasing = TRUE)){
		icd_hist_out[[as.character(y)]] <-
			icd_back(icd_hist_out[[as.character(y+1)]],
							 icd_hist)
	}

	# Historise each year in vector years subsequent to starting year
	years_forward <- years[years > year_init]
	for (y in years_forward){
		icd_hist_out[[as.character(y)]] <-
			icd_forward(icd_hist_out[[as.character(y-1)]],
									icd_hist)
	}

	# Return data frame with alternative coding for the ICD
	# (without ".", e.g. for InBA grouper)
	out <- do.call("rbind", icd_hist_out)
	# Add ICD-10 metadata for codes
	out <- merge(out, ICD10gm::icd_meta_codes[, c("year", "icd_code", "icd_normcode", "icd_sub", "icd3", "label")],
	             by = c("year", "icd_code"))
	# Add custom metadata (col_meta)
	out <- merge(out, spec_meta, by = "icd_spec")
	# Clean and return
	out <- out[!is.na(out$year), ]
	out$year <- as.integer(out$year)
	return(tibble::as_tibble(out[, c("icd_spec", col_meta, "year", "icd3", "icd_code",
	               "icd_normcode", "icd_sub", "label")]))
}
