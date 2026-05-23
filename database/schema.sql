-- 🚨 LifeLine - SQL Database Schema Definition
-- Target Database Engine: Microsoft SQL Server (MSSQL)

-- 1. Create [User] table
CREATE TABLE [dbo].[User] (
    [ID]            INT IDENTITY(1,1) NOT NULL,
    [TC]            NVARCHAR(20)      NOT NULL UNIQUE,
    [Password_hash] NVARCHAR(255)     NOT NULL,
    [Name]          NVARCHAR(50)      NOT NULL,
    [Surname]       NVARCHAR(50)      NOT NULL,
    [Age]           INT               NULL,
    [Gender]        NCHAR(10)         NULL,
    [Phone]         NVARCHAR(20)      NULL,
    [Email]         NVARCHAR(50)      NULL,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([ID] ASC)
);

-- 2. Create EmergencyCalls table
CREATE TABLE [dbo].[EmergencyCalls] (
    [Call_id]         INT IDENTITY(1,1) NOT NULL,
    [Kit_id]          INT               NOT NULL,
    [User_id]         INT               NOT NULL,
    [latitude-x]      FLOAT             NOT NULL,
    [longitude-y]     FLOAT             NOT NULL,
    [timestamp]       DATETIME2         NOT NULL,
    [user_conditions] NVARCHAR(MAX)     NULL, -- JSON formatted array
    [user_allergies]  NVARCHAR(MAX)     NULL, -- JSON formatted array
    CONSTRAINT [PK_EmergencyCalls] PRIMARY KEY CLUSTERED ([Call_id] ASC),
    CONSTRAINT [FK_EmergencyCalls_User] FOREIGN KEY ([User_id]) REFERENCES [dbo].[User] ([ID]) ON DELETE CASCADE
);

-- 3. Create help_request_items table
CREATE TABLE [dbo].[help_request_items] (
    [item_id]    INT IDENTITY(1,1) NOT NULL,
    [request_id] INT               NOT NULL,
    [item_name]  NVARCHAR(255)     NOT NULL,
    CONSTRAINT [PK_help_request_items] PRIMARY KEY CLUSTERED ([item_id] ASC),
    CONSTRAINT [FK_help_request_items_EmergencyCalls] FOREIGN KEY ([request_id]) REFERENCES [dbo].[EmergencyCalls] ([Call_id]) ON DELETE CASCADE
);

-- Indices for performance optimizations
CREATE NONCLUSTERED INDEX [IX_User_TC] ON [dbo].[User] ([TC] ASC);
CREATE NONCLUSTERED INDEX [IX_EmergencyCalls_User_id] ON [dbo].[EmergencyCalls] ([User_id] ASC);
CREATE NONCLUSTERED INDEX [IX_EmergencyCalls_Timestamp] ON [dbo].[EmergencyCalls] ([timestamp] DESC);
CREATE NONCLUSTERED INDEX [IX_help_request_items_request_id] ON [dbo].[help_request_items] ([request_id] ASC);
