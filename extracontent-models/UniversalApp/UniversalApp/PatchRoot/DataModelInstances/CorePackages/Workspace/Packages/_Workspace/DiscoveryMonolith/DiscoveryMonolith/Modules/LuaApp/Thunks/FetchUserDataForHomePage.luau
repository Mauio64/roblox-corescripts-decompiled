local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Logger = require(DiscoveryMonolithParent.Loggers).Logger
local AvatarThumbnailRequests = require(DiscoveryMonolithParent.UserLib).Utils.AvatarThumbnailRequests
local PreloadUsersThumbnail = require(DiscoveryMonolithParent.UserLib).Thunks.PreloadUsersThumbnail
local FetchFriendsCarousel = require(DiscoveryMonolithParent.FriendsCarousel).FetchFriendsCarousel
local Modules = DiscoveryMonolith.Modules
local FetchAdditionalFriendsInfo = require(Modules.LuaApp.Thunks.FetchAdditionalFriendsInfo)
local LegacyUpdateUsers = require(Modules.LuaApp.Thunks.LegacyUpdateUsers)
local v10 = game:DefineFastFlag("RemoveFetchFriendsCarouselAtStartup", false)
local v11 = Logger:new(script.Name)

local function fetchUserDataForHomePage(p1, p2, p3) -- line: 15
	-- upvalues: v10 (copy), FetchFriendsCarousel (copy), LegacyUpdateUsers (copy), FetchAdditionalFriendsInfo (copy), v11 (copy), PreloadUsersThumbnail (copy), AvatarThumbnailRequests (copy)
	if not v10 then
		p3:dispatch(FetchFriendsCarousel()):andThen(function(p4) -- line: 19
			-- upvalues: p3 (copy), LegacyUpdateUsers (copy), FetchAdditionalFriendsInfo (copy), p1 (copy)
			p3:dispatch(LegacyUpdateUsers(p4))
			p3:dispatch(FetchAdditionalFriendsInfo(p1, p4))

			return p4
		end):catch(function(p5) -- line: 24
			-- upvalues: v11 (copy)
			v11:error(`Error fetching friends sort: { p5 }`)
		end)
	end

	p3:dispatch(PreloadUsersThumbnail({ p2 }, AvatarThumbnailRequests.HOME_HEADER_USER))
	p3:dispatch(PreloadUsersThumbnail({ p2 }, AvatarThumbnailRequests.CUSTOMIZE_BUTTON))
end

return function(p6, p7) -- line: 33
	-- upvalues: fetchUserDataForHomePage (copy)
	return function(p8) -- line: 34
		-- upvalues: fetchUserDataForHomePage (copy), p6 (copy), p7 (copy)
		return fetchUserDataForHomePage(p6, p7, p8)
	end
end
