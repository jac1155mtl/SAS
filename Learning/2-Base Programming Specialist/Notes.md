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
```
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
- statements that are used in `DATA` or `PROC` steps; and
- statements that are global in scope and can be used anywhere in a SAS program.

### 2.1.2 GLOBAL STATEMENTS
> Defn. *Global statements* are used anywhere in a SAS program and stay in effect until changed, canceled, or the SAS session ends.

### 2.1.3 DATA STEP
> Defn. The *`DATA` step* creates or modifies data.

- input: raw data, SAS dataset;
- output: SAS dataset, report.

> Defn. A *SAS dataset* is a data file that is formatted in a way SAS can understand.

### 2.1.4 PROC STEP
> Defn. The *`PROC` step* analyzes data, produces output or manages SAS files.

- input: SAS dataset; 
- output: a report or an updated SAS dataset.

### 2.1.5 SAS PROGRAM STRUCTURE
A SAS program consists of a sequence of steps. A program can be any combination of `DATA` or `PROC` steps. 

```
title1 "June Billing";          (1)

data work.junefee;
    set cert.admitjune;         (2)
    where age > 39;
run;                            (3)

proc print data=work.junefee;   (4)
run;
```
1. global statements are typically outside steps and don't require a `RUN` statement;
3. if a `RUN` or `QUIT` statement is not used, SAS assumes the beginning of a new step implies the end of the previous step.

### 2.1.6 PROCESSING SAS PROGRAMS
When a SAS program is submitted for executing, SAS first validates the syntax then compiles the statements. At a step boundary (end of a step) SAS executes any statement that has not been previously executed and ends the step.

> Tip. the `RUN` statement is not required between steps in a SAS program but it is a good practice because it makes the SAS program easier to read and the SAS log easier to understand when debugging.

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

```
LIBREF.DATASET
```
In the two-level name `LIBREF` is the name of the SAS library that contains the dataset and `DATASET` is the name of the SAS dataset.

### 2.3.2 REFERENCING TEMPORARY SAS FILES
To reference temporary SAS files, you can specify the default libref `WORK`, a period and the dataset name:

```
WORK.DATASET
```

Alternatively, you can use a one-level name (the dataset name's only) to reference a file in a temporary SAS library.

### 2.3.3 RULES FOR SAS NAMES

By default, the following rules apply to the names of SAS datasets, variables and libraries:
- they must begin with a letter (A-Z, either uppercase or lowercase) or an underscore (\_);
- they can continue with any combination of numbers, letters, or underscores;
- they can be 1 to 32 characters long; and
- SAS library names (librefs) can be 1 to 8 characters long.

### 2.3.4 VALIDVARNAME= SYSTEM OPTION

SAS has various rules for variable names. You set these rules using the `VALIDVARNAME=` system option.
___
>Syntax. `VALIDVARNAME=` system option
```
VALIDVARNAME=V7|UPCASE|ANY
```
`VALIDVARNAME=V7` specifies that variable names must follow these rules:
- SAS variable names can be up to 32 characters long;
- the first character must begin with a letter of the Latin alphabet (A-Z, either uppercase or lowercase) or an underscore (\_). Subsequent characters can be letters of the Latin alphabet, numerals or underscores.
- trailing blanks are ignored. the variable name alignment is left-adjusted;
- a variable name can't contain blanks or special characters except for an underscore;
- a variable name can contain mixed-case letters: you cannot use the same variable name with a different combination of uppercase and owercase letters to represent different variables;
- do not assign variables the names of special SAS automatic variables (e.g \_N\_, \_ERROR\_) or variable list names (e.g. \_NUMERIC\_, \_CHARACTER\_, \_ALL\_).

`VALIDVARNAME=UPCASE` specifies that variable names follow these rules:
- the same rules as `VALIDVARNAME=V7`, 
- the variable name is uppercase, as in earlier versions of SAS.

`VALIDVARNAME=ANY` specifies that variable names follow these rules:
- the name can begin with or contain any character, including blanks, national characters, special characters, and multi-byte characters;
- the name can be up to 32 bytes long;
- the name cannot contain any null bytes;
- the name must contain at least one character. A name with all blanks is not permitted;
- a variable name can contain mixed-case letters: you cannot use the same variable name with a different combination of uppercase and owercase letters to represent different variables.

[SAS documentation for VALIDVARNAME=](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lesysoptsref/p124dqdk8zoqu3n1r4nsfqu5vx52.htm).
___

>N.B. If you use characters other than the ones that are valid when `VALIDVARNME=V7`, then you must express the variable name as a name literal (?) and set `VALIDVARNME=ANY`.

>CAUTION: The `VALIDVARNAME=ANY` system option enables compatibility with other DBMS variable naming conventions.

### 2.3.5 VALIDMEMNAME= SYSTEM OPTION

You can use the `VALIDMEMNAME=` system option to specify rules for naming SAS datasets.

___
>Syntax. `VALIDMEMNAME=` system option
```
VALIDMEMNAME=COMPATIBLE (default)|EXTEND
```
`VALIDNMEMNAME=COMPATIBLE` specifies that a SAS dataset name must follow these rules:
- the length of the names can be up to 32 characters long;
- the first character must begin with a letter of the Latin alphabet (A-Z, either uppercase or lowercase) or an underscore (\_). Subsequent characters can be letters of the Latin alphabet, numerals or underscores.
- a dataset name can't contain blanks or special characters except for an underscore;
- a dataset name can contain mixed-case leters: you cannot use the same dataset name with a different combination of uppercase and owercase letters to represent different datasets.

`VALIDMEMNAME=EXTEND` specifies that a SAS dataset name must follow these rules:
- the name can include national characters;
- the name can include special characters, except for /\ \* ? " < > |: - characters
- the name can be up to 32 bytes long;
- the name cannot contain any null bytes;
- the name cannot begin with a blank or a period;
- leading and trailing blanks are deleted when the member is created;
- the name must contain at least one character. A name with all blanks is not permitted;
- a variable name can contain mixed-case leters: you cannot use the same variable name with a different combination of uppercase and owercase letters to represent different variables.

[SAS documentation for VALIDMEMNAME=](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lesysoptsref/n10nwm6blrcrtmn0zdcwyxlwxfjh.htm).
___

>N.B. If `VALIDMEMNAME=EXTEND`, SAS dataset names must be written as a SAS name literal.

>CAUTION: The `VALIDVMEMNAME=EXTEND` system option enables compatibility with other DBMS dataset naming conventions.

### 2.3.6 WHEN TO USE VALIDMEMNAME= SYSTEM OPTION

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
|Format             |affects how data values are displayed.| any SAS format. if no format is specified, the default is `BEST12.` for numeric variables and `$w.` for character variables|
|Informat           |reads data values in certain forms into standard SAS values|any SAS informat. if no informat is specified the default is `w.d` for numeric variables and `$w.` for character variables|
|Label              |refers to a descriptive label|up to 256 characters|

### 2.4.4 DATA PORTION
The data portion of a SAS dataset is a collection of data values that are arranged in a rectangular table.

#### Observations (rows)
>Defn. *Observations* (also called rows) in the dataset are collections of data values that usually relate to a single object.

#### Variables (columns)
>Defn. *Variables* (also called columns) in the dataset are collections of values that describe a particular characteristic.

#### Missing values
every variable and observation in a SAS dataset must have a value. if a data value is unknown for a particular observation, a missing value is recorded in the SAS dataset. A period (.) is the default value for a missing numeric value and a blank space is the default value for a missing character value.

### 2.4.5 SAS INDEXES
An index is a separate file that you can create for a SAS data file in order to provide direct access to a specific observation. Indexes can provide faster access to specific observations, particularly when you have a large dataset. the purpose of SAS indexes is to optimize `WHERE` expressions and to facilitate `BY`-group processing.

### 2.4.6 EXTENDED ATTRIBUTES
Extended attributes are user-defined metadata that is defined for a dataset or for a variable.

>Tip. you can use `PROC CONTENTS` to display dataset and variable extended attributes.

[SAS documentation for PROC CONTENTS](https://documentation.sas.com/doc/en/proc/3.2/n1hqa4dk5tay0an15nrys1iwr5o2.htm).

# CHAPTER 3 ACCESSING YOUR DATA
## 3.1 SAS LIBRARIES
>Defn. A *SAS library* is a collection of one or more SAS files, including SAS datasets, that are referenced and stored as a unit.

### 3.1.1 ASSIGNING LIBREFS
Often the first step in setting up your SAS session is to define the libraries. you can use programming statements to assign library names.

to reference a permanent SAS file:
1. assign a name (`LIBREF`) to the SAS library in which the file is stored
2. use the libref as teh first part of the two-level name (`LIBREF.FILENAME`) to reference the file within the library

a libref can be assigned to a SAS library using the `LIBNAME` statement. you can include the `LIBNAME` statement with any SAS program sot that the SAS library is assigned each time the program is submitted. using the the user interface, you can set up `LIBNAME` statements to automatically assigned when SAS starts.

___
Synthax. `LIBNAME` statement
```
LIBNAME libref engine “SAS-data-library”;
```
- *libref* is 1 to 8 characters long, begins with a letter, or underscore, and contains only letters, numbers or underscores
- *engine* is the name of a library engine that is supported in your operating environment
- *SAS-data-library* is the name of a SAS library in which SAS data files are stored

[SAS documentation for LIBNAME statement](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lestmtsglobal/n1nk65k2vsfmxfn1wu17fntzszbp.htm).
___

>N.B. For SAS 9, the default engine is V9, which works in all operating environments.

the `LIBNAME` statement below assigns the libref CERT to the SAS library `C:\Users\Student1\Cert` in the Windows environment. when the default engine is used, you do not have to specify it in the `LIBNAME` statement

```
libname cert “C:\Users\Student1\Cert”;
```

>Tip. You can use multiple `LIBNAME` statements to assign as many librefs as needed.

### 3.1.2 VERIFYING LIBREFS
after assigning a libref, it is a good idea to check the log to verify that the libref has been assigned successfully

### 3.1.3 HOW LONG LIBREFS REMAIN IN EFFECT
the `LIBNAME` statement is global which means that the librefs remain in effect until changed or canceled or until the SAS session ends

### 3.1.4 SPECIFYING TWO-LEVEL NAMES
after you assign a libref, you specify it as the first element in the two-level name for a SAS file
```
proc print data=cert.admit; (1)
run;
```

(1) in order for the print procedure to read `CERT.ADMIT`, you specify the two-level name of the file

### 3.1.5 REFERENCING THIRD-PARTY DATA
you can use the`LIBNAME` statement to reference not only SAS files but also files that were created with other sofware products, such as database management systems (DBMS).

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
- the descriptor information of for an individual SAS dataset

___
>Synthax. `PROC CONTENTS` step
```
proc contents data=SAS-file-specifications nods;
run;
```
- *SAS-file-specification* specifies an eintre library or a specific SAS dataset within a library. *SAS-file-specification* can take one of the following forms:
	- *libref.SAS-data-set* names one SAS dataset to process
	- *libref.\_all\_* requests a listing of all files in the library
- `NODS` suppresses the pringint of detailed information about each file when you specify `_ALL_`(you can specify `NODS` only when you specify `_ALL_`)

[SAS documentation for PROC CONTENTS](https://documentation.sas.com/doc/en/proc/3.2/n1hqa4dk5tay0an15nrys1iwr5o2.htm).
___

### 3.2.3 EXAMPLE: VIEW THE CONTENTS OF AN ENTIRE LIBRARY
to view the contents of an entire library, specify the `_ALL_` and `NODS` options in the `PROC CONTENTS` step (1).
```
proc contents data=cert._all_ nods; (1)
run;
```

### 3.2.4 EXAMPLE: VIEW DESCRIPTOR INFORMATION
to view the descriptor information for only a specific dataset, use the `PROC CONTENTS` step (1).
```
proc contents data=cert.amounts; (1)
run;
```


### 3.2.5 EXAMPLE: VIEW DESCRIPTOR INFORMATION USING THE VARNUM OPTION
by default, `PROC CONTENTS` lists variables alphabetically. to list variable names in the order of the logical position (or creation order) in the dataset, specify the `VARNUM` option in `PROC CONTENTS` (1).
```
proc contents data=cert.amounts varnum; (1)
run;
```

 