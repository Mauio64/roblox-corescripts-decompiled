local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local AvatarActionBar = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/AvatarActionBar/AvatarActionBar")
local useAvatarActionBarViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/AvatarActionBar/useAvatarActionBarViewModel")

local function AvatarActionBarContainer(p2)
	local v5 = useAvatarActionBarViewModel(p2)
	return React.createElement(AvatarActionBar, v5)
end

return React.memo(AvatarActionBarContainer)
