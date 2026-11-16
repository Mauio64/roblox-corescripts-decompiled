local createSduiFocusActivationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/FocusNavigation/createSduiFocusActivationStore")

local sduiFocusActivationStore = nil

local function getSduiFocusActivationStore()
	if sduiFocusActivationStore == nil then
		sduiFocusActivationStore = createSduiFocusActivationStore()
	end

	return sduiFocusActivationStore
end

return getSduiFocusActivationStore
