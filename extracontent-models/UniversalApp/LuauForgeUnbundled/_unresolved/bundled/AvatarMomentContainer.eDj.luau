local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local AvatarMomentView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/AvatarMomentView")
local useAvatarMomentViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/useAvatarMomentViewModel")

local function AvatarMomentContainer(p2)
	local v5 = useAvatarMomentViewModel(p2)
	return React.createElement(AvatarMomentView, v5)
end

return AvatarMomentContainer
