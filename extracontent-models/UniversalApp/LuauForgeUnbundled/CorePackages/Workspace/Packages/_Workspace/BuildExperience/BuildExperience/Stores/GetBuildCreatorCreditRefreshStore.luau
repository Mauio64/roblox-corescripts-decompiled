local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local createBuildCreatorCreditRefreshStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildCreatorCreditRefreshStore/createBuildCreatorCreditRefreshStore")

return Signals.createComputed(function()
	return createBuildCreatorCreditRefreshStore()
end)
