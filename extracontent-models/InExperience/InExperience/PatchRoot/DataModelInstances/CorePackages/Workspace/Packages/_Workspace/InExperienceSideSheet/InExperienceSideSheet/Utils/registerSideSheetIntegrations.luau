local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local parent = InExperienceSideSheet.Parent

require(parent.Chrome)

local GetIntegrationsStore = require(InExperienceSideSheet.Stores.GetIntegrationsStore)

return function(data)
	local integrationsStore = GetIntegrationsStore()

	integrationsStore.setUnibarIntegrations(data.unibarIntegrations)
	integrationsStore.setAboveFoldIntegrations(data.aboveFoldIntegrations)
	integrationsStore.setBelowFoldIntegrations(data.belowFoldIntegrations)
	integrationsStore.setSessionActionIntegrations(data.sessionActionIntegrations)
	integrationsStore.setScrollableContentTopWidgetIntegrations(data.scrollableContentTopWidgetIntegrations)
	integrationsStore.setScrollableContentBottomWidgetIntegrations(data.scrollableContentBottomWidgetIntegrations)
end
