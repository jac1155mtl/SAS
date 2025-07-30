# CHAPTER 1 SETTING UP PRACTICE DATA
## 1.1 ACCESSING YOUR PRACTICE DATA
### 1.1.1 REQUIREMENTS

To complete examples in the book, you must have access to [SAS].

### 1.1.2 PRACTICE DATA ZIP FILE

name:

### 1.1.3 INSTRUCTIONS

1. navigate to [SAS support](www.support.sas.com), download and save the practice data zip file.
2. unzip the file and save it to a location that is accessible to [SAS].
3. open the `cre8data.sas` program in [SAS].
4. in the path macro variable, replace `/folders/myfolders` with the path to the cert folder and run the program:

```sas
%let path = /folders/myfolders/cert;
```

> N.B: the location of the path macro variable and the location of your downloaded SAS programs should be the same.
> TIP: when you end your SAS session, the path macro variable in `cre8data.sas` resets. Run `libname.sas` from the cert folder to restore the libraries.

# CHAPTER 2 BASIC CONCEPTS
## 2.1 THE BASICS OF THE SAS LANGUAGE
### 2.1.1 SAS STATEMENTS

> Defn. A *SAS statement* is a type of SAS language element that is used to perform a particular operation in a SAS program or to provide information to a SAS program.

There are two important rules for writing SAS programs:
- a SAS statement ends with a semicolon; and
- a SAS statement usually start with a SAS keyword. 

there are two types of SAS statements:
- statements that are used in DATA or PROC steps; and
- statements that are global in scope and can be used anywhere in a SAS program.

### 2.1.2 GLOBAL STATEMENTS
> Defn. *Global statements* are used anywhere in a SAS program and stay in effect until changed, canceled, or the SAS session ends.

### 2.1.3 DATA STEP
> Defn. The *DATA step* creates or modifies data.

- input: raw data, SAS dataset;
- output: SAS dataset, report.

> Defn. A *SAS dataset* is a data file that is formatted in a way SAS can understand.

### 2.1.4 PROC STEP
> Defn. The *PROC step* analyzes data, produces output or manages SAS files.

- input: SAS dataset; 
- output: a report or an updated SAS dataset.

### 2.1.5 SAS PROGRAM STRUCTURE
A SAS program consists of a sequence of steps. A program can be any combination of DATA or PROC steps. 

```sas
title1 "June Billing";          			(1)

data work.junefee;
    set cert.admitjune;         			(2)
    where age > 39;
run;                            			(3)

proc print data = work.junefee;   			(4)
run;
```

1. global statements are typically outside steps and don't require a RUN statement;
3. if a RUN or QUIT statement is not used, SAS assumes the beginning of a new step implies the end of the previous step.

### 2.1.6 PROCESSING SAS PROGRAMS
When a SAS program is submitted for executing, SAS first validates the syntax then compiles the statements. At a step boundary (end of a step) SAS executes any statement that has not been previously executed and ends the step.

> Tip. the RUN statement is not required between steps in a SAS program but it is a good practice because it makes the SAS program easier to read and the SAS log easier to understand when debugging.

### 2.1.7 LOG MESSAGES

The SAS log collects messages about the processing of SAS programs and about any errors that occur.

### 2.1.8 RESULTS OF PROCESSING
N/A

## 2.2 SAS LIBRARIES
### 2.2.1 DEFINITION
> Defn. A *SAS library* contains 1+ files that are defined, recognized and accessible by SAS and that are referenced and stored as a unit. One special type of file is called *catalog*. In SAS libraries, catalogs function much like subfolders for grouping other members.

### 2.2.2 PREDEFINED SAS LIBRARIES
By default, SAS defines several libraries for you:
- SASHELP: a permanent library that contains sample data and other files that control how SAS works for you;
- SASUSER: a permanent library that contains SAS files in the PROFILE catalog and stores your personal settings; and
- WORK: a temporary library for files that don't need to be saved from session to session.

### 2.2.3 DEFINING LIBRARIES
To define a library, you assign a library name to it and specify the location of the file, such as a directory path.

You can define SAS libraries using programming statements.

When deleting a SAS library, the pointer to the library is deleted and SAS no longer has access to the library. However, the contents of the library still exist in your operating environment.

### 2.2.4 HOW SAS FILES ARE STORED
N/A

### 2.2.5 STORING FILES TEMPORARILY OR PERMANENTLY

|TEMPORARY| PERMANENT|
|---------|----------|
|lasts only for the current session| available to you during subsequent SAS sessions|
|if you don't specify a library name, the file is stored in the WORK SAS library|to store files permanently in a SAS library, specify a library name other than the default WORK library|
: Table 2.2 Temporary and permanent SAS libraries

