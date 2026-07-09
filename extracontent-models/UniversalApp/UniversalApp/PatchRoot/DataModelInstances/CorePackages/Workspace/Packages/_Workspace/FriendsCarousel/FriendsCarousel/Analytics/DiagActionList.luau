local Parent = script:FindFirstAncestor("FriendsCarousel").Parent
local DiagEventTypes = require(Parent.SocialLuaAnalytics).Analytics.Enums.DiagEventTypes
local EventNames = require(script.Parent.EventNames)
local FetchNames = require(script.Parent.FetchNames)
local t1 = {
	Done = game:DefineFastString("AllFriendsCarouselLoadingTimeDoneStats", "AllFriendsCarouselLoadingTimeDone"),
	Failed = game:DefineFastString("AllFriendsCarouselLoadingTimeFailedStats", "AllFriendsCarouselLoadingTimeFailed")
}
local t2 = {
	Done = game:DefineFastString("AllFriendsNextPageCarouselLoadingTimeDoneStats", "AllFriendsNextPageCarouselLoadingTimeDone"),
	Failed = game:DefineFastString("AllFriendsNextPageCarouselLoadingTimeFailedStats", "AllFriendsNextPageCarouselLoadingTimeFailed")
}
local t3 = {
	Done = game:DefineFastString("OnlineFriendsCarouselLoadingTimeDoneStats", "OnlineFriendsCarouselLoadingTimeDone"),
	Failed = game:DefineFastString("OnlineFriendsCarouselLoadingTimeFailedStats", "OnlineFriendsCarouselLoadingTimeFailed")
}
local t4 = {
	Done = game:DefineFastString("OldAllFriendsCarouselLoadingTimeDoneStats", "OldAllFriendsCarouselLoadingTimeDone"),
	Failed = game:DefineFastString("OldAllFriendsCarouselLoadingTimeFailedStats", "OldAllFriendsCarouselLoadingTimeFailed")
}
local v9 = game:DefineFastString("FriendsCarouselUILoadingTimeStats", "FriendsCarouselUILoadingTime")
local v10 = game:DefineFastString("OnlineFriendsRefetchOnPresenceUpdateCounter", "OnlineFriendsRefetchOnPresenceUpdate")
local v11 = game:DefineFastString("OnlineFriendsRefetchOnFriendshipUpdateCounter", "OnlineFriendsRefetchOnFriendshipUpdate")

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
		name = function(p1) -- line: 71
			-- upvalues: FetchNames (copy), t2 (copy), t1 (copy), t3 (copy)
			if p1.fetch == FetchNames.AllFriends then
				if p1.nextPage then
					return t2[p1.status]
				end

				return t1[p1.status]
			end

			return t3[p1.status]
		end,
		stats = function(p2) -- line: 78
			return p2.loadingTime or 0
		end
	},
	[EventNames.FriendsEndpointLoadingTime] = {
		type = DiagEventTypes.Stats,
		name = function(p3) -- line: 84
			-- upvalues: t4 (copy)
			return t4[p3.status]
		end,
		stats = function(p4) -- line: 87
			return p4.loadingTime or 0
		end
	},
	[EventNames.FriendsCarouselUILoadingTime] = {
		type = DiagEventTypes.Stats,
		name = function(p5) -- line: 93
			-- upvalues: v9 (copy)
			return `{ v9 }_{ p5.fetch }`
		end,
		stats = function(p6) -- line: 96
			return p6.loadingTime or 0
		end
	},
	[EventNames.OnlineFriendsRefetchOnPresenceUpdate] = {
		type = DiagEventTypes.Counter,
		name = v10
	},
	[EventNames.OnlineFriendsRefetchOnFriendshipUpdate] = {
		type = DiagEventTypes.Counter,
		name = v11
	}
}
