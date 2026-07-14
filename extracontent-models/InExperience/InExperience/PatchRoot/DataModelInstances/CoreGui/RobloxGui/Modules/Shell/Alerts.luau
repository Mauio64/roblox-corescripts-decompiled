local CoreGui = game:GetService("CoreGui")

game:GetService("CorePackages")

local Shell = CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell")
local LocalizedStrings = require(Shell:FindFirstChild("LocalizedStrings"))

return {
	Default = {
		Id = 0,
		Title = LocalizedStrings:LocStringUA("Xbox.Old.AlertOccurredTitle"),
		Msg = LocalizedStrings:LocStringUA("Xbox.Old.DefaultAlertPhrase")
	},
	UnlockedUGC = {
		Id = 101,
		Title = LocalizedStrings:LocStringUA("Xbox.Old.UnlockedUGCTitle"),
		Msg = LocalizedStrings:LocStringUA("Xbox.Old.UnlockedUGCPhrase")
	},
	LostConnection = {
		Controller = {
			Id = 201,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ControllerLostConnectionTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ControllerLostConnectionPhrase")
		},
		ActiveUser = {
			Id = 202,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ActiveUserLostConnectionTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ActiveUserLostConnectionPhrase")
		}
	},
	PlayMyPlaceMoreGames = {
		Id = 301,
		Title = LocalizedStrings:LocStringUA("Xbox.Old.PlayMyPlaceMoreGamesTitle"),
		Msg = LocalizedStrings:LocStringUA("Xbox.Old.PlayMyPlaceMoreGamesPhrase")
	},
	CrossPlatformPlayWelcome = {
		Id = 401,
		Title = LocalizedStrings:LocStringUA("Xbox.Old.CPPWelcomeTitle"),
		Msg = LocalizedStrings:LocStringUA("Xbox.Old.CPPWelcomePhrase")
	},
	Reauthentication = {
		[0] = {
			Id = 1001,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.AlertOccurredTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnknownPhrase")
		},
		[1] = {
			Id = 1002,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutPhrase")
		},
		[2] = {
			Id = 1003,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase")
		},
		[3] = {
			Id = 1004,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthInvalidSessionPhrase")
		},
		[4] = {
			Id = 1005,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnlinkTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnlinkPhrase")
		},
		[5] = {
			Id = 1006,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase")
		},
		[6] = {
			Id = 1007,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase")
		},
		[7] = {
			Id = 1008,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase")
		}
	},
	SignOut = {
		[0] = {
			Id = 1001,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.AlertOccurredTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnknownPhrase")
		},
		[1] = {
			Id = 1002,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutPhrase")
		},
		[2] = {
			Id = 1003,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthInvalidSessionPhrase")
		},
		[3] = {
			Id = 1004,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnlinkTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnlinkPhrase")
		},
		[4] = {
			Id = 1005,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase")
		},
		[5] = {
			Id = 1006,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase")
		},
		[6] = nil,
		[7] = {
			Id = 1007,
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthMaintenanceTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthMaintenancePhrase")
		}
	},
	PlatformLink = {
		Id = 1201,
		Title = LocalizedStrings:LocStringUA("Xbox.Old.PlatformLinkInfoTitle"),
		Msg = LocalizedStrings:LocStringUA("Xbox.Old.PlatformLinkInfoMessage")
	}
}
