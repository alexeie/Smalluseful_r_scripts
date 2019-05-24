# Script for returning DF of Accessions / Short protein names / Full protein names / Gene names / Interactions
# to be merged into parent_DF by cbind()

# Add checks for libraries: 
# UniProt.ws
# dplyr
# data.table
# glue

library(UniProt.ws)
library(dplyr)
library(data.table)

### uniprot.ws:

# columns,keytypes,keys and select.

col_shortname <- "ENTRY-NAME"           #Fungerer! Kortnavn. Må parses ved å fjerne trailing "_HUMAN" (Benytt gsub)
col_longname <- "PROTEIN-NAMES"         #Fungerer! Må parses: Klammer [ ] og innhold må fjernes, Ord før parentes til separat kolonne "Full_name" og ord inne i parentes til separat kolonne "short_name"
col_genecards <- "GENECARDS"            #Kortnavn
col_genes <- "GENES"

col_go <-   "GO", "GO-ID"               #kun GO:ID accession, GO fungerer godt. Skal det benyttes må kolonnene parses videre
col_id <-   "ID"                        #OK, Uniprot accession
col_interactor <- "INTERACTOR"          #Interessant! Fungerer fint, med semikolon-separert resultat i celle "interactor"
col_loc <- "SUBCELLULAR-LOCATIONS"      # Fungerer bra!
col_funct <-"FUNCTION"                  # Fungerer bra!

if(exists("UP_obj") == FALSE) UP_obj <- UniProt.ws::UniProt.ws(taxId=9606)









# If accessions are in df, ref df as follows:  acc_vector = "uniprot_acc", original = new_source
# If accessions is in vector, ref vector as follows: new_source$uniprot_acc




retrieve_UP <- function(original = NULL, 
                        append = FALSE,
                        acc_vector = NULL, 
                        request = col_shortname,
                        kt = "UNIPROTKB"
                        ) {
    
    #if(acc_vector == NULL) stop("Error: Please supply input data in acc_vector - argument")
    #if(kt != "UNIPROTKB") stop("Error: Only UNIPROT Accession input supported yet")
    
    if(is.null(original) == FALSE && append == TRUE) {           # If dataframe is supplied and append is wanted
        UniProt.ws::select(UP_obj, 
                            keys = eval(original[[acc_vector]]), 
                            columns = request, 
                            kt = "UNIPROTKB") %>% 
            select(-"UNIPROTKB") %>% 
            {cbind(original, .)} %>% 
            return(.)
        
    } 
      else                                              # Easier function to not append data
          UniProt.ws::select(UP_obj, 
                             if(is.null(original) == FALSE) {keys = original[[acc_vector]]}
                             else {keys = acc_vector}  # This variable differs if dataframe is supplied or not
                             ,columns = request, 
                             kt = "UNIPROTKB") %>% 
            return(.)
}



# df <-       retrieve_UP(acc_vector = "uniprot_acc", original = new_source)
# vector <-   retrieve_UP(acc_vector = acc)







































#  res <- UniProt.ws::select(UP_obj, 
#                           keys = acc_vector, 
#                           columns = request, 
#                           kt = "UNIPROTKB")  
# 
#     
#     
#     
# res2 <- retrieve_UPdata(DF$uniprot_acc[1:5], c(col_shortname,col_genes,col_funct))
# 
# 
# # kt <- "UNIPROTKB"
# keys <- c(source$uniprot_acc[1:50])
# res <- UniProt.ws::select(UP_obj, keys, columns, kt)
# # res[1,c(2,3)]
# head(res,1)
# # View(res)
# 
# 
# 
# 
# 
# grepl("data", glue_collapse(class(source)))

