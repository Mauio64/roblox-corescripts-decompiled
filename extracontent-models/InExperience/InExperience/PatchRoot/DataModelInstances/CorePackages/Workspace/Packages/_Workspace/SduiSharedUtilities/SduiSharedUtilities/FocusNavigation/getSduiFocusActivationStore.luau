local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local createSduiFocusActivationStore = require(SduiSharedUtilities.FocusNavigation.createSduiFocusActivationStore)

local sduiFocusActivationStore = nil

local function getSduiFocusActivationStore()
	if sduiFocusActivationStore == nil then
		sduiFocusActivationStore = createSduiFocusActivationStore()
	end

	return sduiFocusActivationStore
end

return getSduiFocusActivationStore
