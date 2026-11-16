local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local React = require(parent.React)

local CreationControllerContext = require(MomentsCreation.CreationController.CreationControllerContext)
require(MomentsCreation.Types.CreationFlowTypes)

local function useCreationController()
	local v = React.useContext(CreationControllerContext)
	assert(v ~= nil, "useCreationController must be used within a CreationControllerProvider")
	return v
end

return useCreationController
