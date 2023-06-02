USE Students;

DECLARE @ListOfStudents TABLE (
    [rowNumber] INT NOT NULL IDENTITY(1,1),
    [LastName] VARCHAR(100) NULL,
    [FirstName] VARCHAR(100) NULL,
    [Username] VARCHAR(100) NULL,
    [UserPassword] VARCHAR(100) NULL
);

INSERT INTO @ListOfStudents (LastName, FirstName, Username, UserPassword)
SELECT LastName, FirstName, Username, UserPassword FROM ListOfStudents;

IF EXISTS (SELECT * FROM @ListOfStudents)
BEGIN
    DECLARE @currentRow INT;
    DECLARE @maximumRows INT;

    SET @currentRow = 1;
    SET @maximumRows = (SELECT COUNT(*) FROM @ListOfStudents);

    WHILE @currentRow <= @maximumRows
    BEGIN
        -- Creating Database
        DECLARE @dbFilePath NVARCHAR(2000);
        DECLARE @dbLogPath NVARCHAR(2000);
        DECLARE @createFolderXP NVARCHAR(2000);
        DECLARE @domainLogin NVARCHAR(30);
        DECLARE @prefix NVARCHAR(200);
        DECLARE @DBName NVARCHAR(1000);
        DECLARE @logicalDataName NVARCHAR(600);
        DECLARE @logicalLogName NVARCHAR(600);
        DECLARE @dataFileName NVARCHAR(600);
        DECLARE @logFileName NVARCHAR(600);
        DECLARE @dataSize NVARCHAR(500);
        DECLARE @dataMaxSize NVARCHAR(500);
        DECLARE @dataFileGrowth NVARCHAR(500);
        DECLARE @logSize NVARCHAR(500);
        DECLARE @logMaxSize NVARCHAR(500);
        DECLARE @logFileGrowth NVARCHAR(500);
        DECLARE @exeTemp NVARCHAR(2000);

        BEGIN
            PRINT 'Begin create database';

            SET @DBName = (SELECT Username FROM @ListOfStudents WHERE rowNumber = @currentRow);
			SET @dbFilePath = N'/var/opt/mssql/data/';
			SET @LogicalDataName = @DBName + '_dat';
			SET @dbLogPath = N'/var/opt/mssql/log/';
			SET @DataFileName = @dbFilePath + @DBName + '.mdf';
			SET @LogicalLogName = @DBName + '_log';
			SET @LogFileName = @dbLogPath + @DBName + '.ldf';
			SET @dataSize = N'8192KB';
			SET @DataMaxSize = N'200MB';
			SET @DataFileGrowth = N'65536KB';
			SET @LogSize = N'8192KB';
			SET @LogMaxSize = N'100MB';
			SET @LogFileGrowth = N'65536KB';


            SET @exeTemp = 'CREATE DATABASE ' + @DBName + ' ON ('
                + 'NAME = ' + @LogicalDataName + ', '
                + 'FILENAME = ' + @DataFileName + ', '
                + 'SIZE = ' + @dataSize + ', '
                + 'MAXSIZE = ' + @DataMaxSize + ', '
                + 'FILEGROWTH = ' + @DataFileGrowth + ') '
                + 'LOG ON ('
                + 'NAME = ' + @LogicalLogName + ', '
                + 'FILENAME = ' + @LogFileName + ', '
                + 'SIZE = ' + @LogSize + ', '
                + 'MAXSIZE = ' + @LogMaxSize + ', '
                + 'FILEGROWTH = ' + @LogFileGrowth + ');';

            PRINT 'Creating database ' + @DBName;
            PRINT @exeTemp;
            EXEC (@exeTemp);
        END;

        -- Creating logins
        DECLARE @ExecTemp NVARCHAR(1000);
        DECLARE @_Login NVARCHAR(100), @_Password NVARCHAR(100), @_DefaultDatabase NVARCHAR(100), @_DBName NVARCHAR(100);

        BEGIN
            SET @_Login = (SELECT Username FROM @ListOfStudents WHERE rowNumber = @currentRow);
            SET @_Password = (SELECT UserPassword FROM @ListOfStudents WHERE rowNumber = @currentRow);
            SET @_DBName = @DBName;
            SET @_DefaultDatabase = @_DBName;

            SET @ExecTemp = 'CREATE LOGIN ' + @_Login + ' WITH PASSWORD = ''' + @_Password + ''', DEFAULT_DATABASE = ' + @_DefaultDatabase + ';';
            PRINT @ExecTemp;
            EXEC (@ExecTemp);
        END;

        -- Creating database users
        SET @exeTemp = 'USE ' + @_DBName + '; CREATE USER ' + @_Login + ' FOR LOGIN ' + @_Login + ';';
        EXEC (@exeTemp);

        SET @currentRow += 1;
    END;
END;
