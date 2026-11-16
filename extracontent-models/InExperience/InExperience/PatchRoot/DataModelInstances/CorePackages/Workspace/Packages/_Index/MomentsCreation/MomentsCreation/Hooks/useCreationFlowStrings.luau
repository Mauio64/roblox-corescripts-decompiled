local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Localization = require(parent.Localization)

local useLocalization = Localization.Hooks.useLocalization

local creationFlowStrings = require(MomentsCreation.creationFlowStrings)

local function useCreationFlowStrings()
	return useLocalization(creationFlowStrings)
end

return useCreationFlowStrings
