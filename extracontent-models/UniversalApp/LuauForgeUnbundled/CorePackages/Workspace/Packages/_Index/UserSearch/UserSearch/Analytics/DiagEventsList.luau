local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SocialLuaAnalytics")
local diagEventTypes = SocialLuaAnalytics.Analytics.Enums.DiagEventTypes

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Analytics/EventNames")

local v5 = {
	Done = game:DefineFastString("UserSearchLoadingTimeDoneStats", "UserSearchLoadingTimeDone"),
	Failed = game:DefineFastString("UserSearchLoadingTimeFailedStats", "UserSearchLoadingTimeFailed")
}

local v6 = {
	Done = game:DefineFastString(
		"UserSearchLoadingTimeNextPageDoneStats",
		"UserSearchLoadingTimeNextPageDone"
	),
	Failed = game:DefineFastString(
		"UserSearchLoadingTimeNextPageFailedStats",
		"UserSearchLoadingTimeNextPageFailed"
	)
}

local v7 = { Done = "UserSearchLoadedDone", Failed = "UserSearchLoadedFailed" }

local v8 = {
	Done = "UserSearchLoadedNextPageDone",
	Failed = "UserSearchLoadedNextPageFailed"
}

return {
	[EventNames.PlayerFriendRequest] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"UserSearchPlayerFriendRequestCounter",
			"UserSearchPlayerFriendRequest"
		)
	},
	[EventNames.PlayerFriendAccept] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString("UserSearchPlayerFriendAcceptCounter", "UserSearchPlayerFriendAccept")
	},
	[EventNames.PlayerTileClick] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString("UserSearchPlayerTileClickCounter", "UserSearchPlayerTileClick")
	},
	[EventNames.PlayerTileImpressions] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"UserSearchPlayerTileImpressionsCounter",
			"UserSearchPlayerTileImpressions"
		),
		count = function(p2)
			if p2 and p2.playerId then
				return #p2.playerId
			end

			return 0
		end
	},
	[EventNames.UserSearchLoadingTime] = {
		type = diagEventTypes.Stats,
		name = function(p2)
			if p2.nextPage then
				return v6[p2.status]
			end

			return v5[p2.status]
		end,
		stats = function(p2)
			return p2.loadingTime or 0
		end
	},
	[EventNames.UserSearchLoaded] = {
		type = diagEventTypes.Counter,
		name = function(p2)
			if p2.nextPage then
				return v8[p2.status]
			end

			return v7[p2.status]
		end,
		platformSpecificity = SocialLuaAnalytics.Analytics.Enums.PlatformSpecificity.BucketsOnly
	}
}
