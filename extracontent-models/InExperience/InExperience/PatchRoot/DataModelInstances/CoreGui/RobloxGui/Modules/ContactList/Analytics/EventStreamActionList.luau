local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Dash = require(CorePackages.Packages.Dash)
local Enums = require(CorePackages.Workspace.Packages.SocialLuaAnalytics).Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local EventNamesEnum = require(script.Parent.EventNamesEnum)
local LocalPlayer = Players.LocalPlayer
local Platform = UserInputService:GetPlatform()
local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()
local v13 = if Platform ~= Enum.Platform.Windows and Platform ~= Enum.Platform.OSX then if Platform ~= Enum.Platform.IOS then if Platform ~= Enum.Platform.Android then Platform ~= Enum.Platform.XBox360 and (Platform ~= Enum.Platform.PS3 and (Platform ~= Enum.Platform.PS4 and (Platform ~= Enum.Platform.XBoxOne and Platform ~= Enum.Platform.WiiU))) and "other" or "console" else "android" else "ios" else "desktop"

return {
	[EventNamesEnum.CallBarHangUpClicked] = {
		context = Contexts.ContactList,
		eventType = EventTypes.CallBarHangUpClicked,
		additionalInfo = {
			uid = LocalPlayer.UserId,
			universeId = game.GameId,
			placeId = game.PlaceId,
			deviceType = v13,
			playSessionId = PlaySessionId
		},
		formatRulesForAdditionalInfo = {
			eventTimestampMs = Dash.identity,
			calleeUserId = Dash.identity,
			callerUserId = Dash.identity,
			callId = Dash.identity,
			callStatus = Dash.identity,
			isRetry = Dash.identity
		}
	},
	[EventNamesEnum.PhoneBookNavigate] = {
		context = Contexts.ContactList,
		eventType = EventTypes.PhoneBookNavigate,
		additionalInfo = {
			uid = LocalPlayer.UserId,
			universeId = game.GameId,
			placeId = game.PlaceId,
			deviceType = v13,
			playSessionId = PlaySessionId
		},
		formatRulesForAdditionalInfo = {
			eventTimestampMs = Dash.identity,
			startingPage = Dash.identity,
			destinationPage = Dash.identity
		}
	},
	[EventNamesEnum.PhoneBookSearchClicked] = {
		context = Contexts.ContactList,
		eventType = EventTypes.PhoneBookSearchClicked,
		additionalInfo = {
			uid = LocalPlayer.UserId,
			universeId = game.GameId,
			placeId = game.PlaceId,
			deviceType = v13
		},
		formatRulesForAdditionalInfo = {
			eventTimestampMs = Dash.identity,
			playSessionId = PlaySessionId
		}
	},
	[EventNamesEnum.PhoneBookSearchAttempted] = {
		context = Contexts.ContactList,
		eventType = EventTypes.PhoneBookSearchAttempted,
		additionalInfo = {
			uid = LocalPlayer.UserId,
			universeId = game.GameId,
			placeId = game.PlaceId,
			deviceType = v13,
			playSessionId = PlaySessionId
		},
		formatRulesForAdditionalInfo = {
			eventTimestampMs = Dash.identity,
			searchQueryString = Dash.identity
		}
	},
	[EventNamesEnum.PhoneBookSearchFinished] = {
		context = Contexts.ContactList,
		eventType = EventTypes.PhoneBookSearchFinished,
		additionalInfo = {
			uid = LocalPlayer.UserId,
			universeId = game.GameId,
			placeId = game.PlaceId,
			deviceType = v13,
			playSessionId = PlaySessionId
		},
		formatRulesForAdditionalInfo = {
			eventTimestampMs = Dash.identity,
			searchQueryString = Dash.identity,
			searchResultCount = Dash.identity
		}
	},
	[EventNamesEnum.PhoneBookPlayerMenuOpened] = {
		context = Contexts.ContactList,
		eventType = EventTypes.PhoneBookPlayerMenuOpened,
		additionalInfo = {
			uid = LocalPlayer.UserId,
			universeId = game.GameId,
			placeId = game.PlaceId,
			deviceType = v13,
			playSessionId = PlaySessionId
		},
		formatRulesForAdditionalInfo = {
			eventTimestampMs = Dash.identity,
			friendUserId = Dash.identity,
			searchQueryString = Dash.identity,
			itemListIndex = Dash.identity,
			isSuggestedUser = Dash.identity,
			page = Dash.identity
		}
	},
	[EventNamesEnum.PhoneBookPlayerMenuUnfriendClicked] = {
		context = Contexts.ContactList,
		eventType = EventTypes.PhoneBookPlayerMenuUnfriendClicked,
		additionalInfo = {
			uid = LocalPlayer.UserId,
			universeId = game.GameId,
			placeId = game.PlaceId,
			deviceType = v13,
			playSessionId = PlaySessionId
		},
		formatRulesForAdditionalInfo = {
			eventTimestampMs = Dash.identity,
			friendUserId = Dash.identity
		}
	},
	[EventNamesEnum.PhoneBookPlayerMenuUnfriendFinished] = {
		context = Contexts.ContactList,
		eventType = EventTypes.PhoneBookPlayerMenuUnfriendFinished,
		additionalInfo = {
			uid = LocalPlayer.UserId,
			universeId = game.GameId,
			placeId = game.PlaceId,
			deviceType = v13,
			playSessionId = PlaySessionId
		},
		formatRulesForAdditionalInfo = {
			eventTimestampMs = Dash.identity,
			friendUserId = Dash.identity,
			success = Dash.identity
		}
	},
	[EventNamesEnum.PhoneBookPlayerMenuBlockClicked] = {
		context = Contexts.ContactList,
		eventType = EventTypes.PhoneBookPlayerMenuBlockClicked,
		additionalInfo = {
			uid = LocalPlayer.UserId,
			universeId = game.GameId,
			placeId = game.PlaceId,
			deviceType = v13,
			playSessionId = PlaySessionId
		},
		formatRulesForAdditionalInfo = {
			eventTimestampMs = Dash.identity,
			friendUserId = Dash.identity
		}
	},
	[EventNamesEnum.PhoneBookCallFriendClicked] = {
		context = Contexts.ContactList,
		eventType = EventTypes.PhoneBookCallFriendClicked,
		additionalInfo = {
			uid = LocalPlayer.UserId,
			universeId = game.GameId,
			placeId = game.PlaceId,
			deviceType = v13,
			playSessionId = PlaySessionId
		},
		formatRulesForAdditionalInfo = {
			eventTimestampMs = Dash.identity,
			friendUserId = Dash.identity,
			searchQueryString = Dash.identity,
			itemListIndex = Dash.identity,
			isSuggestedUser = Dash.identity,
			page = Dash.identity
		}
	},
	[EventNamesEnum.PhoneBookCallFriendFailed] = {
		context = Contexts.ContactList,
		eventType = EventTypes.PhoneBookCallFriendFailed,
		additionalInfo = {
			uid = LocalPlayer.UserId,
			universeId = game.GameId,
			placeId = game.PlaceId,
			deviceType = v13,
			playSessionId = PlaySessionId
		},
		formatRulesForAdditionalInfo = {
			eventTimestampMs = Dash.identity,
			calleeUserId = Dash.identity,
			callerUserId = Dash.identity,
			errorMsg = Dash.identity
		}
	}
}