## 2.3 REFERENCING SAS FILES
### 2.3.1 REFERENCING PERMANENT SAS DATASETS

To reference a permanent SAS dataset in your SAS programs, use a two-level name consisting of the library name and the dataset name: 

```sas
LIBREF.DATASET
```

In the two-level name LIBREF is the name of the SAS library that contains the dataset and DATASET is the name of the SAS dataset.

### 2.3.2 REFERENCING TEMPORARY SAS FILES
To reference temporary SAS files, you can specify the default libref WORK, a period and the dataset name:

```sas
WORK.DATASET
```

Alternatively, you can use a one-level name (the dataset name's only) to reference a file in a temporary SAS library.

### 2.3.3 RULES FOR SAS NAMES

By default, the following rules apply to the names of SAS datasets, variables and libraries:
- they must begin with a letter (A-Z, either uppercase or lowercase) or an underscore (\_);
- they can continue with any combination of numbers, letters, or underscores;
- they can be 1 to 32 characters long; and
- SAS library names (librefs) can be 1 to 8 characters long.

### 2.3.4 VALIDVARNAME =  SYSTEM OPTION

SAS has various rules for variable names. You set these rules using the `VALIDVARNAME = ` system option.
___
##### VALIDVARNAME=  system option

```sas
validvarname = V7|upcase|any
```

- `VALIDVARNAME=V7` specifies that variable names must follow these rules:
	- SAS variable names can be up to 32 characters long;
	- the first character must begin with a letter of the Latin alphabet (A-Z, either uppercase or lowercase) or an underscore (\_). Subsequent characters can be letters of the Latin alphabet, numerals or underscores.
	- trailing blanks are ignored. the variable name alignment is left-adjusted;
	- a variable name can't contain blanks or special characters except for an underscore;
	- a variable name can contain mixed-case letters: you cannot use the same variable name with a different combination of uppercase and owercase letters to represent different variables;
	- do not assign variables the names of special SAS automatic variables (e.g \_N\_, \_ERROR\_) or variable list names (e.g. \_NUMERIC\_, \_CHARACTER\_, \_ALL\_).

- `VALIDVARNAME=UPCASE` specifies that variable names follow these rules:
	- the same rules as `VALIDVARNAME=V7`, 
	- the variable name is uppercase, as in earlier versions of SAS.

- `VALIDVARNAME=ANY` specifies that variable names follow these rules:
	- the name can begin with or contain any character, including blanks, national characters, special characters, and multi-byte characters;
	- the name can be up to 32 bytes long;
	- the name cannot contain any null bytes;
	- the name must contain at least one character. A name with all blanks is not permitted;
	- a variable name can contain mixed-case letters: you cannot use the same variable name with a different combination of uppercase and owercase letters to represent different variables.

[SAS documentation for VALIDVARNAME = ](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lesysoptsref/p124dqdk8zoqu3n1r4nsfqu5vx52.htm).
___

>N.B. If you use characters other than the ones that are valid when `VALIDVARNME=V7`, then you must express the variable name as a name literal (?) and set `VALIDVARNME=ANY`.

>CAUTION: The `VALIDVARNAME=ANY` system option enables compatibility with other DBMS variable naming conventions.

### 2.3.5 VALIDMEMNAME=  SYSTEM OPTION

You can use the `VALIDMEMNAME=` system option to specify rules for naming SAS datasets.

___
##### VALIDMEMNAME=  system option

```sas
validmemname = compatible (default)|extend
```

- `VALIDNMEMNAME=COMPATIBLE` specifies that a SAS dataset name must follow these rules:
	- the length of the names can be up to 32 characters long;
	- the first character must begin with a letter of the Latin alphabet (A-Z, either uppercase or lowercase) or an underscore (\_). Subsequent characters can be letters of the Latin alphabet, numerals or underscores.
	- a dataset name can't contain blanks or special characters except for an underscore;
	- a dataset name can contain mixed-case leters: you cannot use the same dataset name with a different combination of uppercase and owercase letters to represent different datasets.

- `VALIDMEMNAME=EXTEND` specifies that a SAS dataset name must follow these rules:
	- the name can include national characters;
	- the name can include special characters, except for /\ \* ? " < > |: - characters
	- the name can be up to 32 bytes long;
	- the name cannot contain any null bytes;
	- the name cannot begin with a blank or a period;
	- leading and trailing blanks are deleted when the member is created;
	- the name must contain at least one character. A name with all blanks is not permitted;
	- a variable name can contain mixed-case leters: you cannot use the same variable name with a different combination of uppercase and owercase letters to represent different variables.

[SAS documentation for VALIDMEMNAME = ](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lesysoptsref/n10nwm6blrcrtmn0zdcwyxlwxfjh.htm).
___

>N.B. If `VALIDMEMNAME = EXTEND`, SAS dataset names must be written as a SAS name literal.

>CAUTION: The `VALIDVMEMNAME = EXTEND` system option enables compatibility with other DBMS dataset naming conventions.

### 2.3.6 WHEN TO USE VALIDMEMNAME =  SYSTEM OPTION

Use the `VALIDMEMNAME=EXTEND` system option when the characters in SAS dataset name contains one of the following:
- international characters;
- characters supported by third-party databases;
- characters that are commonly used in a filename.

## 2.4 SAS DATASETS
### 2.4.1 OVERVIEW OF DATASETS

>Defn. A *SAS dataset* is a file that consists of two parts: a descriptor portion and a data portion. Sometimes a SAS dataset also points to one or more indezes, which enable SAS to locate rows in the data faster. Extended attributes are user-defined attributes that further define a SAS dataset.

### 2.4.2 DESCRIPTIOR PORTION

The descriptor portion of a SAS dataset contains information about the dataset, including the following:
- the name of the dataset;
- the date and time the dataset was created;
- the number of observations;
- the number of variables.

### 2.4.3 SAS VARIABLE ATTRIBUTES
The descriptor portion of a SAS dataset contains information about the properties of each variable in the dataset. The properties include:

|VARIABLE ATTRIBUTE | DEFINITION |POSSIBLE VALUES|
|---                |---         |---|
|Name               |identifies a variable. a variable name must conform to SAS naming rules|any valid SAS name|
|Type               |identifies a variable as numeric or character. Character variables can contain any values. numeric variables can contain only numeric values|numeric and character|
|Length             |refers to the number of bytes used to store each of the variable's values in a SAS dataset.|2 to 8 bytes for numeric variables, 1 to 32,767 bytes for character variables|
|Format             |affects how data values are displayed.| any SAS format. if no format is specified, the default is BEST12. for numeric variables and $w. for character variables|
|Informat           |reads data values in certain forms into standard SAS values|any SAS informat. if no informat is specified the default is w.d for numeric variables and $w. for character variables|
|Label              |refers to a descriptive label|up to 256 characters|

### 2.4.4 DATA PORTION
The data portion of a SAS dataset is a collection of data values that are arranged in a rectangular table.

##### Observations (rows)
>Defn. *Observations* (also called rows) in the dataset are collections of data values that usually relate to a single object.

##### Variables (columns)
>Defn. *Variables* (also called columns) in the dataset are collections of values that describe a particular characteristic.

##### Missing values
every variable and observation in a SAS dataset must have a value. if a data value is unknown for a particular observation, a missing value is recorded in the SAS dataset. A period (.) is the default value for a missing numeric value and a blank space is the default value for a missing character value.

### 2.4.5 SAS INDEXES
An index is a separate file that you can create for a SAS data file in order to provide direct access to a specific observation. Indexes can provide faster access to specific observations, particularly when you have a large dataset. the purpose of SAS indexes is to optimize `WHERE` expressions and to facilitate `BY`-group processing.

### 2.4.6 EXTENDED ATTRIBUTES
Extended attributes are user-defined metadata that is defined for a dataset or for a variable.

>Tip. you can use PROC CONTENTS to display dataset and variable extended attributes.

[SAS documentation for PROC CONTENTS](https://documentation.sas.com/doc/en/proc/3.2/n1hqa4dk5tay0an15nrys1iwr5o2.htm).

# CHAPTER 3 ACCESSING YOUR DATA
## 3.1 SAS LIBRARIES
>Defn. A *SAS library* is a collection of one or more SAS files, including SAS datasets, that are referenced and stored as a unit.

### 3.1.1 ASSIGNING LIBREFS
Often the first step in setting up your SAS session is to define the libraries. you can use programming statements to assign library names.

to reference a permanent SAS file:
1. assign a name (LIBREF) to the SAS library in which the file is stored
2. use the libref as the first part of the two-level name (LIBREF.FILENAME) to reference the file within the library

A libref can be assigned to a SAS library using the LIBNAME statement. You can include the LIBNAME statement with any SAS program so that the SAS library is assigned each time the program is submitted. using the user interface, you can set up LIBNAME statements to automatically assigned when SAS starts.

___
##### LIBNAME statement

```sas
libname libref engine “SAS-data-library”;
```

- *libref* is 1 to 8 characters long, begins with a letter, or underscore, and contains only letters, numbers or underscores
- *engine* is the name of a library engine that is supported in your operating environment
- *SAS-data-library* is the name of a SAS library in which SAS data files are stored

[SAS documentation for LIBNAME statement](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lestmtsglobal/n1nk65k2vsfmxfn1wu17fntzszbp.htm).
___

>N.B. For SAS 9, the default engine is V9, which works in all operating environments.

the LIBNAME statement below assigns the libref CERT to the SAS library `C:\Users\Student1\cert` in the Windows environment (1). When the default engine is used, you do not have to specify it in the LIBNAME statement.

```sas
libname cert “C:\Users\Student1\cert”;		(1)
```

>Tip. You can use multiple LIBNAME statements to assign as many librefs as needed.

### 3.1.2 VERIFYING LIBREFS
After assigning a libref, it is a good idea to check the log to verify that the libref has been assigned successfully.

### 3.1.3 HOW LONG LIBREFS REMAIN IN EFFECT
The LIBNAME statement is global which means that the librefs remain in effect until changed or canceled or until the SAS session ends.

### 3.1.4 SPECIFYING TWO-LEVEL NAMES
After you assign a libref, you specify it as the first element in the two-level name for a SAS file (1).

```sas
proc print data = cert.admit;				(1)
run;
```

(1) In order for PROC PRINT to read CERT.ADMIT, you specify the two-level name of the file.

### 3.1.5 REFERENCING THIRD-PARTY DATA
You can use the LIBNAME statement to reference not only SAS files but also files that were created with other software products, such as database management systems (DBMS).

>Defn. A *SAS engine* is a set of internal instructions that SAS uses for writing to and reading from files in a SAS library or a thrid-party database.

SAS can read or write these files by using the appropriate engine for that file type.

### 3.1.6 ACCESSING STORED DATA
if your site licences SAS/ACCESS software, you can use the LIBNAME statement to access data that is stored in a DBMS file.

## 3.2 VIEWING SAS LIBRARIES
### 3.2.1 VIEWING LIBRARIES
N/A

### 3.2.2 VIEWING LIBRARIES USING PROC CONTENTS
you can use the `CONTENTS` procedure to create SAS output that describes either of the following:
- the contents of a library
- the descriptor information for an individual SAS dataset

___
##### PROC CONTENTS step

```sas
proc contents data = SAS-file-specifications nods;
run;
```

- *SAS-file-specification* specifies an entire library or a specific SAS dataset within a library. *SAS-file-specification* can take one of the following forms:
	- *libref.SAS-data-set* names one SAS dataset to process
	- *libref.\_all\_* requests a listing of all files in the library
- *NODS* suppresses the printing of detailed information about each file when you specify \_ALL\_(you can specify NODS only when you specify \_ALL\_)

[SAS documentation for PROC CONTENTS](https://documentation.sas.com/doc/en/proc/3.2/n1hqa4dk5tay0an15nrys1iwr5o2.htm).
___

### 3.2.3 EXAMPLE: VIEW THE CONTENTS OF AN ENTIRE LIBRARY
to view the contents of an entire library, specify the \_ALL\_ and NODS options in the PROC CONTENTS step (1).

```sas
proc contents data = cert._all_ nods;		(1)
run;
```

### 3.2.4 EXAMPLE: VIEW DESCRIPTOR INFORMATION
to view the descriptor information for only a specific dataset, use the PROC CONTENTS step (1).

```sas
proc contents data = cert.amounts;			(1)
run;
```

### 3.2.5 EXAMPLE: VIEW DESCRIPTOR INFORMATION USING THE VARNUM OPTION
by default, PROC CONTENTS lists variables alphabetically. to list variable names in the order of the logical position (or creation order) in the dataset, specify the VARNUM option in PROC CONTENTS (1).

```sas
proc contents data = cert.amounts varnum;	(1)
run;
```

# CHAPTER 4 CREATING SAS DATASETS
## 4.1 REFERENCING AN EXTERNAL DATA FILE
### 4.1.1 USING A FILENAME STATEMENT
Using the FILENAME statement to point to the lication of the external file that contains the data.

Filerefs perform the same function as librefs: they temporarily point to a storage location for data. However, librefs reference SAS libraries, whereas filerefs reference external files.
___
##### FILENAME statement

```sas
filename fileref “filename”;
```

- *fileref* is a name that you associate with an external file. The name must be 1-8 characters long, begin with a letter or underscore, and contain only letters, numbers or underscores;
- *”filename”* is the fully qualified name or location of the file.

[SAS documentation for FILENAME](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lestmtsglobal/p05r9vhhqbhfzun1qo9mw64s4700.htm)
___

### 4.1.2 DEFINING A FULLY QUALIFIED FILENAME
The following FILENAME statement temporarily associates the fileref EXERCISE with the external file that contains the data from the exercise stress tests (1).

### 4.1.3 REFERENCING A FULLY QUALIFIED FILENAME
When you associate a fileref with an individual external file, you specify the fileref in subsequent SAS statements and commands (2).

```sas
filename exercise “C:\Users\Student1\cert\exercise.txt”;	(1)

proc import
		datafile = exercise					(2)
		dbms = dlm
		out = work.exstress
		replace;
	getnames = no;
run;

proc print data = work.exstress;
run;
```

## 4.2 THE IMPORT PROCEDURE
### 4.2.1 THE BASICS OF PROC IMPORT
The `IMPORT` procedure reads data from an external data source and writes it to a SAS dataset. You can import structured and unstructured data using PROC IMPORT. You can import delimited files (blank, comma or tab) along with Microsoft Excel files. 

You can use the PROC IMPORT statements to do the following:
- indicate how many rows SAS scans for variables to determine their type, length, informat and format (GUESSINGROWS= statement). By default the procedure scans the first 20 rows.  
- modify whether SAS extracts the variable names from the first row of the dataset (GETNAMES= statement ). By default the procedures expects the variable names to appear in the first row.
- indicates at which row SAS begins to read the data (DATAROW= statement).

PROC IMPORT writes information about the import to the SAS log. The log displays the DATA step code that is generated by PROC IMPORT.

### 4.2.2 PROC IMPORT SYNTAX
___
##### PROC IMPORT statement

```sas
proc import
		datafile = “filename”|table = “tablename”
		out = <libref.SAS-dataset><SAS-dataset-options>
		<dbms = identifier>
		<replace>;
```

- *datafile = “filename”|”fileref”* specifies the complete path and filename or fileref for the imput PC file, spreadsheet or delimited external file.
	- Restrictions: 
		- PROC IMPORT does not support device types or access methods for the FILENAME statement except for DISK.
		- PROC IMPORT can import data only if SAS supports the data type. SAS support numeric and character types of data but not binary objects. The procedure attempts to convert the data to the best of its ability. However conversion is not possible for some types.
	- Interactions:
		- By default, PROC IMPORT reads delimited files as varying record-length files. If your external file has a fixed-length format, use the FILENAME statement prior to PROC IMPORT to specify the imput filename using the RECFM=F and LRECL= options.
		- The logical record length defaults to 256 unless you specify the LRECL= option in the FILENAME statement.
		- For delimited files, the first 20 rows are scanned to determine the variable attributes. All values are read in as character strings. If a Date and time format or a numeric informat can be applied to the data value, the type is declared as numeric. Otherwise, the type remains character.

- *out = <libref.>SAS-dataset* identifies the output SAS dataset. If the specified SAS dataset does not exist, PROC IMPORT creates it. A SAS dataset name can contain a single quotation mark when the VALIDMEMNAME=EXTEND system option is also specified (see section 2.3.5).

- *table = “tablename”* specifies the name of the input DBMS table. You must include the quotation marks. Note, the DBMS table name might be case sensitive.
	- Requirement: when you import a DBMS table, you must specify the DBMS= option.

- *<dbms=identifier>* specifies the type of data to import. Here are the common DBMS identifiers that are included with Base SAS:
	- CSV - for a common-separated file with a .csv extension, DBMS= is optional.
	- JMP - if you are using SAS 9.4 you can import JMP 7 or later files.
	- TAB - specify DBMS=DLM to import any other delimited file that does end in .csv.

- *<replace>* overwrites and existing SAS dataset. If you omit the REPLACE option, PROC IMPORT does not overwrite an existing dataset.

- *<SAS-dataset-options>* specifies SAS dataset options.
	- Restriction: you cannot specify dataset options when importing delimited, comma-separted, or tab-delimited external files.

[SAS documentation for PROC IMPORT](https://documentation.sas.com/doc/en/proc/3.2/n1qn5sclnu2l9dn1w61ifw8wqhts.htm)
___
### 4.2.3 EXAMPLE: IMPORTING AN EXCEL FILE WITH AN XLSX EXTENSION

```sas
options validvarname=v7;						(1)

proc import										(2)
		datafile = “C:\Users\Student1\cert\boots.xlsx”
		dbms = xlsx
		out = work.bootsales
		replace;
	sheet = boot;								(3)
	getnames = yes;								(4)
run;

proc contents data = work.bootsales;			(5)
run;

proc print data = work.bootsales;
run;
```

1. VALIDVARNAME=V7 statements forces SAS to convert spaces to underscores with it convert column names to variable names.
2. Specify the input file. When importing an Excel workbook, specify DBMS=XLSX.
3. Use the SHEET= option to import specific worksheets from an Excel workbook.
4. Set the GETNAMES=YES statement to generate variable names fromt he first row of data.
5. Use PROC CONTENTS to display the descriptor portion of the new SAS dataset.

### 4.2.4 EXAMPLE: IMPORTING A DELIMITED FILE WITH A TXT EXTENSION

```sas
options validvarname=v7;

proc import
		datafile = “C:\Users\Student1\cert\delimiter.txt”
		dbms = dlm								(1)
		out = work.mydata
		replace;
	delimiter = “&”;							(2)
	getnames = yes;	
run;

proc print data = work.mydata;
run;
```

1. If the delimiter is a character other than TAB or CSV, then the specify DBMS=DLM.
2. Specify an ampersand (&) for the DELIMITER= statement.

### 4.2.5 EXAMPLE: IMPORTING A SPACE-DELIMITED FILE WITH A TXT EXTENSION

```sas
options validvarname=v7;

filename stdata “C:\Users\Student1\cert\state_data.txt” lrecl=100;	(1)
proc import
		datafile = stdata
		dbms = dlm
		out = work.states
		replace;
	delimiter = “ “;							(2)
	getnames = yes;
run;

proc print data = work.states;
run;
```

1. Specify the fileref and the location of the file. Specify the LRECL= system option if the file has a fixed-length format.
2. Specify a blank value for the DELIMITER statement.

### 4.2.6 EXAMPLE: IMPORTING A COMMA-DELIMITED FILE WITH A CSV EXTENSION

```sas
options validvarname=v7;

proc import
		datafile = “C:\Users\Student1\cert\boots.csv”
		dbms = csv 								(1)
		out = work.shoes
		replace;
	getnames = no;								(2)
run;

proc print data = work.shoes;
run;
```

1. Specify the input file. When the file type CSV, specify DBMS=CSV.
2. Set GETNAMES=NO to not use the first row of data as variable names.

### 4.2.7 EXAMPLE: IMPORTING A TAB-DELIMITED FILE 

```sas
proc import
		datafile = “C:\Users\Student1\cert\class.txt”
		dbms = tab 								(1)
		out = work.class
		replace;
	delimiter = ’09’x;							(2)
run;

proc print data = work.class;
run;
```

1. Specify the input file. When the file type TXT, specify DBMS=TAB.
2. Specify the delimiter. On an ASCII platform, the hexadecmial representation of a tab is ’09’x. On an EBCDIC platform, the haxademical presentation of a table is a ’05’x.

## 4.3 READING AND VERIFYING DATA
### 4.3.1 VERIFYING THE CODE THAT READS THE DATA
Before you read a complete external file, you can verify the code that reads the data by limiting the number of observations that SAS reads: use the OPTIONS statement with the OBS= option before the PROC IMPORT (1).

```sas
options obs = 5; (1)
proc import
		datafile = “C:\Users\Student1\cert\boots.csv”
		dbms = csv
		out = work.shoes
		replace;
	getnames = no;
run;

proc print data = work.shoes; (2)
run; 
```

### 4.3.2 CHECKING DATA STEP PROCESSING
After PROC IMPORT runs the DATA step to read the data, messages in the log verify that the data was read correctly.

### 4.3.3 PRINTING THE DATASET
The messages in the log indicate that the PROC IMPORT step correctly accessed the external data file. But it is a good idea to look at the five observations in the new dataset before reading the entire dataset. You can submit a PROC PRINT step to view the data (2).

### 4.3.4 READING THE ENTIRE EXTERNAL FILE
To modify the PROC step to read the entire external file, restore the default value to the OBS= system option. To do this, set OBS=MAX and then resubmit the program (3).

```sas
options obs = max; (3)
proc import
		datafile = “C:\Users\Student1\cert\boots.csv”
		dbms = csv
		out = work.shoes
		replace;
	getnames = no;
run;
```

## 4.4 USING THE IMPORTED DATA IN A DATA STEP
### 4.4.1 NAMING THE DATASET WITH THE DATA STATEMENT
The DATA statement indicates the beginning of. the DATA step and names the SAS dataset to be created.

___
##### DATA statement

```sas
data SAS-dataset-1 <…SAS-dataset-n>;
```

- *SAS-dataset* names (in the format *libref.filename*) the dataset or datasets to be created.
___

### 4.4.2 SPECIFYING THE IMPORTED DATA WITH THE SET STATEMENT
The SET statement specifies the SAS dataset that you want to use as input data for your DATA step.

#### SET STATEMENT SYNTAX
___
##### DATA STEP FOR READING A SINGLE DATASET

```sas
data SAS-dataset;
	set SAS-dataset;
	<…more SAS statements…>
run;
```

- *SAS-dataset* in the DATA statement is the name of the SAS dataset to be created.
- *SAS-dataset* in the SET statement is the name of the SAS dataset to be read.
___

#### EXAMPLE: USING THE SET STATEMENT TO SPECIFY IMPORTED DATA
The DATA statement tells SAS to name the new dataset BOOTS and store it in the the temporary library WORK (1). The SET statement in the DATA step specifies the output data set from PROC IMPORT (2). You can use several statemetns in the DATA step to subset your data (3).

```sas
proc import 
		datafile = “C:\certdata\boot.csv”
		out = work.shoes (2)
		dbms = csv
		replace;
	getnames = no;
run;

data work.boots; (1)
	set work.shoes; (2)
	where var1 = “South America” or var1 = “Canada”; (3)
run;
```

## 4.5 READING A SINGLE SAS DATASET TO CREATE ANOTHER
### 4.5.1 EXAMPLE: READING A SAS DATASET

The dataset CERT.ADMIT contains health information about patients in a clinic, their activity level, height and weight. Suppose you want to create a subset of the data: a small dataset containing data about all the men in the group who are older than 50.

To create the dataset, you first reference the library in which CERT.ADMIT is stored (1). Then you must specify the name of the library in which you want to store the MALES dataset (2). Finally, you add statements to the DATA step to read your data and create a new dataset (3).

Add a PROC PRINT to see the output of the created dataset (4).

```sas
libname cert “C:\Users\Student\Cert\”; (1)
libname men50 “C:\Users\Student\Cert\Men50”; (2)

data men50.males; (3)
	set cert.admit;
	where sex = “M” and age > 50;
run;

proc print data = men50.males; (4)
	title “Men Over 50”;
run; 
```

### 4.5.2 SPECIFYING DROP= AND KEEP= DATASET OPTIONS
You can specify the DROP= and KEEP= dataset options anywhere you name a SAS dataset. 
- if you never reference certain variables and you do not want them to appear in the new dataset, use a DROP= option in the SET statement (1). These variables are not available to be used by the DATA step.
- if you do need to reference a variable in the original dataset, you can specify the variable in the DROp= or KEEP= option in the DATA statement (2). When used in the DATA statement, the DROP= option simply drops the variables from the new dataset. However, they are still read from the original dataset and are available within the DATA step (3).

```sas
data cert.drug1h(drop=placebo); (2)
	set cert.cltrials(drop=triglyc uric); (1)
	if placebo = “YES”;
run;

proc print data = cert.drug1h;
run;
```

## 4.6 READING MICROSOFT EXCEL DATA WITH THE XLSX ENGINE
### 4.6.1 RUNNING SAS WITH MICROSOFT EXCEL
N/A

### 4.6.2 STEPS FOR READING EXCEL DATA
To read the Excel workbook file, SAS must receive the following information in the DATA step:
- a libref to reference the Excel workbook to be read
- the name of the Excel worksheet that is to be read

```sas
libname certxl xlsx “C:\Users\Student1\cert\exercise.xlsx”;

proc contents data = cert._all_;
run;

data work.stress;
	set cert.actlevel;
run;

proc print data = work.stress;
run;
```

The PROC CONTENTS and PROC PRINT statements are not requirements for reading Excel data and creating a SAS dataset. However, these statements are useful for confirming that your Excel data has sucessfully been read into SAS.

### 4.6.3 THE LIBNAME STATEMENT
To assign a libref to a database, use the LIBNAME statement

___
##### SAS/ACCESS LIBNAME statment

```sas
libname <libref> xlsx <“physical-path-and-filename.xlsx”><options>;
```

- *xlsx* is the SAS LIBNAME  engine name for and XLSX file format. The SAS/ACCESS LIBNAME statement associates a libref with an XLSX engine that supports the connections to Microsfot Excel 2007, 2010 and later files. When reading XLSX data, the XLSX engine reads mixed data (columns containing numeric and character values) and converts it to character data values.
	- Important: the engine name XLSX is required.
- *“physical-path-and-filename.xlsx”* is the physical location of the Excel workbook.
	- Note: the XLSX engine requires quotation marks for the *physical-path-and-filename.xlsx*.
___

### 4.6.4 REFERENCING AN EXCEL WORKBOOK
#### REFERENCING AND EXCEL WORKBOOK IN A DATA STEP
##### OVERVIEW

To read in a workbook, create a libref to point to the workbook’s location (1).

### 4.6.5 REFERENCING AN EXCEL WORKBOK IN A DATA STEP
##### SET STATEMENT
Uset the SET statement to indicate which worksheet in the Excel file you want to read (2).

```sas
libname certxl xlsx “C:\Users\Student1\cert\exercise.xlsx”; (1)

data work.stress;
	set certxl.activitylevels; (2)
run;
```

##### NAME LITERALS
Name literals are required with the XLSX engine only when the worksheet name contains a speicaal character or spaces. 

>Defn. A SAS *name literal* is a name token that is expressed as a string within quotation marks, followed by the uppercase or lowercase letter *n*. 

In the case of Excel files, the name literal tells SAS to allow special character \$ in the dataset name (1).

```sas
libname certxl xlsx “C:\Users\Student1\cert\stock.xlsx”;

data work.bstock;
	set certxl.’boots stock’n; (1)
run;

proc print data = work.bstock;
run;
```

### 4.6.6 PRINTING AN EXCEL WORKSHEET AS A SAS DATASET

After using the DATA step to read in the Excel data and create a SAS dataset, you can use PROC PRINT 
to produce a report that displays the dataset values (2).

In the example below, the PROC PRINT statement referes tot he worksheet directly and pritns the contents of the Excel worksheet that was referenced byt eh SAS/ACCESS LIBNAME statement.

```sas
libname certxl xlsx “C:\Users\Student1\cert\stock.xlsx”;

proc print data = certxl.’boots stock’n;
run;

```

## 4.7 CREATING EXCEL WORKSHEETS
In addition to readign Microselft Excel data, SAS can alos create Excel worksheets from SAS datasets.
- If the Excel workbook does not exist, SAS creates it.
- If the Excel worksheet within the workbook does not exist, SAS creates it.
- if the Excel workbook and worksheet already exist, then SAS overwirtes the existing Excel workbook and worksheet.

```sas
libname excelout xlsx “C:\Users\Student1\cert\newExcel.xlsx”;

data excelout.HighStress;
	set cert.stress;
run;
```

## 4.8 WRITING OBSERVATIONS EXPLICITLY

To override the default way in which the DATA step writes observations to output, you can use and OUTPUT statement in the DATA step. Placing an explicit OUTPUT statement in a DATA step overrides the implicit output at the end of the DATA step. The observations are added to a dataset only when the explicit OUTPUT statement is executed.

___
##### OUTPUT Statement

```sas
output <SAS-dataset(s)>;
```

- *SAS-dataset(s)* names the dataset(s) to which the observation is written. All dataset names that are specified in the OUTPUT statment must all appear in the DATA statement.

Using an OUTPUT statement without a following dataset name causes the current observation to be written to all datasets that are specified in teh DATA statement.
___

With an OUTPUT statement, your program now rites a single observation to ouptut, observation 5 (1).

```sas
data work.usa5;
	set cert.usa(keep=manager wagerate);
	if _n_ = 5 then output; (1)
run;

proc print data = work.usa5;
run;
```

Suppose your DATA statements contains two dataset names, and you include an output statement that references only one of the datasets. The DATA step creates both datasets, but only the dataset that is specified in the OUTPUT statement contains output (1);

```sas
data work.empty work.full;
	set cert.usa;
	output work.full; (1)
run;
```

# CHAPTER 99 GOOD PROGRAMMING PRACTICE

1. Always use two-level names for the SAS datasets, even those in the WORK library.
2. After creating a new libref, always use PROC CONTENTS to describe the contents of the library

```sas
libname cert xlsx “C:\Users\Student1\cert”;

proc contents data = cert._all_ nods;
run;
```

3. Before reading a complete external file, verify the code that reads the data by limiting the number of observations that SAS reads

```sas

filename boots “C:\Users\Student1\cert\boots.csv”;

options obs = 5;
proc import
		datafile = boots
		dbms = csv
		out = work.shoes
		replace;
	getnames = no;
run;

proc contents data = work.shoes varnum;
run;

proc print data = work.shoes;
run; 

options obs = max;
proc import
		datafile = boots
		dbms = csv
		out = work.shoes
		replace;
	getnames = no;
run;

proc contents data = work.shoes varnum;
run;

proc print data = work.shoes;
run; 
```

4. After importing new data, always use PROC CONTENTS and PROC PRINT to confirm the data was read successfully.

```sas
libname certxl xlsx “C:\Users\Student1\cert\stock.xlsx”;

proc contents data = certxl._all_ nods;
run;

data work.bstock;
	set certxl.’boots stock’n;
run;

proc contents data = work.bstock varnum;
run;

proc print data = work.bstock;
run;
```
