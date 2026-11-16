local parent = script.Parent.Parent
local parent2 = parent.Parent

local dependencies = require(parent.dependencies)
local EventNames = require(script.Parent.EventNames)
local SocialLuaAnalytics = require(parent2.SocialLuaAnalytics)
local DiagEventTypes = SocialLuaAnalytics.Analytics.Enums.DiagEventTypes

local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry

local DiagActionList = {
	[EventNames.CarouselLoadedWithUsers] = {
		name = game:DefineFastString("PYMKCarouselLoadedWithUsers", "PYMKCarouselLoadedWithUsers")
	},
	[EventNames.UserPressed] = {
		name = game:DefineFastString("PYMKCarouselUserPressed", "PYMKCarouselUserPressed")
	},
	[EventNames.RequestFriendship] = {
		name = game:DefineFastString("PYMKCarouselRequestFriendship", "PYMKCarouselRequestFriendship")
	},
	[EventNames.PYMKCarouselLoadingTime] = {
		type = DiagEventTypes.Stats,
		name = EventNames.PYMKCarouselLoadingTime.rawValue(),
		stats = function(p)
			return p.loadingTime or 0
		end,
		platformSpecificity = SocialLuaAnalytics.Analytics.Enums.PlatformSpecificity.BucketsOnly
	}
}

if getFFlagPYMKAddFriendsEntry() then
	DiagActionList[EventNames.CarouselGenericTileClicked] = {
		name = game:DefineFastString("PYMKCarouselGenericTileClicked", "PYMKCarouselGenericTileClicked")
	}
end

return DiagActionList
