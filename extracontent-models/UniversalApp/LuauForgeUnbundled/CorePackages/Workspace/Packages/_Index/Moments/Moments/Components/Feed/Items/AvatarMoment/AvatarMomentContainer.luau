local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local AvatarMomentView = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/AvatarMomentView")
local useAvatarMomentViewModel = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/useAvatarMomentViewModel")

local function AvatarMomentContainer(p2)
	local v5 = useAvatarMomentViewModel(p2)
	return React.createElement(AvatarMomentView, v5)
end

return AvatarMomentContainer
