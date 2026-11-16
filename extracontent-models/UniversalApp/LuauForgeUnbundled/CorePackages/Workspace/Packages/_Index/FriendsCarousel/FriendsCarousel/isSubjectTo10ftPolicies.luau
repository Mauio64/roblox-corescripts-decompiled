local defineFastFlag = game:DefineFastFlag("FriendCarouselHas10ftPolicies", false)

local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/AppCommonLib").isTenFootInterface
return function()
	if defineFastFlag then
		return isTenFootInterface()
	end

	return false
end
