local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local CreationControllerContext = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/CreationController/CreationControllerContext")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local function useCreationController()
	local v5 = React.useContext(CreationControllerContext)
	assert(v5 ~= nil, "useCreationController must be used within a CreationControllerProvider")
	return v5
end

return useCreationController
