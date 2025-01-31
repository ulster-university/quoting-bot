﻿SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;

IF NOT EXISTS (SELECT * FROM [sys].[database_principals] WHERE [type] = 'R' AND [name] = 'ApplicationRole')
BEGIN
	PRINT N'Creating Role [ApplicationRole]...';
	CREATE ROLE [ApplicationRole]
		AUTHORIZATION [dbo];
END
GO

PRINT N'Creating Table [dbo].[SchemaVersions]...';
GO

CREATE TABLE [dbo].[SchemaVersions]
(
	[Id] [int] NULL,
	[ScriptName] [nvarchar](255) NULL,
	[Applied] [datetime] NULL
);
GO

PRINT N'Granting permissions on [dbo].[SchemaVersions]...';
GO

GRANT SELECT, INSERT ON [dbo].[SchemaVersions] TO [ApplicationRole] AS [dbo];
GO

PRINT N'Creating Table [dbo].[Conversations]...';
GO

CREATE TABLE [dbo].[Conversations]
(
	[ConversationId] [nvarchar](MAX) NOT NULL,
	[UserId] [nvarchar](MAX) NOT NULL,
	[ConversationDate] [varchar](30) NOT NULL,
	[QuoteId] [varchar](12) NULL,
	[ConversationLog] [varchar](MAX) NULL
);
GO

PRINT N'Granting permissions on [dbo].[Conversations]...';
GO

GRANT SELECT, INSERT ON [dbo].[Conversations] TO [ApplicationRole] AS [dbo];
GO

PRINT N'Creating Procedure usp_Add_Conversation...';
GO

CREATE PROCEDURE usp_Add_Conversation
	@ConversationId nvarchar(MAX),
	@UserId nvarchar(MAX),
	@ConversationDate nvarchar(30),
	@QuoteId nvarchar(12),
	@ConversationLog nvarchar(MAX)
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [Conversations](ConversationId, UserId, ConversationDate, QuoteId, ConversationLog) 
	VALUES(@ConversationId, @UserId, @ConversationDate, @QuoteId, @ConversationLog)
END
GO

GRANT EXECUTE ON usp_Add_Conversation TO [ApplicationRole] 
GO

PRINT N'Creating Procedure usp_Update_Conversation...';
GO

CREATE PROCEDURE usp_Update_Conversation
	@ConversationId nvarchar(MAX),
	@ConversationLog nvarchar(MAX)
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [Conversations]
	SET ConversationLog = @ConversationLog
	WHERE ConversationId = @ConversationId
END
GO

GRANT EXECUTE ON usp_Update_Conversation TO [ApplicationRole] 
GO