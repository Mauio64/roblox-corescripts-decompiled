local CoreGui = game:GetService("CoreGui")
game:GetService("CorePackages")
local shell = CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell")

local LocalizedStrings = require(shell:FindFirstChild("LocalizedStrings"))

return {
	Default = {
		Title = LocalizedStrings:LocStringUA("Xbox.Old.AlertOccurredTitle"),
		Msg = LocalizedStrings:LocStringUA("Xbox.Old.DefaultAlertPhrase"),
		Id = 0
	},
	UnlockedUGC = {
		Title = LocalizedStrings:LocStringUA("Xbox.Old.UnlockedUGCTitle"),
		Msg = LocalizedStrings:LocStringUA("Xbox.Old.UnlockedUGCPhrase"),
		Id = 101
	},
	LostConnection = {
		Controller = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ControllerLostConnectionTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ControllerLostConnectionPhrase"),
			Id = 201
		},
		ActiveUser = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ActiveUserLostConnectionTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ActiveUserLostConnectionPhrase"),
			Id = 202
		}
	},
	PlayMyPlaceMoreGames = {
		Title = LocalizedStrings:LocStringUA("Xbox.Old.PlayMyPlaceMoreGamesTitle"),
		Msg = LocalizedStrings:LocStringUA("Xbox.Old.PlayMyPlaceMoreGamesPhrase"),
		Id = 301
	},
	CrossPlatformPlayWelcome = {
		Title = LocalizedStrings:LocStringUA("Xbox.Old.CPPWelcomeTitle"),
		Msg = LocalizedStrings:LocStringUA("Xbox.Old.CPPWelcomePhrase"),
		Id = 401
	},
	Reauthentication = {
		[0] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.AlertOccurredTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnknownPhrase"),
			Id = 1001
		},
		[1] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutPhrase"),
			Id = 1002
		},
		[2] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase"),
			Id = 1003
		},
		[3] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthInvalidSessionPhrase"),
			Id = 1004
		},
		[4] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnlinkTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnlinkPhrase"),
			Id = 1005
		},
		[5] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase"),
			Id = 1006
		},
		[6] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase"),
			Id = 1007
		},
		[7] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase"),
			Id = 1008
		}
	},
	SignOut = {
		[0] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.AlertOccurredTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnknownPhrase"),
			Id = 1001
		},
		[1] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutPhrase"),
			Id = 1002
		},
		[2] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthSignedOutTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthInvalidSessionPhrase"),
			Id = 1003
		},
		[3] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnlinkTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthUnlinkPhrase"),
			Id = 1004
		},
		[4] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase"),
			Id = 1005
		},
		[5] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthRemovedPhrase"),
			Id = 1006
		},
		[6] = nil,
		[7] = {
			Title = LocalizedStrings:LocStringUA("Xbox.Old.ReauthMaintenanceTitle"),
			Msg = LocalizedStrings:LocStringUA("Xbox.Old.ReauthMaintenancePhrase"),
			Id = 1007
		}
	},
	PlatformLink = {
		Title = LocalizedStrings:LocStringUA("Xbox.Old.PlatformLinkInfoTitle"),
		Msg = LocalizedStrings:LocStringUA("Xbox.Old.PlatformLinkInfoMessage"),
		Id = 1201
	}
}
