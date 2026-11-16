local defineFastFlag = game:DefineFastFlag("FriendCarouselHas10ftPolicies", false)

local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local AppCommonLib = require(FriendsCarousel.Parent.AppCommonLib)
local isTenFootInterface = AppCommonLib.isTenFootInterface
return function()
	if defineFastFlag then
		return isTenFootInterface()
	end

	return false
end
