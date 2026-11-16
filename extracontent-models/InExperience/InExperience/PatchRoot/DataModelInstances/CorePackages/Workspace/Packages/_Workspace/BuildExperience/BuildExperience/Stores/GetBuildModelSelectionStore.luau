local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local DataHydration = require(parent.DataHydration)
local DataHydrationUtils = DataHydration.DataHydrationUtils
local createBuildModelSelectionStore = require(script.createBuildModelSelectionStore)

return Signals.createComputed(function()
	local v

	if game.GameId > 0 then
		v = DataHydrationUtils.getLocalPlayerUserId()
	end

	return createBuildModelSelectionStore(v)
end)
