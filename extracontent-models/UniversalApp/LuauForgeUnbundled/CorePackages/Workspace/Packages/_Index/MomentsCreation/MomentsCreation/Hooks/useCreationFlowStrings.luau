local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Localization").Hooks.useLocalization

local creationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/creationFlowStrings")

local function useCreationFlowStrings()
	return useLocalization(creationFlowStrings)
end

return useCreationFlowStrings
