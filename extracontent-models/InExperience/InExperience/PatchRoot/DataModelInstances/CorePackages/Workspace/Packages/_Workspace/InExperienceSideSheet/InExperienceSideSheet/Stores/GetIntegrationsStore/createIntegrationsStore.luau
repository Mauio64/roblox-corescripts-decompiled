local parent = script:FindFirstAncestor("InExperienceSideSheet").Parent

require(parent.Chrome)
local Signals = require(parent.Signals)

local function createIntegrationsStore()
	local signal, setUnibarIntegrations = Signals.createSignal({})
	local signal2, setAboveFoldIntegrations = Signals.createSignal({})
	local signal3, setBelowFoldIntegrations = Signals.createSignal({})

	local signal4, setSessionActionIntegrations = Signals.createSignal({})

	local signal5, setScrollableContentTopWidgetIntegrations = Signals.createSignal({})

	local signal6, setScrollableContentBottomWidgetIntegrations = Signals.createSignal({})

	return {
		getUnibarIntegrations = signal,
		setUnibarIntegrations = setUnibarIntegrations,
		getAboveFoldIntegrations = signal2,
		setAboveFoldIntegrations = setAboveFoldIntegrations,
		getBelowFoldIntegrations = signal3,
		setBelowFoldIntegrations = setBelowFoldIntegrations,
		getSessionActionIntegrations = signal4,
		setSessionActionIntegrations = setSessionActionIntegrations,
		getScrollableContentTopWidgetIntegrations = signal5,
		setScrollableContentTopWidgetIntegrations = setScrollableContentTopWidgetIntegrations,
		getScrollableContentBottomWidgetIntegrations = signal6,
		setScrollableContentBottomWidgetIntegrations = setScrollableContentBottomWidgetIntegrations
	}
end

return createIntegrationsStore
