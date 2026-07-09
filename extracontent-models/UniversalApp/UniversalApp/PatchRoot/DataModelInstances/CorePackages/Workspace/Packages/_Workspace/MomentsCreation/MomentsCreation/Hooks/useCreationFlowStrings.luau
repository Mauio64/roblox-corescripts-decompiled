local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local useLocalization = require(MomentsCreationParent.Localization).Hooks.useLocalization
local creationFlowStrings = require(MomentsCreation.creationFlowStrings)

local function useCreationFlowStrings() -- line: 10
	-- upvalues: useLocalization (copy), creationFlowStrings (copy)
	return useLocalization(creationFlowStrings)
end

return useCreationFlowStrings
