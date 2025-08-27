# SAS Certified Specialist Prep Guide

## CHAPTER 1 SETTING UP PRACTICE DATA

### 1.1 ACCESSING YOUR PRACTICE DATA

#### 1.1.1 REQUIREMENTS

To complete examples in the book, you must have access to \[SAS].

#### 1.1.2 PRACTICE DATA ZIP FILE

name:

#### 1.1.3 INSTRUCTIONS

1. navigate to [SAS support](https://www.support.sas.com), download and save the practice data zip file.
2. unzip the file and save it to a location that is accessible to \[SAS].
3. open the `cre8data.sas` program in \[SAS].
4. in the path macro variable, replace `/folders/myfolders` with the path to the cert folder and run the program:

```sas
%let path = /folders/myfolders/cert;
```

> \[!NOTE] the location of the path macro variable and the location of your downloaded SAS programs should be the same.

> \[!TIP] when you end your SAS session, the path macro variable in `cre8data.sas` resets. Run `libname.sas` from the cert folder to restore the libraries.

## CHAPTER 2 BASIC CONCEPTS

### 2.1 THE BASICS OF THE SAS LANGUAGE

#### 2.1.1 SAS STATEMENTS

> Defn. A _SAS statement_ is a type of SAS language element that is used to perform a particular operation in a SAS program or to provide information to a SAS program.

There are two important rules for writing SAS programs:

* a SAS statement ends with a semicolon; and
* a SAS statement usually start with a SAS keyword.

there are two types of SAS statements:

* statements that are used in DATA or PROC steps; and
* statements that are global in scope and can be used anywhere in a SAS program.

#### 2.1.2 GLOBAL STATEMENTS

> Defn. _Global statements_ are used anywhere in a SAS program and stay in effect until changed, canceled, or the SAS session ends.

#### 2.1.3 DATA STEP

> Defn. The _DATA step_ creates or modifies data.

* input: raw data, SAS dataset;
* output: SAS dataset, report.

> Defn. A _SAS dataset_ is a data file that is formatted in a way SAS can understand.

#### 2.1.4 PROC STEP

> Defn. The _PROC step_ analyzes data, produces output or manages SAS files.

* input: SAS dataset;
* output: a report or an updated SAS dataset.

#### 2.1.5 SAS PROGRAM STRUCTURE

A SAS program consists of a sequence of steps. A program can be any combination of DATA or PROC steps.

```sas
title1 "June Billing";                                              (1)

data work.junefee;
    set cert.admitjune;                                             (2)
    where age > 39;
run;                                                                (3)

proc print data = work.junefee;                                     (4)
run;
```

1. global statements are typically outside steps and don't require a RUN statement;
2. if a RUN or QUIT statement is not used, SAS assumes the beginning of a new step implies the end of the previous step.

#### 2.1.6 PROCESSING SAS PROGRAMS

When a SAS program is submitted for executing, SAS first validates the syntax then compiles the statements. At a step boundary (end of a step) SAS executes any statement that has not been previously executed and ends the step.

> \[!TIP] The RUN statement is not required between steps in a SAS program but it is a good practice because it makes the SAS program easier to read and the SAS log easier to understand when debugging.

#### 2.1.7 LOG MESSAGES

The SAS log collects messages about the processing of SAS programs and about any errors that occur.

#### 2.1.8 RESULTS OF PROCESSING

N/A

### 2.2 SAS LIBRARIES

#### 2.2.1 DEFINITION

> Defn. A _SAS library_ contains 1+ files that are defined, recognized and accessible by SAS and that are referenced and stored as a unit. One special type of file is called _catalog_. In SAS libraries, catalogs function much like subfolders for grouping other members.

#### 2.2.2 PREDEFINED SAS LIBRARIES

By default, SAS defines several libraries for you:

* SASHELP: a permanent library that contains sample data and other files that control how SAS works for you;
* SASUSER: a permanent library that contains SAS files in the PROFILE catalog and stores your personal settings; and
* WORK: a temporary library for files that don't need to be saved from session to session.

#### 2.2.3 DEFINING LIBRARIES

To define a library, you assign a library name to it and specify the location of the file, such as a directory path.

You can define SAS libraries using programming statements.

When deleting a SAS library, the pointer to the library is deleted and SAS no longer has access to the library. However, the contents of the library still exist in your operating environment.

#### 2.2.4 HOW SAS FILES ARE STORED

N/A

#### 2.2.5 STORING FILES TEMPORARILY OR PERMANENTLY

| TEMPORARY                                                                       | PERMANENT                                                                                               |
| ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| lasts only for the current session                                              | available to you during subsequent SAS sessions                                                         |
| if you don't specify a library name, the file is stored in the WORK SAS library | to store files permanently in a SAS library, specify a library name other than the default WORK library |
| : Table 2.2 Temporary and permanent SAS libraries                               |                                                                                                         |

### 2.3 REFERENCING SAS FILES

#### 2.3.1 REFERENCING PERMANENT SAS DATASETS

To reference a permanent SAS dataset in your SAS programs, use a two-level name consisting of the library name and the dataset name:

```sas
LIBREF.DATASET
```

In the two-level name LIBREF is the name of the SAS library that contains the dataset and DATASET is the name of the SAS dataset.

#### 2.3.2 REFERENCING TEMPORARY SAS FILES

To reference temporary SAS files, you can specify the default libref WORK, a period and the dataset name:

```sas
WORK.DATASET
```

Alternatively, you can use a one-level name (the dataset name's only) to reference a file in a temporary SAS library.

#### 2.3.3 RULES FOR SAS NAMES

By default, the following rules apply to the names of SAS datasets, variables and libraries:

* they must begin with a letter (A-Z, either uppercase or lowercase) or an underscore (\_);
* they can continue with any combination of numbers, letters, or underscores;
* they can be 1 to 32 characters long; and
* SAS library names (librefs) can be 1 to 8 characters long.

#### 2.3.4 VALIDVARNAME = SYSTEM OPTION

SAS has various rules for variable names. You set these rules using the `VALIDVARNAME =` system option.

***

**Syntax. VALIDVARNAME= system option**

```sas
validvarname = V7|upcase|any
```

* `VALIDVARNAME=V7` specifies that variable names must follow these rules:
  * SAS variable names can be up to 32 characters long;
  * the first character must begin with a letter of the Latin alphabet (A-Z, either uppercase or lowercase) or an underscore (\_). Subsequent characters can be letters of the Latin alphabet, numerals or underscores.
  * trailing blanks are ignored. the variable name alignment is left-adjusted;
  * a variable name can't contain blanks or special characters except for an underscore;
  * a variable name can contain mixed-case letters: you cannot use the same variable name with a different combination of uppercase and owercase letters to represent different variables;
  * do not assign variables the names of special SAS automatic variables (e.g \_N\_, \_ERROR\_) or variable list names (e.g. \_NUMERIC\_, \_CHARACTER\_, \_ALL\_).
* `VALIDVARNAME=UPCASE` specifies that variable names follow these rules:
  * the same rules as `VALIDVARNAME=V7`,
  * the variable name is uppercase, as in earlier versions of SAS.
* `VALIDVARNAME=ANY` specifies that variable names follow these rules:
  * the name can begin with or contain any character, including blanks, national characters, special characters, and multi-byte characters;
  * the name can be up to 32 bytes long;
  * the name cannot contain any null bytes;
  * the name must contain at least one character. A name with all blanks is not permitted;
  * a variable name can contain mixed-case letters: you cannot use the same variable name with a different combination of uppercase and owercase letters to represent different variables.

[SAS documentation for VALIDVARNAME = ](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lesysoptsref/p124dqdk8zoqu3n1r4nsfqu5vx52.htm).

***

> \[!NOTE] If you use characters other than the ones that are valid when `VALIDVARNME=V7`, then you must express the variable name as a name literal (?) and set `VALIDVARNME=ANY`.

> CAUTION: The `VALIDVARNAME=ANY` system option enables compatibility with other DBMS variable naming conventions.

#### 2.3.5 VALIDMEMNAME= SYSTEM OPTION

You can use the `VALIDMEMNAME=` system option to specify rules for naming SAS datasets.

***

**VALIDMEMNAME= system option**

```sas
validmemname = compatible (default)|extend
```

* `VALIDNMEMNAME=COMPATIBLE` specifies that a SAS dataset name must follow these rules:
  * the length of the names can be up to 32 characters long;
  * the first character must begin with a letter of the Latin alphabet (A-Z, either uppercase or lowercase) or an underscore (\_). Subsequent characters can be letters of the Latin alphabet, numerals or underscores.
  * a dataset name can't contain blanks or special characters except for an underscore;
  * a dataset name can contain mixed-case leters: you cannot use the same dataset name with a different combination of uppercase and owercase letters to represent different datasets.
* `VALIDMEMNAME=EXTEND` specifies that a SAS dataset name must follow these rules:
  * the name can include national characters;
  * the name can include special characters, except for /\ \* ? " < > |: - characters
  * the name can be up to 32 bytes long;
  * the name cannot contain any null bytes;
  * the name cannot begin with a blank or a period;
  * leading and trailing blanks are deleted when the member is created;
  * the name must contain at least one character. A name with all blanks is not permitted;
  * a variable name can contain mixed-case leters: you cannot use the same variable name with a different combination of uppercase and owercase letters to represent different variables.

[SAS documentation for VALIDMEMNAME = ](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lesysoptsref/n10nwm6blrcrtmn0zdcwyxlwxfjh.htm).

***

> \[!NOTE] If `VALIDMEMNAME = EXTEND`, SAS dataset names must be written as a SAS name literal.

> CAUTION: The `VALIDVMEMNAME = EXTEND` system option enables compatibility with other DBMS dataset naming conventions.

#### 2.3.6 WHEN TO USE VALIDMEMNAME = SYSTEM OPTION

Use the `VALIDMEMNAME=EXTEND` system option when the characters in SAS dataset name contains one of the following:

* international characters;
* characters supported by third-party databases;
* characters that are commonly used in a filename.

### 2.4 SAS DATASETS

#### 2.4.1 OVERVIEW OF DATASETS

> Defn. A _SAS dataset_ is a file that consists of two parts: a descriptor portion and a data portion. Sometimes a SAS dataset also points to one or more indezes, which enable SAS to locate rows in the data faster. Extended attributes are user-defined attributes that further define a SAS dataset.

#### 2.4.2 DESCRIPTIOR PORTION

The descriptor portion of a SAS dataset contains information about the dataset, including the following:

* the name of the dataset;
* the date and time the dataset was created;
* the number of observations;
* the number of variables.

#### 2.4.3 SAS VARIABLE ATTRIBUTES

The descriptor portion of a SAS dataset contains information about the properties of each variable in the dataset. The properties include:

| VARIABLE ATTRIBUTE | DEFINITION                                                                                                                                   | POSSIBLE VALUES                                                                                                         |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| Name               | identifies a variable. a variable name must conform to SAS naming rules                                                                      | any valid SAS name                                                                                                      |
| Type               | identifies a variable as numeric or character. Character variables can contain any values. numeric variables can contain only numeric values | numeric and character                                                                                                   |
| Length             | refers to the number of bytes used to store each of the variable's values in a SAS dataset.                                                  | 2 to 8 bytes for numeric variables, 1 to 32,767 bytes for character variables                                           |
| Format             | affects how data values are displayed.                                                                                                       | any SAS format. if no format is specified, the default is BEST12. for numeric variables and $w. for character variables |
| Informat           | reads data values in certain forms into standard SAS values                                                                                  | any SAS informat. if no informat is specified the default is w.d for numeric variables and $w. for character variables  |
| Label              | refers to a descriptive label                                                                                                                | up to 256 characters                                                                                                    |

#### 2.4.4 DATA PORTION

The data portion of a SAS dataset is a collection of data values that are arranged in a rectangular table.

**Observations (rows)**

> Defn. _Observations_ (also called rows) in the dataset are collections of data values that usually relate to a single object.

**Variables (columns)**

> Defn. _Variables_ (also called columns) in the dataset are collections of values that describe a particular characteristic.

**Missing values**

every variable and observation in a SAS dataset must have a value. if a data value is unknown for a particular observation, a missing value is recorded in the SAS dataset. A period (.) is the default value for a missing numeric value and a blank space is the default value for a missing character value.

#### 2.4.5 SAS INDEXES

An index is a separate file that you can create for a SAS data file in order to provide direct access to a specific observation. Indexes can provide faster access to specific observations, particularly when you have a large dataset. the purpose of SAS indexes is to optimize `WHERE` expressions and to facilitate `BY`-group processing.

#### 2.4.6 EXTENDED ATTRIBUTES

Extended attributes are user-defined metadata that is defined for a dataset or for a variable.

> \[!TIP] you can use PROC CONTENTS to display dataset and variable extended attributes.

[SAS documentation for PROC CONTENTS](https://documentation.sas.com/doc/en/proc/3.2/n1hqa4dk5tay0an15nrys1iwr5o2.htm).

## CHAPTER 3 ACCESSING YOUR DATA

### 3.1 SAS LIBRARIES

> Defn. A _SAS library_ is a collection of one or more SAS files, including SAS datasets, that are referenced and stored as a unit.

#### 3.1.1 ASSIGNING LIBREFS

Often the first step in setting up your SAS session is to define the libraries. you can use programming statements to assign library names.

to reference a permanent SAS file:

1. assign a name (LIBREF) to the SAS library in which the file is stored
2. use the libref as the first part of the two-level name (LIBREF.FILENAME) to reference the file within the library

A libref can be assigned to a SAS library using the LIBNAME statement. You can include the LIBNAME statement with any SAS program so that the SAS library is assigned each time the program is submitted. using the user interface, you can set up LIBNAME statements to automatically assigned when SAS starts.

***

**Syntax. LIBNAME statement**

```sas
libname libref engine “SAS-data-library”;
```

* _libref_ is 1 to 8 characters long, begins with a letter, or underscore, and contains only letters, numbers or underscores
* _engine_ is the name of a library engine that is supported in your operating environment
* _SAS-data-library_ is the name of a SAS library in which SAS data files are stored

[SAS documentation for LIBNAME statement](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lestmtsglobal/n1nk65k2vsfmxfn1wu17fntzszbp.htm).

***

> \[!NOTE] For SAS 9, the default engine is V9, which works in all operating environments.

the LIBNAME statement below assigns the libref CERT to the SAS library `C:\Users\Student1\cert` in the Windows environment (1). When the default engine is used, you do not have to specify it in the LIBNAME statement.

```sas
libname cert “C:\Users\Student1\cert”;                              (1)
```

> \[!TIP] You can use multiple LIBNAME statements to assign as many librefs as needed.

#### 3.1.2 VERIFYING LIBREFS

After assigning a libref, it is a good idea to check the SAS log to verify that the libref has been assigned successfully.

#### 3.1.3 HOW LONG LIBREFS REMAIN IN EFFECT

The LIBNAME statement is global which means that the librefs remain in effect until changed or canceled or until the SAS session ends.

#### 3.1.4 SPECIFYING TWO-LEVEL NAMES

After you assign a libref, you specify it as the first element in the two-level name for a SAS file (1).

```sas
proc print data = cert.admit;                                       (1)
run;
```

(1) In order for PROC PRINT to read CERT.ADMIT, you specify the two-level name of the file.

#### 3.1.5 REFERENCING THIRD-PARTY DATA

You can use the LIBNAME statement to reference not only SAS files but also files that were created with other software products, such as database management systems (DBMS).

> Defn. A _SAS engine_ is a set of internal instructions that SAS uses for writing to and reading from files in a SAS library or a thrid-party database.

SAS can read or write these files by using the appropriate engine for that file type.

#### 3.1.6 ACCESSING STORED DATA

if your site licences SAS/ACCESS software, you can use the LIBNAME statement to access data that is stored in a DBMS file.

### 3.2 VIEWING SAS LIBRARIES

#### 3.2.1 VIEWING LIBRARIES

N/A

#### 3.2.2 VIEWING LIBRARIES USING PROC CONTENTS

you can use the `CONTENTS` procedure to create SAS output that describes either of the following:

* the contents of a library
* the descriptor information for an individual SAS dataset

***

**Syntax. PROC CONTENTS step**

```sas
proc contents data = SAS-file-specifications nods;
run;
```

* _SAS-file-specification_ specifies an entire library or a specific SAS dataset within a library. _SAS-file-specification_ can take one of the following forms:
  * _libref.SAS-data-set_ names one SAS dataset to process
  * _libref.\_all\__ requests a listing of all files in the library
* _NODS_ suppresses the printing of detailed information about each file when you specify \_ALL\_(you can specify NODS only when you specify \_ALL\_)

[SAS documentation for PROC CONTENTS](https://documentation.sas.com/doc/en/proc/3.2/n1hqa4dk5tay0an15nrys1iwr5o2.htm).

***

#### 3.2.3 E.G. VIEW THE CONTENTS OF AN ENTIRE LIBRARY

to view the contents of an entire library, specify the \_ALL\_ and NODS options in the PROC CONTENTS step (1).

```sas
proc contents data = cert._all_ nods;                               (1)
run;
```

#### 3.2.4 E.G. VIEW DESCRIPTOR INFORMATION

to view the descriptor information for only a specific dataset, use the PROC CONTENTS step (1).

```sas
proc contents data = cert.amounts;                                  (1)
run;
```

#### 3.2.5 E.G. VIEW DESCRIPTOR INFORMATION USING THE VARNUM OPTION

by default, PROC CONTENTS lists variables alphabetically. to list variable names in the order of the logical position (or creation order) in the dataset, specify the VARNUM option in PROC CONTENTS (1).

```sas
proc contents data = cert.amounts varnum;                           (1)
run;
```

## CHAPTER 4 CREATING SAS DATASETS

### 4.1 REFERENCING AN EXTERNAL DATA FILE

#### 4.1.1 USING A FILENAME STATEMENT

Using the FILENAME statement to point to the location of the external file that contains the data.

Filerefs perform the same function as librefs: they temporarily point to a storage location for data. However, librefs reference SAS libraries, whereas filerefs reference external files.

***

**Syntax. FILENAME statement**

```sas
filename fileref “filename”;
```

* _fileref_ is a name that you associate with an external file. The name must be 1-8 characters long, begin with a letter or underscore, and contain only letters, numbers or underscores;
* _”filename”_ is the fully qualified name or location of the file.

[SAS documentation for FILENAME](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lestmtsglobal/p05r9vhhqbhfzun1qo9mw64s4700.htm)

***

#### 4.1.2 DEFINING A FULLY QUALIFIED FILENAME

The following FILENAME statement temporarily associates the fileref EXERCISE with the external file that contains the data from the exercise stress tests (1).

#### 4.1.3 REFERENCING A FULLY QUALIFIED FILENAME

When you associate a fileref with an individual external file, you specify the fileref in subsequent SAS statements and commands (2).

```sas
filename exercise “C:\Users\Student1\cert\exercise.txt”;            (1)

proc import
        datafile = exercise                                         (2)
        dbms = dlm
        out = work.exstress
        replace;
    getnames = no;
run;

proc print data = work.exstress;
run;
```

### 4.2 THE IMPORT PROCEDURE

#### 4.2.1 THE BASICS OF PROC IMPORT

The IMPORT procedure reads data from an external data source and writes it to a SAS dataset. You can import structured and unstructured data using PROC IMPORT. You can import delimited files (blank, comma or tab) along with Microsoft Excel files.

You can use the PROC IMPORT statements to do the following:

* indicate how many rows SAS scans for variables to determine their type, length, informat and format (GUESSINGROWS= statement). By default the procedure scans the first 20 rows.
* modify whether SAS extracts the variable names from the first row of the dataset (GETNAMES= statement ). By default the procedure expects the variable names to appear in the first row.
* indicate at which row SAS begins to read the data (DATAROW= statement).

PROC IMPORT writes information about the import to the SAS log. the SAS log displays the DATA step code that is generated by PROC IMPORT.

#### 4.2.2 PROC IMPORT SYNTAX

***

**Syntax. PROC IMPORT statement**

```sas
proc import
        datafile = “filename”|table = “tablename”
        out = <libref.SAS-dataset><SAS-dataset-options>
        <dbms = identifier>
        <replace>;
```

* _datafile = “filename”|”fileref”_ specifies the complete path and filename or fileref for the input PC file, spreadsheet or delimited external file.
  * Restrictions:
    * PROC IMPORT does not support device types or access methods for the FILENAME statement except for DISK.
    * PROC IMPORT can import data only if SAS supports the data type. SAS support numeric and character types of data but not binary objects. The procedure attempts to convert the data to the best of its ability. However conversion is not possible for some types.
  * Interactions:
    * By default, PROC IMPORT reads delimited files as varying record-length files. If your external file has a fixed-length format, use the FILENAME statement prior to PROC IMPORT to specify the input filename using the RECFM=F and LRECL= options.
    * The logical record length defaults to 256 unless you specify the LRECL= option in the FILENAME statement.
    * For delimited files, the first 20 rows are scanned to determine the variable attributes. All values are read in as character strings. If a Date and time format or a numeric informat can be applied to the data value, the type is declared as numeric. Otherwise, the type remains character.
* _out = \<libref.>SAS-dataset_ identifies the output SAS dataset. If the specified SAS dataset does not exist, PROC IMPORT creates it. A SAS dataset name can contain a single quotation mark when the VALIDMEMNAME=EXTEND system option is also specified (see section 2.3.5).
* _table = “tablename”_ specifies the name of the input DBMS table. You must include the quotation marks. Note, the DBMS table name might be case sensitive.
  * Requirement: when you import a DBMS table, you must specify the DBMS= option.
* _\<dbms=identifier>_ specifies the type of data to import. Here are the common DBMS identifiers that are included with Base SAS:
  * CSV - for a comma-separated file with a .csv extension, DBMS= is optional.
  * JMP - if you are using SAS 9.4 you can import JMP 7 or later files.
  * TAB - specify DBMS=DLM to import any other delimited file that doesn't end in .csv.
* _< replace >_ overwrites an existing SAS dataset. If you omit the REPLACE option, PROC IMPORT does not overwrite an existing dataset.
* _< SAS-dataset-options >_ specifies SAS dataset options.
  * Restriction: you cannot specify dataset options when importing delimited, comma-separated, or tab-delimited external files.

[SAS documentation for PROC IMPORT](https://documentation.sas.com/doc/en/proc/3.2/n1qn5sclnu2l9dn1w61ifw8wqhts.htm)

***

#### 4.2.3 E.G. IMPORTING AN EXCEL FILE WITH AN XLSX EXTENSION

```sas
options validvarname=v7;                                            (1)

proc import                                                         (2)
        datafile = “C:\Users\Student1\cert\boots.xlsx”
        dbms = xlsx
        out = work.bootsales
        replace;
    sheet = boot;                                                   (3)
    getnames = yes;                                                 (4)
run;

proc contents data = work.bootsales;                                (5)
run;

proc print data = work.bootsales;
run;
```

1. VALIDVARNAME=V7 statement forces SAS to convert spaces to underscores when it converts column names to variable names.
2. Specify the input file. When importing an Excel workbook, specify DBMS=XLSX.
3. Use the SHEET= option to import specific worksheets from an Excel workbook.
4. Set the GETNAMES=YES statement to generate variable names from the first row of data.
5. Use PROC CONTENTS to display the descriptor portion of the new SAS dataset.

#### 4.2.4 E.G. IMPORTING A DELIMITED FILE WITH A TXT EXTENSION

```sas
options validvarname=v7;

proc import
        datafile = “C:\Users\Student1\cert\delimiter.txt”
        dbms = dlm                                                  (1)
        out = work.mydata
        replace;
    delimiter = “&”;                                                (2)
    getnames = yes; 
run;

proc print data = work.mydata;
run;
```

1. If the delimiter is a character other than TAB or CSV, then the specify DBMS=DLM.
2. Specify an ampersand (&) for the DELIMITER= statement.

#### 4.2.5 E.G. IMPORTING A SPACE-DELIMITED FILE WITH A TXT EXTENSION

```sas
options validvarname=v7;

filename stdata “C:\Users\Student1\cert\state_data.txt” lrecl=100;  (1)
proc import
        datafile = stdata
        dbms = dlm
        out = work.states
        replace;
    delimiter = “ “;                                                (2)
    getnames = yes;
run;

proc print data = work.states;
run;
```

1. Specify the fileref and the location of the file. Specify the LRECL= system option if the file has a fixed-length format.
2. Specify a blank value for the DELIMITER statement.

#### 4.2.6 E.G. IMPORTING A COMMA-DELIMITED FILE WITH A CSV EXTENSION

```sas
options validvarname=v7;

proc import
        datafile = “C:\Users\Student1\cert\boots.csv”
        dbms = csv                                                  (1)
        out = work.shoes
        replace;
    getnames = no;                                                  (2)
run;

proc print data = work.shoes;
run;
```

1. Specify the input file. When the file type CSV, specify DBMS=CSV.
2. Set GETNAMES=NO to not use the first row of data as variable names.

#### 4.2.7 E.G. IMPORTING A TAB-DELIMITED FILE

```sas
proc import
        datafile = “C:\Users\Student1\cert\class.txt”
        dbms = tab                                                  (1)
        out = work.class
        replace;
    delimiter = ’09’x;                                              (2)
run;

proc print data = work.class;
run;
```

1. Specify the input file. When the file type TXT, specify DBMS=TAB.
2. Specify the delimiter. On an ASCII platform, the hexadecmial representation of a tab is ’09’x. On an EBCDIC platform, the hexademical presentation of a table is a ’05’x.

### 4.3 READING AND VERIFYING DATA

#### 4.3.1 VERIFYING THE CODE THAT READS THE DATA

Before you read a complete external file, you can verify the code that reads the data by limiting the number of observations that SAS reads: use the OPTIONS statement with the OBS= option before the PROC IMPORT (1).

```sas
options obs = 5;                                                    (1)
proc import
        datafile = “C:\Users\Student1\cert\boots.csv”
        dbms = csv
        out = work.shoes
        replace;
    getnames = no;
run;

proc print data = work.shoes;                                       (2)
run; 
```

#### 4.3.2 CHECKING DATA STEP PROCESSING

After PROC IMPORT runs the DATA step to read the data, messages in the SAS log verify that the data was read correctly.

#### 4.3.3 PRINTING THE DATASET

The messages in the SAS log indicate that the PROC IMPORT step correctly accessed the external data file. But it is a good idea to look at the five observations in the new dataset before reading the entire dataset. You can submit a PROC PRINT step to view the data (2).

#### 4.3.4 READING THE ENTIRE EXTERNAL FILE

To modify the PROC step to read the entire external file, restore the default value to the OBS= system option. To do this, set OBS=MAX and then resubmit the program (3).

```sas
options obs = max;                                                  (3)
proc import
        datafile = “C:\Users\Student1\cert\boots.csv”
        dbms = csv
        out = work.shoes
        replace;
    getnames = no;
run;
```

### 4.4 USING THE IMPORTED DATA IN A DATA STEP

#### 4.4.1 NAMING THE DATASET WITH THE DATA STATEMENT

The DATA statement indicates the beginning of the DATA step and names the SAS dataset(s) to be created.

***

**Syntax. DATA statement**

```sas
data SAS-dataset-1 <…SAS-dataset-n>;
```

* _SAS-dataset_ names (in the format _libref.filename_) the dataset(s) to be created.

***

#### 4.4.2 SPECIFYING THE IMPORTED DATA WITH THE SET STATEMENT

The SET statement specifies the SAS dataset that you want to use as input data for your DATA step.

**SET STATEMENT SYNTAX**

***

**DATA STEP FOR READING A SINGLE DATASET**

```sas
data SAS-dataset;
    set SAS-dataset;
    <…more SAS statements…>
run;
```

* _SAS-dataset_ in the DATA statement is the name of the SAS dataset to be created.
* _SAS-dataset_ in the SET statement is the name of the SAS dataset to be read.

***

**E.G. USING THE SET STATEMENT TO SPECIFY IMPORTED DATA**

The DATA statement tells SAS to name the new dataset BOOTS and store it in the the temporary library WORK (1). The SET statement in the DATA step specifies the output data set from PROC IMPORT (2). You can use several statemetns in the DATA step to subset your data (3).

```sas
proc import 
        datafile = “C:\certdata\boot.csv”
        out = work.shoes                                            (2)
        dbms = csv
        replace;
    getnames = no;
run;

data work.boots;                                                    (1)
    set work.shoes;                                                 (2)
    where var1 = “South America” or var1 = “Canada”;                (3)
run;
```

### 4.5 READING A SINGLE SAS DATASET TO CREATE ANOTHER

#### 4.5.1 E.G. READING A SAS DATASET

The dataset CERT.ADMIT contains health information about patients in a clinic, their activity level, height and weight. Suppose you want to create a subset of the data: a small dataset containing data about all the men in the group who are older than 50.

To create the dataset, you first reference the library in which CERT.ADMIT is stored (1). Then you must specify the name of the library in which you want to store the MALES dataset (2). Finally, you add statements to the DATA step to read your data and create a new dataset (3).

Add a PROC PRINT to see the output of the created dataset (4).

```sas
libname cert “C:\Users\Student\Cert\”;                              (1)
libname men50 “C:\Users\Student\Cert\Men50”;                        (2)

data men50.males;                                                   (3)
    set cert.admit;
    where sex = “M” and age > 50;
run;

proc print data = men50.males;                                      (4)
    title “Men Over 50”;
run; 
```

#### 4.5.2 SPECIFYING DROP= AND KEEP= DATASET OPTIONS

You can specify the DROP= and KEEP= dataset options anywhere you name a SAS dataset.

* if you never reference certain variables and you do not want them to appear in the new dataset, use a DROP= option in the SET statement (1). These variables are not available to be used by the DATA step.
* if you do need to reference a variable in the original dataset, you can specify the variable in the DROP= or KEEP= option in the DATA statement (2). When used in the DATA statement, the DROP= option simply drops the variables from the new dataset. However, they are still read from the original dataset and are available within the DATA step (3).

```sas
data cert.drug1h(drop=placebo);                                     (2)
    set cert.cltrials(drop=triglyc uric);                           (1)
    if placebo = “YES”;
run;

proc print data = cert.drug1h;
run;
```

### 4.6 READING MICROSOFT EXCEL DATA WITH THE XLSX ENGINE

#### 4.6.1 RUNNING SAS WITH MICROSOFT EXCEL

N/A

#### 4.6.2 STEPS FOR READING EXCEL DATA

To read the Excel workbook file, SAS must receive the following information in the DATA step:

* a libref to reference the Excel workbook to be read
* the name of the Excel worksheet that is to be read

```sas
libname certxl xlsx “C:\Users\Student1\cert\exercise.xlsx”;

proc contents data = cert._all_ nods;
run;

data work.stress;
    set cert.actlevel;
run;

proc print data = work.stress;
run;
```

The PROC CONTENTS and PROC PRINT statements are not requirements for reading Excel data and creating a SAS dataset. However, these statements are useful for confirming that your Excel data has sucessfully been read into SAS.

#### 4.6.3 THE LIBNAME STATEMENT

To assign a libref to a database, use the LIBNAME statement.

***

**Syntax. SAS/ACCESS LIBNAME statment**

```sas
libname <libref> xlsx <“physical-path-and-filename.xlsx”><options>;
```

* _xlsx_ is the SAS LIBNAME engine name for and XLSX file format. The SAS/ACCESS LIBNAME statement associates a libref with an XLSX engine that supports the connections to Microsoft Excel 2007, 2010 and later files. When reading XLSX data, the XLSX engine reads mixed data (columns containing numeric and character values) and converts it to character data values.
  * Important: the engine name XLSX is required.
* _“physical-path-and-filename.xlsx”_ is the physical location of the Excel workbook.
  * Note: the XLSX engine requires quotation marks for the _physical-path-and-filename.xlsx_.

***

#### 4.6.4 REFERENCING AN EXCEL WORKBOOK

**REFERENCING AND EXCEL WORKBOOK IN A DATA STEP**

**OVERVIEW**

To read in a workbook, create a libref to point to the workbook’s location (1).

#### 4.6.5 REFERENCING AN EXCEL WORKBOOK IN A DATA STEP

**SET STATEMENT**

Use the SET statement to indicate which worksheet in the Excel file you want to read (2).

```sas
libname certxl xlsx “C:\Users\Student1\cert\exercise.xlsx”;         (1)

data work.stress;
    set certxl.activitylevels;                                      (2)
run;
```

**NAME LITERALS**

Name literals are required with the XLSX engine only when the worksheet name contains a special character or spaces.

> Defn. A SAS _name literal_ is a name token that is expressed as a string within quotation marks, followed by the uppercase or lowercase letter _n_.

In the case of Excel files, the name literal tells SAS to allow special character $ in the dataset name (1).

```sas
libname certxl xlsx “C:\Users\Student1\cert\stock.xlsx”;

data work.bstock;
    set certxl.’boots stock$’n;                                     (1)
run;

proc print data = work.bstock;
run;
```

#### 4.6.6 PRINTING AN EXCEL WORKSHEET AS A SAS DATASET

After using the DATA step to read in the Excel data and create a SAS dataset, you can use PROC PRINT to produce a report that displays the dataset values (2).

In the example below, the PROC PRINT statement refers to the worksheet directly and prints the contents of the Excel worksheet that was referenced by the SAS/ACCESS LIBNAME statement.

```sas
libname certxl xlsx “C:\Users\Student1\cert\stock.xlsx”;

proc print data = certxl.’boots stock$’n;
run;

```

### 4.7 CREATING EXCEL WORKSHEETS

In addition to reading Microsoft Excel data, SAS can also create Excel worksheets from SAS datasets.

* If the Excel workbook does not exist, SAS creates it.
* If the Excel worksheet within the workbook does not exist, SAS creates it.
* if the Excel workbook and worksheet already exist, then SAS overwrites the existing Excel workbook and worksheet.

```sas
libname excelout xlsx “C:\Users\Student1\cert\newExcel.xlsx”;

data excelout.HighStress;
    set cert.stress;
run;
```

### 4.8 WRITING OBSERVATIONS EXPLICITLY

To override the default way in which the DATA step writes observations to output, you can use and OUTPUT statement in the DATA step. Placing an explicit OUTPUT statement in a DATA step overrides the implicit output at the end of the DATA step. The observations are added to a dataset only when the explicit OUTPUT statement is executed.

***

**Syntax. OUTPUT Statement**

```sas
output <SAS-dataset(s)>;
```

* _SAS-dataset(s)_ names the dataset(s) to which the observation is written. All dataset names that are specified in the OUTPUT statement must all appear in the DATA statement.

Using an OUTPUT statement without a following dataset name causes the current observation to be written to all datasets that are specified in the DATA statement.

***

With an OUTPUT statement, your program now writes a single observation to output, observation 5 (1).

```sas
data work.usa5;
    set cert.usa(keep=manager wagerate);
    if _n_ = 5 then output;                                         (1)
run;

proc print data = work.usa5;
run;
```

Suppose your DATA statement contains two dataset names, and you include an output statement that references only one of the datasets. The DATA step creates both datasets, but only the dataset that is specified in the OUTPUT statement contains output (1);

```sas
data work.empty work.full;
    set cert.usa;
    output work.full;                                               (1)
run;
```

## CHAPTER 5 IDENTIFYING AND CORRECTING SAS LANGUAGE ERRORS

### 5.1 ERROR MESSAGES

#### 5.1.1 TYPES OF ERRORS

SAS can detect several types of errors. Here are two common ones:

* syntax errors: they occur when program statements do not conform to the rules of the SAS language
* semantic errors: they occur when you specify a language element that is not valid for a particular usage

#### 5.1.2 SYNTAX ERRORS

When you submit a program, SAS scans each statement for syntax errors, and then executes the step if no syntax errors are found, and repeats the process. Syntax errors, such as misspelled keywords, generally prevent SAS from executing the step in which the error occurred.

When a program that contains an error is submitted, messages about the error appear in the SAS log with the following:

* displays the word ERROR
* identifies the possible location of the error
* gives an explanation for the error

#### 5.1.3 E.G. SYNTAX ERROR MESSAGES

The following program contains a syntax error:

```sas
data work.admitfee;
    set cert.admit;
run;

proc prin data = work.admitfee;                                     (1)
    var id name actlevel fee;
run;
```

(1) the SAS keyword PRINT in PROC PRINT is spelled incorrectly. As a result, the PROC step fails.

> \[!TIP] Errors in your statements or data might not be evident when you look at results in the Results viewer. Review the messages in the SAS log each time you submit a SAS program.

In addition to correcting spelling mistakes, you might need to resolve other common syntax errors such as:

* missing RUN statement
* missing semicolon
* unbalanced quotation mark

You might also need to correct a semantic error such as:

* invalid option

### 5.2 CORRECTING COMMON ERRORS

#### 5.2.1 THE BASICS OF ERROR CORRECTION

To correct simple errors, type over the incorrect text, delete the text or insert text.

#### 5.2.2 RESUBMITTING A REVISED PROGRAM

After correcting your program, you can resubmit it.

#### 5.2.3 THE BASICS OF LOGIC ERRORS

**THE PUTLOG STATEMENT**

> Defn. A _logic error_ occurs when the program statement execute, but produce incorrect results.

Because no notes are written to the log, logic errors are often difficult to detect. Use the PUTLOG statement in the DATA step to write messages to the SAS log to help identify logic errors.

***

**Syntax. PUTLOG statement**

```sas
putlog "message";
```

* _message_ specifies the message you want to write to the SAS log. It can include character literals, variable names, formats and pointer controls.

> \[!NOTE] You can precede your message text with WARNING, MESSAGE or NOTE to better identify the output in the SAS log.

***

The PUTLOG statement can be used to write to the SAS log in both batch and interactive modes. If an external file is open for output (e.g. using a DATA step to create an Excel worksheet), use the PUTLOG statement to ensure that debugging messages are written to the SAS log and not the external file.

**TEMPORARY VARIABLES**

The temporary variables \_N\_ and \_ERROR\_ can be helpful when you debug a DATA step:

* \_N\_: the number of times the DATA step interates
  * debugging use: displays debugging messages for a specified number of iterations of the DATA step
* \_ERROR\_: initialized to 0, set to 1 when an error occurs
  * debugging use: displays debugging messages when an error occurs

**E.G. THE DATASET PRODUCES WRONG RESULTS BUT THERE ARE NO ERROR MESSAGES**

The program below is designed to select students whose average score is below 70. Although the program produces incorrect results, there are no error messages in the SAS log.

```sas
data work.grades;
    set cert.class;

    homework = homework * 2;
    averageScore = mean(score1 + score2 + score3 + homework);

    if averageScore < 70;
run;
```

A glance at the dataset shows that there should be students whose mean scores are below 70. Use the PUTLOG statement to determine where the DATA step received incorrect instructions (1):

```sas
data work.grades;
    set cert.class;

    homework = homework * 2;
    averageScore = mean(score1 + score2 + score3 + homework);       (2)

    putlog name= score1= score2= score3= homework= averagescore=;   (1)

    if averageScore < 70;
run;
```

Looking at the SAS log, you can see the result of the PUTLOG statement. The values of AVERAGESCORE are incorrect. They are above the available maximum grade.

There is a syntax error in the line that computes AVERAGESCORE: instead of commas separating the four score variables in the MEAN function, there are plus signs (2). Since functions can contain arithmetic expressions, SAS simply added the four variables together, as instructed, and computed the mean of a single number. You can fix the error, replace the plus signs in the MEAN function with commas (3), remove the PUTLOG statement and use a PROC PRINT statement to view your results.

```sas
data work.grades;
    set cert.class;

    homework = homework * 2;
    averageScore = mean(score1, score2, score3, homework);          (3)

    if averagescore < 70;
run;

proc print data = work.grades;
run;
```

#### 5.2.4 PUT STATEMENT

**SYNTAX**

When the source of the program error is not apparent, you can use the PUT statement to examine variable values and to print your own message in the SAS log. For diagnostic purposes, you can use IF-THEN/ELSE statements to conditionally check for values.

***

**Syntax. PUT statement**

```sas
put specification(s);
```

* _specification(s)_ specifies what is written, how it is written and where it is written.

***

**E.G. USING THE PUT STATEMENT**

```sas
data work.test;
    set cert.loan01;

         if code = '1' then type = 'variable';
    else if code = '2' then type = 'fixed';
    else                    type = 'unknown';

    if type = 'unknown' then put 'My NOTE: invalid value: ' code=;  (4)
run;
```

If TYPE contains the value `unknown` then the PUT statement writes a message to the SAS log (4).

**E.G. CHARACTER STRINGS**

You can use a PUT statement to specify a character string to identify your message in the SAS log (5):

```sas
data work.loan01;
    set cert.loan;

         if code = '1' then type = 'variable';
    else if code = '2' then type = 'fixed';
    else                    type = 'unknown';

    put 'MY NOTE: The condition was met.';                          (5)
run;
```

**E.G. DATASET VARIABLES**

You can use a PUT statement to specify one or more dataset variables to be examined for that iteration of the DATA step (6).

> \[!NOTE] When you write a variable in the PUT statement, only its value is written to the SAS log. To write both the variable name and its value to the log, add an equal sign to the variable name (6).

```sas
data work.loan01;
    set cert.loan;

         if code = '1' then type = 'variable';
    else if code = '2' then type = 'fixed';
    else                    type = 'unknown';

    put 'MY NOTE: Invalid Value: ' code= type=;                     (6)
```

**E.G. CONDITIONAL PROCESSING**

YOu can use a PUT statement with conditional processing to flag program errors or data that is out of range (7).

```sas
data work.newcalc;
    set cert.loan;

    if rate > 0 then interest = amount * (rate/12);
    else put 'DATA ERROR: ' rate= _n_=;                             (7)
run;
```

#### 5.2.5 MISSING RUN STATEMENT

Each step in a SAS program is compiled and executed independently from every other step. As a step is compiled, SAS recognizes the end of the current step when it encounters one of the following:

* a DATA or PROC statement, which indicates the beginning of a new step
* a RUN or QUIT statement, which indicates the end of the current step

> \[!NOTE] The QUIT statement ends some SAS procedures.

```sas
data work.admitfee;
    set cert.admit;

proc print data = work.admitfee;
    var id name actlevel fee;
                                                                    (8)
```

(8) The RUN statement is necessary at the end of the last step. If the RUN statement is omitted from the last step, the program might not complete processing and might produce unexpected results.

> \[!NOTE] Although omitting a RUN statement is not technically an error it can produce unexpected results. A best practice is to always end a step with a RUN statement.

#### 5.2.6 MISSING SEMICOLON

One of the most common errors is a missing semicolon at the end of a statement (9).

```sas
data work.admitfee;
    set cert.admit;
run;

proc print data = work.admitfee                                     (9)
    var id name actlevel fee;
run;
```

When you omit a semicolon, SAS reads the statement that lacks the semicolon, along with the following statement, as one long statement.

#### 5.2.7 CORRECTING THE ERROR: MISSING SEMICOLON

1. Find the statement that lacks the semicolon. You can usually find it by looking at the underscored keyword in the error message and working backward.
2. Add a semicolon in the appropriate location.
3. Resubmit the corrected program.
4. Check the SAS log again to make sure there are no other errors.

#### 5.2.8 UNBALANCED QUOTATION MARKS

Some syntax errors such as the missing quotation mark (10) causes SAS to misinterpret the statements in your program.

```sas
data work.admitfee;
    set cert.admit;
    where actlevel = 'HIGH;                                         (10)
run;

proc print data = work.admitfee;
    var id name actlevel fee;
run;
```

When the program is submitted, SAS is unable to resolve the DATA step. Sometimes a warning appears in the SAS log that indicates the following:

* a quoted string has become too long
* a statement that contains quotation marks is ambiguous because of invalid options or unquoted text.

When you have unbalanced quotation marks, SAS is often unable to detect the end of the statement in which it occurs. Simply add the balancing quotation mark and resubmit the program. However, in some environments, this technique usually does not correct the error. SAS still considers the quotation marks to be unbalanced.

Therefore, you need to resolve the unbalanced quotation mark by canceling the submitted statements before you recall, correct and resubmit the program.

#### 5.2.9 CORRECTING THE ERROR IN THE WINDOWS OPERATING ENVIRONMENT

N/A

#### 5.2.10 CORRECTING THE ERROR IN THE UNIX ENVIRONMENT

N/A

#### 5.2.11 CORRECTING THE ERROR IN THE Z/OS OPERATING ENVIRONMENT

1. Submit an asterisk followed by a single quotation mark, a semicolon, and a RUN statement.

```sas
    *'; run;
```

2. Delete the line that contains the asterisk followed by a single quotation mark, a semicolon, and a RUN statement.
3. Insert the missing quotation mark in the appropriate place.
4. Submit the corrected program.

> \[!TIP] You can also use the above method in the Windows and UNIX operating environments.

#### 5.2.12 SEMANTIC ERROR: INVALID OPTION

An invalid option error occurs when you specify an option that is not valid in a particular statement (11).

```sas
data work.admitfee;
    set cert.admit;
    where weight > 180 and (actlevel = 'MID' or actlevel = 'LOW');
run;

proc print data = cert.admit keylabel;                              (11)
    label actlevel = 'Activity Level';
run;
```

When a SAS statement that contains an invalid option is submitted, a message appears in the SAS log indicating that the option is not valid or not recognized.

#### 5.2.13 CORRECTING THE ERROR: INVALID OPTION

1. Remove or replace the invalid option, and check your statement syntax as needed.
2. Resubmit the corrected program.
3. Check the SAS log again to make sure there are no more errors.

## CHAPTER 6 CREATING REPORTS

### 6.1 CREATING A BASIC REPORT

To produce a simple list report, you first reference the library where your SAS dataset is stored. You can also set system options to control the appearance of your reports. Then you submit a PROC PRINT step.

***

**Syntax. PROC PRINT step**

```sas
proc print data=sas-dataset;
run;
```

* _SAS-dataset_ is the name of the SAS dataset to be printed.

***

```sas
libname cert "C:\Users\Student1\Cert";

proc print data = cert.therapy;
run;
```

Notice the layout of the default report:

* all observations and variables in the dataset are printed
* a column of observation numbers appears on the far left
* variable and observations appear in the order in which they occurr in the dataset.

### 6.2 SELECTING VARIABLES

#### 6.2.1 THE VAR STATEMENT

You can select and control the order in which variables appear in a PROC PRINT report by using a VAR statement.

***

**Syntax. VAR statement**

```sas
var variables(s);
```

* _variable(s)_ is one or more variable names, separated by blanks.

***

The following VAR statement specifies that only the variables AGE, HEIGHT, WEIGHT and FEE be printed, in that order (1):

```sas
proc print data = cert.admit;
    var age height weight fee;                                      (1)
run; 
```

#### 6.2.2 REMOVING THE OBS COLUMN

In addition to selecting variables, you can suppress observation numbers.

To remove the OBS column, specify the NOOBS option in the PROC PRINT statement (2).

```sas
proc print data = cert.admit noobs;
    var age height weight fee;                                      (2)
run; 
```

### 6.3 IDENTIFYING OBSERVATIONS

#### 6.3.1 USING THE ID STATEMENT IN PROC PRINT

The ID statement identifies observations using variable values such as an identification number, instead of observation numbers.

***

**Syntax. ID statement in the PRINT procedure**

```sas
id variable(s);
```

* _variable(s)_ specifies one or more variables to print whose value is used instead of observation number at the begiining of each row of the report.

***

#### 6.3.2 E.G. ID STATEMENT

The OBS column in the output is replaced with teh variable values for IDNUMB and LASTNAME (3).

```sas
proc print data = cert.reps;
    id idnum lastname;                                              (3)
run;
```

#### 6.3.3 E.G. ID AND VAR STATEMENTS

You can use the ID and VAR statements together to control which variables are printed and in which order. If a variable in the ID statement also appears in the VAR statement, the output contains two columns for that variable.

```sas
proc print data = cert.reps;
    id idnum lastname;
    var idnum sex jobcode salary;
run;
```

#### 6.3.4 SELECTING OBSERVATIONS

By default, a PROC PRINT step lists all the observations in a dataset. You can control which observations are printed by adding a WHERE statement to your PROC PRINT step (4). If multiple WHERE statements are issued, only the last statement is processed;

***

**Syntax. WHERE statement**

```sas
where where-expression;
```

* _where-expression_ specifies a condition for selecting observations.

***

```sas
proc print data = cert.admit;
    var age height weight fee;
    where age > 30;                                                 (4)
run;
```

#### 6.3.5 SPECIFYING WHERE EXPRESSIONS

In the WHERE statement, you can specify any variable in the SAS dataset, not just the variables that are specified in the VAR statement. The WHERE statement works for both character and numeric variables.

You use the following comparison operators to express a condition in the WHERE statement:

| SYMBOL        | MEANING                                                        | SAMPLE PROGRAM CODE                |
| ------------- | -------------------------------------------------------------- | ---------------------------------- |
| = or eq       | equal to                                                       | `where name = 'Jones, C.';`        |
| ^= or ne      | not equal to                                                   | `where temp ne 212;`               |
| > or gt       | greater than                                                   | `where income > 20000;`            |
| < or lt       | less than                                                      | `where partno lt "BG05";`          |
| >= or ge      | greater than or equal to                                       | `where id >= '1543';`              |
| <= or le      | less than or equal to                                          | `where pulse le 85;`               |
| ? or contains | includes the specified substring                               | `where firstname ? 'Jon';`         |
| & or and      | if both expressions are true, the compound expression is true  | `where age <= 55 and pulse > 75;`  |
| \| or or      | if either expressions is true, the compound expression is true | `where area = 'A' or region = 'S'` |

#### 6.3.6 USING THE CONTAIN OPERATOR

The CONTAINS operator selects observations that includes the specified substring.

#### 6.3.7 SPECIFYING COMPOUND WHERE EXPRESSIONS

You can also use WHERE statements to select observations that meet multiple conditions. To link a sequence of expressions into compound expressions, you use logical operators.

#### 6.3.8 E.G. WHERE STATEMENTS

* You can use compound expressions linke these in your WHERE statements:

```sas
where age <=55 and pulse > 75;
where area = 'A' or region = 'S';
where ID > '1050' and state = 'NC';
```

* When you test for multiple value of the same variable, you specify the variable in each expression:

```sas
where actlevel = 'LOW' or actlevel = 'MOD';
where fee = 124.80 or fee = 178.20;
```

* You can use the IN operator as a convenient alternative:

```sas
where actlevel in ('LOW', 'MOD');
where fee in (124.80, 178.20);
```

* To control how compound expressions are evaluated, you can use parentheses:

```sas
where (age <= 55 and pulse > 75) or area = 'A';
where age <= 55 and (pulse > 75 or area = 'A');
```

#### 6.3.9 USING SYSTEM OPTIONS TO SPECIFY OBSERVATIONS

SAS system options set the preferences for a SAS session. You can use the FIRSTOBS= and OBS= options in an OPTIONS statement to specify the observations to process from SAS datasets.

***

**Syntax. FIRSTOBS= and OBS= options in an OPTIONS statement**

```sas
firstobs=n
obs=n
```

* for FIRSTOBS=, _n_ specifies the number of the _first_ observation to process. By default, FIRSTOBS=1;
* for OBS=, _n_ specifies the number of the _last_ observation to process. By default, OBS=MAX.

***

To reset the number of the last observation to process, you can specify the default value of OBS= in the OPTIONS statement.

```sas
options obs = max;
```

> \[!CAUTION] Each of these options applies to every input dataset that is used in a program or a SAS process because a sytem option sets the preference for the SAS session.

#### 6.3.10 E.G. FIRSTOBS= AND OBS= OPTIONS

```sas
options firstobs = 10;                                              (5)

proc print data = cert.heart;
run;
```

The FIRSTOBS=10 option enables SAS to read the 10th observation of the dataset first and read through the last observation (5).

```sas
options firstobs = 1 obs = 10;                                      (6)

proc print data = cert.heart;
run;
```

The FIRSTOBS=1 option resets the FIRSTOBS= option to the default value and reads the first observations in the dataset. When you specify OBS=10 in the OPTIONS statement, SAS reads through the 10th observation.

```sas
options firstobs = 10 obs = 15;                                       (7)

proc print data = cert.heart;
run;
```

When you set FIRSTOBS=10 and OBS=15, the program processes only observations 10 through 15 (7).

#### 6.3.11 USING FIRSTOBS= AND OBS= FOR SPECIFIC DATASETS

Using the FIRSTOBS= or OBS= system options determines the first or last observation, respectively, that is read for all steps for the duration of your current SAS session or unitl you change the setting. However, you can still do the following:

* override these options to a specific dataset only
* apply these options to a specific dataset only

To affect any single file, use FIRSTOBS= or OBS= as dataset options instead of using them as system options.

> \[!TIP] A FIRSTOBS= or OBS= specification from a dataset option overrides the corresponding FIRSTOBS= or OBS= system option, but only for that DATA step.

#### 6.3.12 E.G. FIRSTOBS= AND OBS= AS DATASET OPTIONS

As shown in the previous example (7), the program processes only observations 10 through 15, for a total of 6 observations.

You can create the same output by specifying FIRSTOBS= and OBS= as dataset options, as follows. The dataset options override the system options for this instance only (8).

```sas
options firstobs = 10 obs = 15;
proc print data = clinic.heart(firstobs=20 obs=30);                 (8)
run;
```

### 6.4 SORTING DATA

#### 6.4.1 THE SORT PROCEDURE

By default, PROC PRINT lists observations in the order in which they appear in your dataset. To sort your report based on valies of a variable, you must use PROC SORT to sort your data before unsing the PRINT procedure to create reports from the data.

The SORT procedure does the following:

* rearranges the observations in a SAS dataset
* creates a new SAS dataset that contains the rearranged observations
* replaces the original SAS dataset by default
* can sort on multiples variables
* can sort in ascending or descending order
* treats missing values as the smallest possible values

> \[!NOTE] PROC SORT does not generate printed output.

***

**Syntax. PROC SORT step**

```sas
proc sort data = SAS-dataset <out=SAS-dataset>;
    by <descending> by-variable(s);
run;
```

* the _DATA=_ option specifies the dataset to be read
* the _OUT=_ option creates an output dataset that contains the data in sorted order
* the _by-variable(s)_ in the required BY statement specifies one or more variables whose values are used to sort the data
* the _DESCENDING_ option in the BY statement sorts observations in descending order. If you have more than one variable in the BY statement, DESCENDING applies only to the variable that immediately follows it.

***

> \[!CAUTION] If you do use the OUT= option, PROC SORT overwrites the dataset that is specified in the DATA= option.

#### 6.4.2 E.G PROC

```sas
proc sort data = cert.admit out = work.wgtadmit;                    (9)
    by weight age;
run;

proc print data = work.wgtadmit;
    var weight age height fee;
    where age > 30;
run;
```

The PROC SORT step sorts the permanent SAS dataset CERT.ADMIT by the values of AGE within values of WEIGHT. The OUT= option creates the temporary SAS dataset WORKWGTADMIT (9).

Adding the DESCENDING option to the BY statement sort observations in ascending order of AGE within descending order of WEIGHT (10).

```sas
proc sort data = cert.admit out = work.wgtadmit;                    (10)
    by descending weight age;
run;

proc print data = work.wgtadmit;
    var weight age height fee;
    where age > 30;
run;
```

### 6.5 GENERATING COLUMN TOTALS

#### 6.5.1 THE SUM STATEMENT

To produce column totals for numeric variables, you cna list the variables to be summed in a SUM statement in your PROC PRINT step

***

**Syntax. SUM statement**

```sas
sum variables(s);
```

* _variable(s)_ is one or more numeric variable names, separated by blanks

***

The SUM statement in the following PROC PRINT step requests column totlas for the variable BALANCEDUE (11):

```sas
proc print data = cert.insure;
    var name policy balancedue;
    where pctinsured < 100;
    sum balancedue;                                                 (11)
run;
```

Column totals appear at the end of the report in the same format as the values of the variables.

> \[!NOTE] If you specify the same variable in the VAR statement and the SUM statement, you can omit the variable name in the VAR statement.

#### 6.5.2 CREATING SUBTOTALS FOR VARIABLE GROUPS

You might also want to group and subtotal numeric variables. You group variables using the BY statement. SAS calls these groups BY groups. You can use the SUM statement to create a subtotal value for variables in the group.

***

**Syntax. BY statement in the PRINT procedure**

```sas
by <descending> by-variable1 <...<descending><by-variablen>> <notsorted>;
```

* _by-variable_ specifies a variable that the procedure uses to form BY groups. You can specify more than one variable, separated by blanks
* the DESCENDING option specifies that the dataset is sorted in descending order by the variable that immediately follows
* the NOTSORTED option specifies that the observations in the dataset that have the same BY values are group together but are not necessarily sorted in alphabetical or numeric order.

***

> \[!NOTE] THE NOTSORTED option applies to all of the varaibles in the BY statement.

When you sort the dataset, you must used the same BY variable in PROC SORT as you do in PROC PRINT.

#### 6.5.3 E.G. SUM STATEMENT

The following example uses the SUM statement and the BY statement to generate subtotals for each BY group and a sum of all the subtotals of the FEE variable.

```sas
proc sort data = cert.admit out = work.activity;
    by actlevel;
run;

proc print data = work.activity;
    var age height weight fee;
    where age > 30;
    sum fee;
    by actlevel;
run;
```

#### 6.5.4 CREATING A CUSTOMIZED LAYOUT WITH BY GROUPS AND ID VARIABLES

In the previous example, you might have noticed the redundant information for the BY-variable. In the PROC PRINT the BY variable ACTLEVEL is identified both before the BY group and for the subtotal.

To show the BY variable heading only once, use an ID statement and a BY statement together with the SUM statement. Here are the results when an ID statement specifies the same variable as the BY statement:

* the OBS column is suppressed
* the ID or BY variable is printed in the left-most column
* each ID or BY value is printed only at the start of each BY group and on the line that contains that group's subtotal

#### 6.5.5 E.G. ID, BY AND SUM STATEMENTS

```sas
proc sort data = cert.admit out = work.activity;
    by actlevel;
run;

proc print data = work.activity;
    var age height weight fee;
    where age > 30;
    sum fee;
    by actlevel;
    id actlevel;
run;
```

#### 6.5.6 CREATING SUBTOTALS ON SEPARATE PAGES

As another enhacement to your PROC PRINT report, you can request that each BY group be printed on a separate page by using the PAGEBY statement.

***

**Syntax. PAGEBY statement**

```sas
pageby by-variable;
```

* _by-variable_ identifies a variable that appears in the BY statement in the PROC PRINT step. PROC PRINT begins printing a new page if the value of the BY variable changes or if the value of any BY variable that precedes it in the BY statement changes.

***

> \[!NOTE] The variable specified in the PAGEBY statement must also be specified in the BY statement in the PROC PRINT step.

#### 6.5.7 E.G. PAGEBY STATEMENT

The following example used the PAGEBY statement to print the BY groups for the variable ACTLEVEL on separate pages (12).

```sas
proc sort data = cert.admit out = work.activity;
    by actlevel;
run;

proc print data = work.activity;
    var age height weight fee;
    where age > 30;
    sum fee;
    by actlevel;
    id actlevel;
    pageby actlevel;                                                (12)
run;
```

### 6.6 SPECIFYING TITLES AND FOOTNOTES IN PROCEDURE OUTPUT

#### 6.6.1 TITLE AND FOOTNOTE STATEMENTS

To make your report more meaningful and self-explanatory, you can assign up to 10 titles with procedrue output by using TITLE statements before the PROC step. Likewise, you can specify up to 10 footnotes by using FOOTNOTE statements before the PROC step.

> \[!TIP] Because TITLE and FOOTNOTE statements are global statements, place them anywhere within or before the PRINT procedure. Titles and footnotes are assigned as soon TITLE or FOOTNOTE statements are read; they apply to all subsequent output.

***

**Syntax. TITLE, and FOOTNOTE statements**

```sas
title<n> 'text';
footnote<n> 'text';
```

* _n_ is a number from1 to 10 that specifies the title or footnote line
* _'text'_ is the actual title or footnote to display

The keyword TITLE is equivalent to TITLE1. Likewise, FOOTNOTE is equivalent to FOOTNOTE1. If you do not specify a title, the default title is 'The SAS System'.

#### 6.6.2 E.G. CREATING TITLES

In the following example, the two TITLE statements are specified for lines 1 and 3 (13). These two TITLE statements define titles for the PROC PRINT output. YOu can create a blank like between two titles by skipping a number in the TITLE statement.

```sas
title1 'Heart Rates for Patients with:';
title3 'Increased Stress Tolerance Levels';                         (13)

proc print data = cert.stress;
    var resthr maxhr rechr;
    where tolerance = 'I';
run;
```

#### 6.6.3 E.G. CREATING FOOTNOTES

In the following example, the two FOOTNOTE statements are specified for lines 1 and 3 (14). These two FOOTNOTE statements define footnotes for the PROC PRINT output. Since there is no FOOTNOTE2, a blank line is inserted between FOOTNOTE1 and FOOTNOTE3 in the output.

```sas
footnote1 'Data from Treadmill Tests';
footnote3 '1st Quarter Admissions';                                 (14)

proc print data = cert.stress;
    var resthr maxhr rechr;
    where tolerance = 'I';
run;
```

#### 6.6.4 MODIFYING AND CANCELING TITLES AND FOOTNOTES

As global statements, the TITLE and FOOTNOTE statements remain in effect until you modify the statements, cancel the statements or end your SAS session. In the following example, the titles and footnoes that are assigned in the PROC PRINT step also appear in the output for the PROC MEANS step.

```sas
title1 'Heart Rates for Patients with:';
title3 'Increased Stress Tolerance Levels';

footnote1 'Data from Treadmill Tests';
footnote3 '1st Quarter Admissions';     

proc print data = cert.stress;
    var resthr maxhr rechr;
    where tolerance = 'I';
run;

proc means data = cert.stress;
    where tolerance = 'I';
    var resthr maxhr;
run;
```

Redefining a title or footnote line cancel any higher numbered title or footnote lines, respectively. In the example below, defining a title for line 2 in the second report automatically cancels title line3 (15).

```sas
title1 'Heart Rates for Patients with:';
title3 'Participation in Exercise Therapy';

footnote1 'Data from Treadmill Tests';
footnote3 '1st Quarter Admissions';

proc print data = cert.therapy;
    var swim walkjogrun aerclass;
run;

title2 'Report for March';                                          (15)

proc print data = cert.therapy;
run;
```

To cancel all previous titles or footnotes, specify a null TITLE or FOOTNOTE statment (16).

```sas
title1;                                                             (16)

footnote1 'Data from Treadmill Tests';
footnote3 '1st Quarter Admissions';

proc print data = cert.stress;
    var resthr maxhr rechr;
    where tolerance = 'I';
run;

footnote1;                                                          (16)

proc means data = cert.stress;
    where tolerance = 'I';
    var resthr maxhr;
run;
```

### 6.7 ASSIGNING DESCRIPTIVE LABELS

#### 6.7.1 TEMPORARILY ASSIGNING LABELS TO VARIABLES

To enhance your PROC PRINT by labeling columns:

* use the LABEL statement to assign a descriptive label to a variable
* use the LABEL option in the PROC PRINT statement to specify that the labels be displayed

***

**Syntax. LABEL statement**

```sas
label   variable1 = 'label1'
        variable2 = 'label2'
        ...
;
```

* labels can be up to 256 characters long. Enclose the label in quotation marks.

> \[!TIP] The LABEL statement applies only to the PROC step in which it appears.

***

#### 6.7.2 E.G. USING THE LABEL OPTION IN THE PROC PRINT STATEMENT

In the PROC PRINT step below, the variable name WALKJOBRUN is displayted with the label Walk/Jog/Run (17).

```sas
proc print data = cert.therapy label;
    label walkjogrun = 'Walk/Jog/Run';                              (17)
run;
```

If you omit the LABEL option in the PROC PRINT statement, PROC PRINT uses the name of the column heading, WALKJOBRUN, even though you specified a value for the variable.

#### 6.7.3 E.G. USING MULTIPLE LABEL STATEMENTS

The following example illustrates the use of multiple LABEL statements.

```sas
proc print data = cert.admit label;
    var age height;
    label age    = 'Age of Patient';
    label height = 'Height in Inches';
run;
```

#### 6.7.4 E.G. USING A SINGLE LABEL STATEMENT

You can also assign multiple labels using a single LABEL statement.

```sas
roc print data = cert.admit label;
    var actlevel height weight;
    label   actlevel = 'Activity Level'
            height   = 'Height in Inches'
            weight   = 'Weight in Pounds'
    ;
run;
```

### 6.8 USING PERMANENTLY ASSIGNED LABELS

When you use a LABEL statement within a PROC step, the lavel applies only to the output from that step.

Permanent labels can be assigned in teh DATA step. These lavels are saved within the dataset, and theyc an be reused by procedures that reference the dataset.

```sas
data cert.paris;
    set cert.laguardia;
    where dest = 'PAR' and (boarded = 155 or boarded = 146);

    label date = 'Departure Date';
run;

proc print data = cert.paris label;                                 (18)
    var date dest boarded;
run;
```

Notice that the PROC PRINT statement still requires the LABEL option in order to display the permanent labels (18). Other SAS procedures display permanently assigned labels without additonal statements or options.

## CHAPTER 99 GOOD PROGRAMMING PRACTICE

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

5. Errors in your statements or data might not be evident when you look at results in the Results viewer. Review the messages in the SAS log each time you submit a SAS program.
6. Although omitting a RUN statement is not technically an error it can produce unexpected results. A best practice is to always end a step with a RUN statement.
7. How to fix an unbalanced quotation mark when simply correcting in the program does not resolve.

* Submit an asterisk followed by a single quotation mark, a semicolon, and a RUN statement.

```sas
    *'; run;
```

* Delete the line that contains the asterisk followed by a single quotation mark, a semicolon, and a RUN statement.
* Insert the missing quotation mark in the appropriate place.
* Submit the corrected program.

8. Whenever possible, use the ID statement to identify observations using variable values such as an identification number, instead of the observation numbers in the OBS column.
9. You can create a blank like between two titles by skipping a number in the TITLE statements but it is preferable to have an explicit null TITLE statement for the blank line. Same goes for footnotes and the FOOTNOTE statements.

```sas
title1 'Heart Rates for Patients with:';
title2;
title3 'Increased Stress Tolerance Levels';                         

proc print data = cert.stress;
    var resthr maxhr rechr;
    where tolerance = 'I';
run;
```
