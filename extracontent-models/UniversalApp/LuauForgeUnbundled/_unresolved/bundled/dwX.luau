local logger = require("@luauforge/bundled/duw").Logger
local avatarThumbnailRequests = require("@game/CorePackages/Workspace/Packages/UserLib").Utils.AvatarThumbnailRequests
local preloadUsersThumbnail = require("@game/CorePackages/Workspace/Packages/UserLib").Thunks.PreloadUsersThumbnail
local fetchFriendsCarousel = require("@luauforge/bundled/dwY").FetchFriendsCarousel

local module = require("@luauforge/bundled/dwO")
local ApiFetchUsersFriends = require("@game/CoreGui/RobloxGui/Modules/Settings/Pages/ShareGame/Thunks/ApiFetchUsersFriends")
local defineFastFlag = game:DefineFastFlag("RemoveFetchFriendsCarouselAtStartup", false)

local v5 = logger:new("FetchUserDataForHomePage")

local function fetchUserDataForHomePage(p2, p3, object)
	if not defineFastFlag then
		object:dispatch(fetchFriendsCarousel()):andThen(function(p4)
			object:dispatch(ApiFetchUsersFriends(p4))
			object:dispatch(module(p2, p4))
			return p4
		end):catch(function(p4)
			v5:error(`Error fetching friends sort: {p4}`)
		end)
	end

	object:dispatch(preloadUsersThumbnail({ p3 }, avatarThumbnailRequests.HOME_HEADER_USER))
	object:dispatch(preloadUsersThumbnail({ p3 }, avatarThumbnailRequests.CUSTOMIZE_BUTTON))
end

return function(p2, p3)
	return function(p4)
		return fetchUserDataForHomePage(p2, p3, p4)
	end
end
