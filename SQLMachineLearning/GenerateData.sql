USE [loan]
GO
/****** Object:  Schema [db1]    Script Date: 9/30/2020 3:06:58 AM ******/
CREATE SCHEMA [db1]
GO
/****** Object:  Table [db1].[clients]    Script Date: 9/30/2020 3:06:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [db1].[clients](
	[LoanBalance] [money] NULL,
	[ArrearsBalance] [money] NULL,
	[ArrearsDays] [int] NULL,
	[RepaymentAmount] [money] NULL,
	[LVR] [int] NULL,
	[JointLoan] [nvarchar](50) NULL,
	[LPI] [nvarchar](50) NULL,
	[SecurityValuation] [money] NULL,
	[RelationshipBalance] [money] NULL,
	[SavingsBalance] [money] NULL,
	[SavingsBalanceOne] [int] NULL,
	[SavingsBalanceThree] [int] NULL,
	[ArrearsBalanceOne] [int] NULL,
	[ArrearsBalanceThree] [int] NULL,
	[ArrearsDaysOne] [int] NULL,
	[ArrearsDaysThree] [int] NULL,
	[TransactionQuantityOne] [int] NULL,
	[TransactionValueOne] [int] NULL,
	[TransactionQuantityThree] [int] NULL,
	[TransactionValueThree] [int] NULL,
	[AppUsageOne] [int] NULL,
	[AppUsageThree] [int] NULL,
	[InternetUsageOne] [int] NULL,
	[InternetUsageThree] [int] NULL,
	[BranchVisitsSix] [int] NULL,
	[Gender] [char](10) NOT NULL,
	[Age] [int] NOT NULL,
	[ResidentialPostcode] [nvarchar](50) NOT NULL,
	[DefaultOccurred] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
