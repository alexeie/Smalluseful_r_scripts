# Script for simplifying the use of UniProt.ws to retrieve protein data

## Accessions 
## Short protein names 
## Full protein names 
## Gene names 
## Interactions
## GO Functions
## GO Cellular location
# to be merged into parent_DF by cbind() or returned as is

# TODO: parse acc_vector so both "" input and input without quotes is accepted

library(UniProt.ws)
library(dplyr)
library(magrittr)

retrieve_UP_req_alternatives <- list(
    shortname = "ENTRY-NAME",           #Fungerer! Kortnavn. Må parses og fjerne trailing "_HUMAN" (Benytt gsub)
    longname = "PROTEIN-NAMES",         #Fungerer! Må parses: Klammer [ ] og innhold må fjernes, Ord farentes til separat kolonne "Full_name" og ord inne i parentes til separat kolonne "short_name"
    genecards = "GENECARDS",            #Kortnavn
    genename = "GENES",
    geneID = "ENSEMBL",                 #Ex: "ENSG00000106236" "ENSG00000104826" "ENSG00000259384"
    id = "ID",                          #OK, Uniprot accession
    interactor = "INTERACTOR",          #Interessant! Fungerer fint, med semikolon-separert resultat i celle "interactor"
    go = c("GO", "GO-ID"),              #kun GO:ID accession, GO fungerer godt. Skal det benyttes må kolonnene parses videre
    loc = "SUBCELLULAR-LOCATIONS",
    funct = "FUNCTION"
)

# Be aware that conversions from protein to genes are ok, but back again is likely to result in more than one protein per gene.

# If accessions are in df, ref the column of accessions as follows:  
#                 acc_vector = "uniprot_acc", original = new_source
# If accessions is in vector, ref vector with quotations


retrieve_UP <- function(original = NULL,
                        acc_vector = NULL, 
                        append = FALSE,
                        request = "ENTRY-NAME", 
                        keytype = "UNIPROTKB") {
    
    # Download Uniprot data if no local copy exists
    if(exists("UP_data") == FALSE) {
        UP_data <- UniProt.ws::UniProt.ws(taxId=9606)
    }
    
    # Check for input errors:
    if (is.null(acc_vector)){
        stop("Error: Please supply input data in acc_vector-argument")
        
        # If dataframe is supplied and append is wanted
    } else if (is.data.frame(original) == TRUE && append == TRUE) {
        UniProt.ws::select(UP_data,
                           keytype = keytype,
                           columns = request,
                           keys = eval(original[[acc_vector]])
        ) %>% 
            dplyr::select(-"UNIPROTKB") %>% 
            {cbind(original, .)} %>% 
            return(.)
        
        # If dataframe is not supplied or append is unwanted: 
        #     Use column or vector input, return df if df is used, or vector if vector is supplied
    } else {
        UniProt.ws::select(UP_data,
                           keytype = keytype,
                           columns = request,
                           # If dataframe is supplied, ue df$column format
                           if(is.data.frame(original) == TRUE) {
                               keys = original[[acc_vector]]
                           # If vector is supplied sans df, specify only the vector
                           } else {
                               keys = acc_vector}  
        ) %>% 
            {ifelse(is.data.frame(original) == TRUE, 
                    return(.), 
                    return(.[[2]]))}
        
    }
}



# Retrieval examples:
# df_source <- data.frame(uniprot_acc = c("P47972", "P01229", "P01241", NA), expressed_in = c("FCA", "SCA"))
# vect_source <- c("P47972", "P01229", "P01241", NA)
# vect_source <- c("P47972", "P01229", "P01241", NULL, NA) # FYI: NULL's will be skipped!
# 
# retrieve_UP(acc_vector = "uniprot_acc", original = df_source, append = FALSE)
# retrieve_UP(acc_vector = "uniprot_acc", original = df_source, append = TRUE)
# retrieve_UP(acc_vector = vect_source)
# retrieve_UP(acc_vector = df_source$uniprot_acc)
# 
# test_w_ensembl <- retrieve_UP(acc_vector = "uniprot_acc", original = df_source, request = "ENSEMBL", append = T)
# View(test_w_ensembl)
# retrieve_UP(acc_vector = "ENSEMBL", original = test_w_ensembl, request = "UNIPROTKB", append = F, keytype = "ENSEMBL")
# retrieve_UP(acc_vector = "ENSEMBL", original = test_w_ensembl, request = "FUNCTION", append = F, keytype = "ENSEMBL")
