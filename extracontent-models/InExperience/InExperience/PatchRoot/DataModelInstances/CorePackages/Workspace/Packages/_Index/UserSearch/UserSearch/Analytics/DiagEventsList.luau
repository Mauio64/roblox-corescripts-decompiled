local parent = script:FindFirstAncestor("UserSearch").Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local DiagEventTypes = SocialLuaAnalytics.Analytics.Enums.DiagEventTypes

local EventNames = require(script.Parent.EventNames)

local v = {
	Done = game:DefineFastString("UserSearchLoadingTimeDoneStats", "UserSearchLoadingTimeDone"),
	Failed = game:DefineFastString("UserSearchLoadingTimeFailedStats", "UserSearchLoadingTimeFailed")
}

local v2 = {
	Done = game:DefineFastString("UserSearchLoadingTimeNextPageDoneStats", "UserSearchLoadingTimeNextPageDone"),
	Failed = game:DefineFastString("UserSearchLoadingTimeNextPageFailedStats", "UserSearchLoadingTimeNextPageFailed")
}

local v3 = { Done = "UserSearchLoadedDone", Failed = "UserSearchLoadedFailed" }

local v4 = { Done = "UserSearchLoadedNextPageDone", Failed = "UserSearchLoadedNextPageFailed" }

return {
	[EventNames.PlayerFriendRequest] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("UserSearchPlayerFriendRequestCounter", "UserSearchPlayerFriendRequest")
	},
	[EventNames.PlayerFriendAccept] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("UserSearchPlayerFriendAcceptCounter", "UserSearchPlayerFriendAccept")
	},
	[EventNames.PlayerTileClick] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("UserSearchPlayerTileClickCounter", "UserSearchPlayerTileClick")
	},
	[EventNames.PlayerTileImpressions] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("UserSearchPlayerTileImpressionsCounter", "UserSearchPlayerTileImpressions"),
		count = function(p)
			if p and p.playerId then
				return #p.playerId
			end

			return 0
		end
	},
	[EventNames.UserSearchLoadingTime] = {
		type = DiagEventTypes.Stats,
		name = function(p)
			if p.nextPage then
				return v2[p.status]
			end

			return v[p.status]
		end,
		stats = function(p)
			return p.loadingTime or 0
		end
	},
	[EventNames.UserSearchLoaded] = {
		type = DiagEventTypes.Counter,
		name = function(p)
			if p.nextPage then
				return v4[p.status]
			end

			return v3[p.status]
		end,
		platformSpecificity = SocialLuaAnalytics.Analytics.Enums.PlatformSpecificity.BucketsOnly
	}
}
