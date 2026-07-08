local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent

require(InExperienceSideSheetParent.Chrome)

local GetIntegrationsStore = require(InExperienceSideSheet.Stores.GetIntegrationsStore)

return function(t1: {[any]: any}) -- line: 18
	-- upvalues: GetIntegrationsStore (copy)
	local v5 = GetIntegrationsStore()

	v5.setUnibarIntegrations(t1.unibarIntegrations)
	v5.setToggleIntegrations(t1.toggleIntegrations)
	v5.setPageIntegrations(t1.pageIntegrations)
	v5.setSessionActionIntegrations(t1.sessionActionIntegrations)
end
