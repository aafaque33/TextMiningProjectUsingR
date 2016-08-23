
R-Script is written for Text-minning i.e "textmining.R"

Create a Input Folder "texts" and place all txt files there


To run the Program use following command ( in command line )
 
	source('yourpath/textmining.R')


I have generated Plots for the matrix that is only 40% empty space of original data i.e
	dtms <- removeSparseTerms(dtm, 0.4) # change the value 0.4 to 1 to get plot for all data


Input Files:
	1. all-topics-strings.lc.txt
	2. big.txt
	3. cat-descriptions_120396.txt
	4. feldman-cia-worldfactbook-data.txt

Output Plots:
	1. FrequencyHistogram.png
	2. WordFrequencies.png
