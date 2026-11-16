local parent = script:FindFirstAncestor("FriendsCarousel").Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local DiagEventTypes = SocialLuaAnalytics.Analytics.Enums.DiagEventTypes

local EventNames = require(script.Parent.EventNames)
local FetchNames = require(script.Parent.FetchNames)

local v = {
	Done = game:DefineFastString("AllFriendsCarouselLoadingTimeDoneStats", "AllFriendsCarouselLoadingTimeDone"),
	Failed = game:DefineFastString("AllFriendsCarouselLoadingTimeFailedStats", "AllFriendsCarouselLoadingTimeFailed")
}

local v2 = {
	Done = game:DefineFastString(
		"AllFriendsNextPageCarouselLoadingTimeDoneStats",
		"AllFriendsNextPageCarouselLoadingTimeDone"
	),
	Failed = game:DefineFastString(
		"AllFriendsNextPageCarouselLoadingTimeFailedStats",
		"AllFriendsNextPageCarouselLoadingTimeFailed"
	)
}

local v3 = {
	Done = game:DefineFastString("OnlineFriendsCarouselLoadingTimeDoneStats", "OnlineFriendsCarouselLoadingTimeDone"),
	Failed = game:DefineFastString(
		"OnlineFriendsCarouselLoadingTimeFailedStats",
		"OnlineFriendsCarouselLoadingTimeFailed"
	)
}

local v4 = {
	Done = game:DefineFastString("OldAllFriendsCarouselLoadingTimeDoneStats", "OldAllFriendsCarouselLoadingTimeDone"),
	Failed = game:DefineFastString(
		"OldAllFriendsCarouselLoadingTimeFailedStats",
		"OldAllFriendsCarouselLoadingTimeFailed"
	)
}

local defineFastString = game:DefineFastString("FriendsCarouselUILoadingTimeStats", "FriendsCarouselUILoadingTime")

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
		name = game:DefineFastString("FriendsCarouselRevokeFriendRequest", "FriendsCarouselRevokeFriendRequest")
	},
	[EventNames.ViewAllFriends] = {
		name = game:DefineFastString("HomePageNavigationViewAllFriends", "HomePageNavigationFriendsLanding")
	},
	[EventNames.ViewAddFriends] = {
		name = game:DefineFastString("HomePageNavigationViewAddFriends", "AddFriendsHomeEntry")
	},
	[EventNames.PaginatedFriendsCarouselLoadingTime] = {
		type = DiagEventTypes.Stats,
		name = function(data)
			if data.fetch ~= FetchNames.AllFriends then
				return v3[data.status]
			end

			if data.nextPage then
				return v2[data.status]
			end

			return v[data.status]
		end,
		stats = function(p)
			return p.loadingTime or 0
		end
	},
	[EventNames.FriendsEndpointLoadingTime] = {
		type = DiagEventTypes.Stats,
		name = function(p)
			return v4[p.status]
		end,
		stats = function(p)
			return p.loadingTime or 0
		end
	},
	[EventNames.FriendsCarouselUILoadingTime] = {
		type = DiagEventTypes.Stats,
		name = function(p)
			return `{defineFastString}_{p.fetch}`
		end,
		stats = function(p)
			return p.loadingTime or 0
		end
	},
	[EventNames.OnlineFriendsRefetchOnPresenceUpdate] = {
		type = DiagEventTypes.Counter,
		name = defineFastString2
	},
	[EventNames.OnlineFriendsRefetchOnFriendshipUpdate] = {
		type = DiagEventTypes.Counter,
		name = defineFastString3
	}
}
