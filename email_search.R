library(RDCOMClient)

##Set up Outlook application
outlook_app <- COMCreate("Outlook.Application")

##Create email search and save function
save_attachments <- function(search_string, file_type, folder){
  
  ##Search in CM Analytics inbox for email subjects containing given string
  search <- outlook_app$AdvancedSearch(
    "'\\CM Analytics\\Inbox\\000 COVID-19\\transport modes\\new'",
    paste0("urn:schemas:httpmail:subject LIKE '%", search_string, "%'")
  )
  
  ##Sleep to allow search to run; this happens slowly in the background!
  Sys.sleep(5)
  
  #Count number of emails returned
  search$Results()$Count()
  
  ##Save all returned emails into a list
  results <- search$Results()
  emails <- list()
  
  for(i in 1:results$Count()){  
    emails <- append(emails, results$Item(i))
  }
  
  ##Return a message with number of emails found
  message(paste(length(emails), "relevant emails found"))
  
  ##Pull attachments from all emails
  for(i in 1:length(emails)){
    attachment_names <- c()
    email <- emails[[i]]
    for(j in 1:email$Attachments()$Count()){
      attachment_names <- c(attachment_names,
                            email$Attachments(j)$DisplayName())
    }
    
    
    ##Keep only attachments of interest
    attachments_to_keep <- grep(file_type, attachment_names, fixed = TRUE)
    
    ##Return number of relevant attachments per email
    message(paste("Email", i, length(attachments_to_keep), "relevant attachments found"))
    
    ##Stop if length is zero
    if(length(attachments_to_keep != 0)){
      
      for(i in attachments_to_keep){
        ##Create a filename for the attachment of interest
        filename <- paste(normalizePath(folder), 
                          attachment_names[i], sep = "\\")
        
        #Save the docx attachment to specified folder
        email$Attachments(i)$SaveAsFile(filename)
      }
    }
  }
}
##Save BTP attachments
save_attachments(search_string = "BTP", 
                 file_type = "docx", 
                 folder = "G:/AFP/IHACAll/IHAC/015 DDU/005 Covid reporting/0001 R Projects/transport_modes_table/Data/Face coverings/BTP")

##Save YOYallmodes file
save_attachments(search_string = "Passenger Demand Report", 
                 file_type = "xlsx", 
                 folder = "G:/AFP/IHACAll/IHAC/015 DDU/005 Covid reporting/0001 R Projects/transport_modes_table/Data/TfL")

##Save absence dashboard file
save_attachments(search_string = "Absence Dashboard", 
                 file_type = "pptx", 
                 folder = "G:/AFP/IHACAll/IHAC/015 DDU/005 Covid reporting/0001 R Projects/transport_modes_table/Data/Staff absence")

##Save TfL Face Covering File
save_attachments(search_string = "TfL COVID-19 update report", 
                 file_type = "docx", 
                 folder = "G:/AFP/IHACAll/IHAC/015 DDU/005 Covid reporting/0001 R Projects/transport_modes_table/Data/Face coverings/TfL")
