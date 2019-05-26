# Script for simplifying the use of UniProt.ws to retrieve protein data

## Accessions 
## Short protein names 
## Full protein names 
## Gene names 
## Interactions
## GO Functions
## GO Cellular location

# to be merged into parent_DF by cbind() or returned as is

# TO DO: 
## Add library checks
## Add optional vector output instead of df

# Add checks for libraries: 
# UniProt.ws
# dplyr
# data.table
# glue (possibly not necessary)

#library(UniProt.ws)
#library(dplyr)
#library(data.table)

request_choices <- list(
  shortname = "ENTRY-NAME",           #Fungerer! Kortnavn. Må parses og fjerne trailing "_HUMAN" (Benytt gsub)
  longname = "PROTEIN-NAMES",         #Fungerer! Må parses: Klammer [ ] og innhold må fjernes, Ord farentes til separat kolonne "Full_name" og ord inne i parentes til separat kolonne "short_name"
  genecards = "GENECARDS",            #Kortnavn
  genename = "GENES",

  id = "ID",                          #OK, Uniprot accession
  interactor = "INTERACTOR",          #Interessant! Fungerer fint, med semikolon-separert resultat i celle "interactor"
  go = c("GO", "GO-ID"),              #kun GO:ID accession, GO fungerer godt. Skal det benyttes må kolonnene parses videre
  loc = "SUBCELLULAR-LOCATIONS",
  funct = "FUNCTION"
)

# If accessions are in df, ref the column of accessions as follows:  
#                 acc_vector = "uniprot_acc", original = new_source
# If accessions is in vector, ref vector with quotations


retrieve_UP <- function(original = NULL,
                        acc_vector = NULL, 
                        append = FALSE,
                        request = "ENTRY-NAME",
                        kt = "UNIPROTKB") {
  
  if(exists("UP_data") == FALSE) {
    UP_data <- UniProt.ws::UniProt.ws(taxId=9606)  # Download Uniprot data if no local copy
  }
  
  # Check for input errors:
  if (is.null(acc_vector)){
    stop("Error: Please supply input data in acc_vector-argument")
  } else if (kt != "UNIPROTKB"){
    stop("Error: Only 'UNIPROT' Accession input supported (yet)")
  
  # If dataframe is supplied and append is wanted
  } else if (is.data.frame(original) == TRUE && append == TRUE) {
    UniProt.ws::select(UP_data,
                       kt = "UNIPROTKB",
                       columns = request,
                       keys = eval(original[[acc_vector]])
                       ) %>% 
      select(-"UNIPROTKB") %>% 
      {cbind(original, .)} %>% 
      return(.)
    
    # If dataframe is not supplied or append is unwanted: 
    #     Use vector input, return simple df with results
  } else {
    UniProt.ws::select(UP_data,
                       kt = "UNIPROTKB",
                       columns = request,
                       # If dataframe is supplied, ue df$column format
                       if(is.data.frame(original) == TRUE) {keys = original[[acc_vector]]
                       # If vector is supplied sans df, specify only the vector
                       } else {keys = acc_vector}  
                       ) %>% 
    {ifelse(is.data.frame(original) == TRUE, return(.), return(.[[2]]))}
    
  }
}



# Testing:
# df <-     data.frame(uniprot_acc = c("P01189", "O15240", "P28222"), "hello")
# vector <- as.character(df$uniprot_acc)
# request <- c("ENTRY-NAME", "PROTEIN-NAMES")
# 
# View(
#   retrieve_UP(acc_vector = "uniprot_acc", original = df, append = TRUE, request = request))
# 
# View(
#   retrieve_UP(acc_vector = "uniprot_acc", original = df, append = FALSE, request = request))
# 
# retrieve_UP()
# retrieve_UP(acc_vector = vector)
