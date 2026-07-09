local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local React = require(MomentsCreationParent.React)
local CreationControllerContext = require(MomentsCreation.CreationController.CreationControllerContext)

require(MomentsCreation.Types.CreationFlowTypes)

local function useCreationController() -- line: 14
	-- upvalues: React (copy), CreationControllerContext (copy)
	local v6 = React.useContext(CreationControllerContext)

	assert(v6 ~= nil, "useCreationController must be used within a CreationControllerProvider")

	return v6
end

return useCreationController
