use PROJETO 

------------------------------------------------ BACKUP ------------------------------------------------
GO  
EXEC sp_addumpdevice 'disk', 'BackupsOfPROJECTs', 'C:\Projeto_de_CBD\MSSQL\BACKUPS\BackupDevice.bak' ;  
GO 

GO  
EXEC sp_addumpdevice 'disk', 'BackupsOfPROJECTDiffAndLog', 'C:\Projeto_de_CBD\MSSQL\BACKUPS\BackupDeviceDIFFNLog.bak' ;  
GO 

--GO  
--EXEC sp_addumpdevice 'disk', 'BackupsOfPROJECTLogs', 'C:\Projeto_de_CBD\MSSQL\BACKUPS\BackupDeviceLogs.bak' ;  
--GO [AdventureOldData]
 

--TO BE DONE AT THE END OF EVERY DAY
GO
BACKUP DATABASE PROJETO TO [BackupsOfPROJECT] 
	WITH  FORMAT, NAME = N'PROJETO-FULL Database Backup', SKIP, REWIND, NOUNLOAD,  STATS = 10


--TO BE DONE EVERY 4 HOURS EXCEPT DURING THE FULL BACKUP TIME
go
BACKUP DATABASE PROJETO TO [BackupsOfPROJECTDiffAndLog] 
 WITH  DIFFERENTIAL , FORMAT,  NAME = N'Projeto-Diff Database Backup', SKIP, REWIND, NOUNLOAD,  STATS = 10


 --TO BE DONE EVERY 40 MINS EXCEPT DURING THE FULL-BACKUP AND DIFF-BACKUP TIME
	BACKUP LOG PROJETO TO [BackupsOfPROJECTDiffAndLog] 
	WITH NOFORMAT, NOINIT, NAME = N'PROJETO-LOG Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10


 --TO BE DONE WHEN A PROBLEM OCCURS AND THAT DATA WASNT BACKED UP YET
	BACKUP LOG PROJETO
	TO DISK = 'C:\Projeto_de_CBD\MSSQL\BACKUPS\BackupTail_NORECOVERY.TRN'
	WITH NORECOVERY, CONTINUE_AFTER_ERROR


 ---------------------------------------------------------RESTORE-----------------------------------------------------------------

 --IF FULL WAS THE LAST PERFORMED
	use master
	RESTORE DATABASE PROJETO FROM  [BackupsOfPROJECT] WITH  FILE = 1

--IF DIFERENTIAL WAS THE LAST
	use master
	RESTORE DATABASE PROJETO FROM  [BackupsOfPROJECT] WITH  FILE = 1,  NORECOVERY
	RESTORE DATABASE PROJETO FROM  [BackupsOfPROJECTDiffAndLog] WITH  FILE = 1

--IF LOGS WAS THE LAST AND THERE WAS A DIFFERENTIAL DONE AS WELL
	use master
	RESTORE DATABASE PROJETO FROM  [BackupsOfPROJECT] WITH  FILE = 1,  NORECOVERY
	RESTORE DATABASE PROJETO FROM  [BackupsOfPROJECTDiffAndLog] WITH  FILE = 1, NORECOVERY
	RESTORE LOG PROJETO FROM  [BackupsOfPROJECTDiffAndLog] WITH FILE = 2 --... + 3 + 4 + 5 + 6 dependendo onde a database morreu

--IN CASE INFORMATION WASNT BACKUP UP YET
	use master
	RESTORE DATABASE PROJETO FROM  [BackupsOfPROJECT] WITH  FILE = 1,  NORECOVERY
	RESTORE DATABASE PROJETO FROM  [BackupsOfPROJECTDiffAndLog] WITH  FILE = 1, NORECOVERY
	RESTORE LOG PROJETO FROM  [BackupsOfPROJECTDiffAndLog] WITH FILE = 1, NORECOVERY --... + 3 + 4 + 5 + 6 dependendo onde a database morreu
	RESTORE LOG PROJETO FROM DISK = 'C:\Projeto_de_CBD\MSSQL\BACKUPS\BackupTail_NORECOVERY.TRN'

--------------------------------------------------------------------------------------------------------------------------------------------------------
--IF DATABASE DIED BETWEEN MIDNIGHT AND 4 AM
	use master
	RESTORE DATABASE PROJETO FROM  [BackupsOfPROJECT] WITH  FILE = 1,  NORECOVERY
	--RESTORE DATABASE PROJETO FROM  [BackupsOfPROJECTDiffAndLog] WITH  FILE = 1, NORECOVERY
	RESTORE LOG PROJETO FROM  [BackupsOfPROJECTDiffAndLog] WITH FILE = 7 --... + 8 + 9 + 10 + 11 dependendo onde a database morreu

