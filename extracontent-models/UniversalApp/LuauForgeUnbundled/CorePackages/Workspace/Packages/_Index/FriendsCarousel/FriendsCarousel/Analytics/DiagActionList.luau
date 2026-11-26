local diagEventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/SocialLuaAnalytics").Analytics.Enums.DiagEventTypes

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/EventNames")
local FetchNames = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/FetchNames")

local v5 = {
	Done = game:DefineFastString(
		"AllFriendsCarouselLoadingTimeDoneStats",
		"AllFriendsCarouselLoadingTimeDone"
	),
	Failed = game:DefineFastString(
		"AllFriendsCarouselLoadingTimeFailedStats",
		"AllFriendsCarouselLoadingTimeFailed"
	)
}

local v6 = {
	Done = game:DefineFastString(
		"AllFriendsNextPageCarouselLoadingTimeDoneStats",
		"AllFriendsNextPageCarouselLoadingTimeDone"
	),
	Failed = game:DefineFastString(
		"AllFriendsNextPageCarouselLoadingTimeFailedStats",
		"AllFriendsNextPageCarouselLoadingTimeFailed"
	)
}

local v7 = {
	Done = game:DefineFastString(
		"OnlineFriendsCarouselLoadingTimeDoneStats",
		"OnlineFriendsCarouselLoadingTimeDone"
	),
	Failed = game:DefineFastString(
		"OnlineFriendsCarouselLoadingTimeFailedStats",
		"OnlineFriendsCarouselLoadingTimeFailed"
	)
}

local v8 = {
	Done = game:DefineFastString(
		"OldAllFriendsCarouselLoadingTimeDoneStats",
		"OldAllFriendsCarouselLoadingTimeDone"
	),
	Failed = game:DefineFastString(
		"OldAllFriendsCarouselLoadingTimeFailedStats",
		"OldAllFriendsCarouselLoadingTimeFailed"
	)
}

local defineFastString = game:DefineFastString(
	"FriendsCarouselUILoadingTimeStats",
	"FriendsCarouselUILoadingTime"
)

local defineFastString2 = game:DefineFastString(
	"OnlineFriendsRefetchOnPresenceUpdateCounter",
	"OnlineFriendsRefetchOnPresenceUpdate"
)

local defineFastString3 = game:DefineFastString(
	"OnlineFriendsRefetchOnFriendshipUpdateCounter",
	"OnlineFriendsRefetchOnFriendshipUpdate"
)

return {
	[EventNames.CarouselLoadedWithUsers] = {
		name = game:DefineFastString("FriendsCarouselLoadedWithUsers", "FriendsCarouselLoadedWithUsers")
	},
	[EventNames.UserPressed] = {
		name = game:DefineFastString("FriendsCarouselUserPressed", "FriendsCarouselUserPressed")
	},
	[EventNames.RequestFriendship] = {
		name = game:DefineFastString("FriendsCarouselRequestFriendship", "FriendsCarouselRequestFriendship")
	},
	[EventNames.RevokeFriendRequest] = {
		name = game:DefineFastString(
			"FriendsCarouselRevokeFriendRequest",
			"FriendsCarouselRevokeFriendRequest"
		)
	},
	[EventNames.ViewAllFriends] = {
		name = game:DefineFastString("HomePageNavigationViewAllFriends", "HomePageNavigationFriendsLanding")
	},
	[EventNames.ViewAddFriends] = {
		name = game:DefineFastString("HomePageNavigationViewAddFriends", "AddFriendsHomeEntry")
	},
	[EventNames.PaginatedFriendsCarouselLoadingTime] = {
		type = diagEventTypes.Stats,
		name = function(data)
			if data.fetch ~= FetchNames.AllFriends then
				return v7[data.status]
			end

			if data.nextPage then
				return v6[data.status]
			end

			return v5[data.status]
		end,
		stats = function(p2)
			return p2.loadingTime or 0
		end
	},
	[EventNames.FriendsEndpointLoadingTime] = {
		type = diagEventTypes.Stats,
		name = function(p2)
			return v8[p2.status]
		end,
		stats = function(p2)
			return p2.loadingTime or 0
		end
	},
	[EventNames.FriendsCarouselUILoadingTime] = {
		type = diagEventTypes.Stats,
		name = function(p2)
			return `{defineFastString}_{p2.fetch}`
		end,
		stats = function(p2)
			return p2.loadingTime or 0
		end
	},
	[EventNames.OnlineFriendsRefetchOnPresenceUpdate] = {
		type = diagEventTypes.Counter,
		name = defineFastString2
	},
	[EventNames.OnlineFriendsRefetchOnFriendshipUpdate] = {
		type = diagEventTypes.Counter,
		name = defineFastString3
	}
}
