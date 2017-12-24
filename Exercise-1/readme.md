

Instructions:
Only the R script must be delivered with the instructions used to solve the exercises. Possible
Comments like those that are asked in Exercise 2 can be included in the script behind a pad (#).
You can do the practice individually or as a couple. In case and do it as a couple, send an email with
your names until December 4th at klaus.langohr@upc.edu.
Follow the programming style recommendations in R presented in the following web page: https:
//google.github.io/styleguide/Rguide.xml.


The ACCESS StudyENTE.mdb database contains some variables of the longitudinal study on the effects of the
regular consumption of the'extasis '(Study ENTE: Neurotoxic effects of Extasis) carried out a few years ago in'
the Research Unit in Pharmacology of the IMIM (Instituto Hospital del Mar de Investigaciones Míticas). In this
In this case, it is about variables of the different neuropsychological tests that the volunteers did at the beginning of the study.
The StudyENTE.mdb file has three tables corresponding to the three study groups: the consumers of'extasis
(XTC), cannabis users and controls. The database password is the code and the file
Información.txt contains information about the variables.

a) Use the functions of the RODBC package to import the data from the three tables in the database
StudyENTE.mdb and merge them into a single data frame.

Note: It is possible that for this section you need the 32-bit version of R.

b) Add a variable (group) that indicates the study group (Extasis, Cannabis and Control). This variable has'
to be a factor with the group'extasis as a reference category.

c) Sort the data frame according to the study group and the volunteer identifier.

d) How many cases (rows) have the entire data frame and how many cases if those with any missing data are discarded?
(missing)?

e) Convert the variable to a factor with values ​​'Male' (sex == 1) and 'Female' (sex == 2), respectively.

f) Use the cut function to create a new categorical variable that contains the age of the volunteers: ≤ 21,
22-24 and ≥ 25 (years).

g) Create a composite variable (variable composite) using the variables corcub, sdmttoco, lnsscore and waisvocd
in the following way: the 4 variables must be standardized (so that they have average 0 and deviation are standard
1) and then add the 4 values ​​(standardized).

h) What are the mean, the median, the standard deviation and the range of the variable composed in each group?

**i)** Add the data frame created as a new table to the StudyENTE.mdb database.

j) Use the sqlQuery function (from the RODBC package) to extract (only) the variables study group and age
(categorized) of the new StudyENTE.mdb table

k) Represent the conditioned distribution of the age variable by study group through a graph of
mosaics

l) Represent the conditional distribution of the age variable by study group using a table of
contingency using the CrossTable function of the descr package.

m) Close the connection to the StudyENTE.mdb database.

n) Export your data frame to an EXCEL file in such a way that the EXCEL file contains a sheet by
Each study group with the same name as the study group. The three sheets of the file should no longer contain
the variable group. You can use the write.xlsx function of the xlsx package or the write.xlsx function of the package
openxlsx.
