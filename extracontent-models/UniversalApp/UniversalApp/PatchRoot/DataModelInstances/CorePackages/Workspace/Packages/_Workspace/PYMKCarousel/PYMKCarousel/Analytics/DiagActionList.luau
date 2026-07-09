local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local EventNames = require(script.Parent.EventNames)
local SocialLuaAnalytics = require(ParentParentParent.SocialLuaAnalytics)
local DiagEventTypes = SocialLuaAnalytics.Analytics.Enums.DiagEventTypes
local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry
local t1 = {
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
		stats = function(p1) -- line: 24
			return p1.loadingTime or 0
		end,
		platformSpecificity = SocialLuaAnalytics.Analytics.Enums.PlatformSpecificity.BucketsOnly
	}
}

if getFFlagPYMKAddFriendsEntry() then
	t1[EventNames.CarouselGenericTileClicked] = {
		name = game:DefineFastString("PYMKCarouselGenericTileClicked", "PYMKCarouselGenericTileClicked")
	}
end

return t1
