local Parent = script:FindFirstAncestor("InExperienceSideSheet").Parent

require(Parent.Chrome)

local Signals = require(Parent.Signals)

local function createIntegrationsStore() -- line: 21
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal({})
	local v6, v7 = Signals.createSignal({})
	local v8, v9 = Signals.createSignal({})
	local v10, v11 = Signals.createSignal({})

	return {
		getUnibarIntegrations = v4,
		setUnibarIntegrations = v5,
		getToggleIntegrations = v6,
		setToggleIntegrations = v7,
		getPageIntegrations = v8,
		setPageIntegrations = v9,
		getSessionActionIntegrations = v10,
		setSessionActionIntegrations = v11
	}
end

return createIntegrationsStore
