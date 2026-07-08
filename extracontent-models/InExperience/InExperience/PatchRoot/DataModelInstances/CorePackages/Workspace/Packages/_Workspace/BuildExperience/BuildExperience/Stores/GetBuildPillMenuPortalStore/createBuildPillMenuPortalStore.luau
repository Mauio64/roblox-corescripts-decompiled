local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)

local function createBuildPillMenuPortalStore() -- line: 11
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal(nil)

	return {
		getPortalTarget = v4,
		setPortalTarget = v5
	}
end

return createBuildPillMenuPortalStore
