local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local createSearchQueryStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetSearchQueryStore/createSearchQueryStore")

return Signals.createComputed(function()
	return createSearchQueryStore()
end)
