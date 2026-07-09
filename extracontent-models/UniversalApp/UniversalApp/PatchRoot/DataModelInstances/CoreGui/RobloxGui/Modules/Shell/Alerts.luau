local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Shell = CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell")
local LocalizedStrings = require(Shell:FindFirstChild("LocalizedStrings"))
local FFlagAppShellMigrateLocales = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAppShellMigrateLocales

return {
	Default = {
		Id = 0,
		Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("AlertOccurredTitle") else LocalizedStrings:LocStringUA("Xbox.Old.AlertOccurredTitle"),
		Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("DefaultAlertPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.DefaultAlertPhrase")
	},
	UnlockedUGC = {
		Id = 101,
		Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("UnlockedUGCTitle") else LocalizedStrings:LocStringUA("Xbox.Old.UnlockedUGCTitle"),
		Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("UnlockedUGCPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.UnlockedUGCPhrase")
	},
	LostConnection = {
		Controller = {
			Id = 201,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ControllerLostConnectionTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ControllerLostConnectionTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ControllerLostConnectionPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ControllerLostConnectionPhrase")
		},
		ActiveUser = {
			Id = 202,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ActiveUserLostConnectionTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ActiveUserLostConnectionTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ActiveUserLostConnectionPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ActiveUserLostConnectionPhrase")
		}
	},
	PlayMyPlaceMoreGames = {
		Id = 301,
		Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("PlayMyPlaceMoreGamesTitle") else LocalizedStrings:LocStringUA("Xbox.Old.PlayMyPlaceMoreGamesTitle"),
		Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("PlayMyPlaceMoreGamesPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.PlayMyPlaceMoreGamesPhrase")
	},
	CrossPlatformPlayWelcome = {
		Id = 401,
		Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("CPPWelcomeTitle") else LocalizedStrings:LocStringUA("Xbox.Old.CPPWelcomeTitle"),
		Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("CPPWelcomePhrase") else LocalizedStrings:LocStringUA("Xbox.Old.CPPWelcomePhrase")
	},
	Reauthentication = {
		[0] = {
			Id = 1001,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("AlertOccurredTitle") else LocalizedStrings:LocStringUA("Xbox.Old.AlertOccurredTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthUnknownPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnknownPhrase")
		},
		[1] = {
			Id = 1002,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthSignedOutTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthSignedOutPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutPhrase")
		},
		[2] = {
			Id = 1003,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthRemovedTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthRemovedPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase")
		},
		[3] = {
			Id = 1004,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthSignedOutTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthInvalidSessionPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthInvalidSessionPhrase")
		},
		[4] = {
			Id = 1005,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthUnlinkTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnlinkTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthUnlinkPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnlinkPhrase")
		},
		[5] = {
			Id = 1006,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthRemovedTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthRemovedPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase")
		},
		[6] = {
			Id = 1007,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthRemovedTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthRemovedPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase")
		},
		[7] = {
			Id = 1008,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthRemovedTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthRemovedPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase")
		}
	},
	SignOut = {
		[0] = {
			Id = 1001,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("AlertOccurredTitle") else LocalizedStrings:LocStringUA("Xbox.Old.AlertOccurredTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthUnknownPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnknownPhrase")
		},
		[1] = {
			Id = 1002,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthSignedOutTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthSignedOutPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutPhrase")
		},
		[2] = {
			Id = 1003,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthSignedOutTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthInvalidSessionPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthInvalidSessionPhrase")
		},
		[3] = {
			Id = 1004,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthUnlinkTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnlinkTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthUnlinkPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnlinkPhrase")
		},
		[4] = {
			Id = 1005,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthRemovedTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthRemovedPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase")
		},
		[5] = {
			Id = 1006,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthRemovedTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthRemovedPhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase")
		},
		[6] = nil,
		[7] = {
			Id = 1007,
			Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthMaintenanceTitle") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthMaintenanceTitle"),
			Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ReauthMaintenancePhrase") else LocalizedStrings:LocStringUA("Xbox.Old.ReauthMaintenancePhrase")
		}
	},
	PlatformLink = {
		Id = 1201,
		Title = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("PlatformLinkInfoTitle") else LocalizedStrings:LocStringUA("Xbox.Old.PlatformLinkInfoTitle"),
		Msg = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("PlatformLinkInfoMessage") else LocalizedStrings:LocStringUA("Xbox.Old.PlatformLinkInfoMessage")
	}
}
