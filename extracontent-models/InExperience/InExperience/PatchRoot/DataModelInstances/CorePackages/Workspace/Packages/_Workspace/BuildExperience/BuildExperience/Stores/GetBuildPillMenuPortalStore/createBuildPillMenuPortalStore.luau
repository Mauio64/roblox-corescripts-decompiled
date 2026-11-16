local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)

local function createBuildPillMenuPortalStore()
	local signal, setPortalTarget = Signals.createSignal(nil)

	return { getPortalTarget = signal, setPortalTarget = setPortalTarget }
end

return createBuildPillMenuPortalStore
