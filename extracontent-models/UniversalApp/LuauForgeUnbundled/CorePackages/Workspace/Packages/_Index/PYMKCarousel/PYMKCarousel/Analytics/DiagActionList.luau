local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/EventNames")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SocialLuaAnalytics")
local diagEventTypes = SocialLuaAnalytics.Analytics.Enums.DiagEventTypes

local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry

local v5 = {
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
		type = diagEventTypes.Stats,
		name = EventNames.PYMKCarouselLoadingTime.rawValue(),
		stats = function(p2)
			return p2.loadingTime or 0
		end,
		platformSpecificity = SocialLuaAnalytics.Analytics.Enums.PlatformSpecificity.BucketsOnly
	}
}

if getFFlagPYMKAddFriendsEntry() then
	v5[EventNames.CarouselGenericTileClicked] = {
		name = game:DefineFastString("PYMKCarouselGenericTileClicked", "PYMKCarouselGenericTileClicked")
	}
end

return v5
