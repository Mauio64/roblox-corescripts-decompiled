local Parent = script:FindFirstAncestor("UserSearch").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local DiagEventTypes = SocialLuaAnalytics.Analytics.Enums.DiagEventTypes
local EventNames = require(script.Parent.EventNames)
local t1 = {
	Done = game:DefineFastString("UserSearchLoadingTimeDoneStats", "UserSearchLoadingTimeDone"),
	Failed = game:DefineFastString("UserSearchLoadingTimeFailedStats", "UserSearchLoadingTimeFailed")
}
local t2 = {
	Done = game:DefineFastString("UserSearchLoadingTimeNextPageDoneStats", "UserSearchLoadingTimeNextPageDone"),
	Failed = game:DefineFastString("UserSearchLoadingTimeNextPageFailedStats", "UserSearchLoadingTimeNextPageFailed")
}
local t3 = {
	Done = "UserSearchLoadedDone",
	Failed = "UserSearchLoadedFailed"
}
local t4 = {
	Done = "UserSearchLoadedNextPageDone",
	Failed = "UserSearchLoadedNextPageFailed"
}

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
		count = function(p1) -- line: 45
			if p1 and p1.playerId then
				return #p1.playerId
			end

			return 0
		end
	},
	[EventNames.UserSearchLoadingTime] = {
		type = DiagEventTypes.Stats,
		name = function(p2) -- line: 51
			-- upvalues: t2 (copy), t1 (copy)
			if p2.nextPage then
				return t2[p2.status]
			end

			return t1[p2.status]
		end,
		stats = function(p3) -- line: 56
			return p3.loadingTime or 0
		end
	},
	[EventNames.UserSearchLoaded] = {
		type = DiagEventTypes.Counter,
		name = function(p4) -- line: 62
			-- upvalues: t4 (copy), t3 (copy)
			if p4.nextPage then
				return t4[p4.status]
			end

			return t3[p4.status]
		end,
		platformSpecificity = SocialLuaAnalytics.Analytics.Enums.PlatformSpecificity.BucketsOnly
	}
}
