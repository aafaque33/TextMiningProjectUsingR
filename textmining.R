##########################################################################################
#                                  Loading Texts                                         #
##########################################################################################      
#
#     Start by saving your text files in a folder titled:    "texts"
#     This will be the "corpus" (body) of texts you are mining.   
#  
#     Next, choose the type of computer you have...

########################
# check packages install other wise install them
########################
list.of.packages <- c("ggplot2", "tm","SnowballC","wordcloud","fpc","cluster")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages,dependencies=TRUE)

######
# **On a Ubuntu**, save the folder to your *working directory* , "folder Directory"  and use the following code chunk:
######
cname <- file.path(getwd(), "TextMining" ,"texts")   
cname   
dir(cname)   # Use this to check to see that your texts have loaded.   

##########################################################################################
##########################################################################################

##########################################################################################
#                                Start Your Analyses                                     #
##########################################################################################
# **Load the R package for text mining and then load your texts into R.**
library(tm)   
docs <- Corpus(DirSource(cname))   
## Preprocessing      
docs <- tm_map(docs, removePunctuation)   # *Removing punctuation:*    
docs <- tm_map(docs, removeNumbers)      # *Removing numbers:*    
docs <- tm_map(docs, tolower)   # *Converting to lowercase:*    
docs <- tm_map(docs, removeWords, stopwords("english"))   # *Removing "stopwords" 
library(SnowballC)
docs <- tm_map(docs, stemDocument) # *Removing common word endings* (e.g., "ing", "es")   
docs <- tm_map(docs, stripWhitespace) # *Stripping whitespace   
docs <- tm_map(docs, PlainTextDocument)
## *This is the end of the preprocessing stage.*   


### Stage the Data      
dtm <- DocumentTermMatrix(docs)
tdm <- TermDocumentMatrix(docs)

### Explore your data      
freq <- colSums(as.matrix(dtm))
length(freq)   
ord <- order(freq)
m <- as.matrix(dtm)
dim(m)
write.csv(m, file="DocumentTermMatrix.csv")
### FOCUS - on just the interesting stuff...   
#  Start by removing sparse terms:   
dtms <- removeSparseTerms(dtm, 0.4) # This makes a matrix that is 10% empty space, maximum.   
### Word Frequency   
head(table(freq), 20)
# The above output is two rows of numbers. The top number is the frequency with which 
# words appear and the bottom number reflects how many words appear that frequently. 
#
tail(table(freq), 20)
# Considering only the 20 greatest frequencies
#
# **View a table of the terms after removing sparse terms, as above.
freq <- colSums(as.matrix(dtms))
freq
# The above matrix was created using a data transformation we made earlier. 
# **An alternate view of term frequency:**   
# This will identify all terms that appear frequently (in this case, 50 or more times).   
findFreqTerms(dtm, lowfreq=20) # Change "50" to whatever is most appropriate for your data.
#
#
#   
### Plot Word Frequencies
# **Plot words that appear at least 50 times.**   
library(ggplot2)
word=names(freq)
wf <- data.frame(word,freq)
p <- ggplot(subset(wf, freq>4), aes(word, freq))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p
#  
## Relationships Between Terms
### Term Correlations
# See the description above for more guidance with correlations.
# If words always appear together, then correlation=1.0.    
findAssocs(dtm, c("question" , "analysi"), corlimit=0.98) # specifying a correlation limit of 0.98   
# 
# Change "question" & "analysi" to terms that actually appear in your texts.
# Also adjust the `corlimit= ` to any value you feel is necessary.
#
# 
### Word Clouds!   
# First load the package that makes word clouds in R.    
library(wordcloud)   
dtms <- removeSparseTerms(dtm, 0.4) # Prepare the data (max 15% empty space)   
freq <- colSums(as.matrix(dtms)) # Find word frequencies   
dark2 <- brewer.pal(6, "Dark2")   
wordcloud(names(freq), freq, max.words=100, rot.per=0.2, colors=dark2)    
