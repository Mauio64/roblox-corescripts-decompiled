local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local dataHydrationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration").DataHydrationUtils
local createBuildModelSelectionStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildModelSelectionStore/createBuildModelSelectionStore")

return Signals.createComputed(function()
	local v6 = if game.GameId > 0 then dataHydrationUtils.getLocalPlayerUserId() else nil
	return createBuildModelSelectionStore(v6)
end)
