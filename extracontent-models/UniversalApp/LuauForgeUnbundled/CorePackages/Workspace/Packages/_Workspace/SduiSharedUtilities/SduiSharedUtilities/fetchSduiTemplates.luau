require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiLoadTimer")
local createTemplateApiPrewarmRequestConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/createTemplateApiPrewarmRequestConfig")
local getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiApiStore")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Promise")

local function fetchSduiTemplates(p2, p3)
	local v5 = createTemplateApiPrewarmRequestConfig(p2)

	if v5 == nil then
		return Promise.reject("No valid SDUI surfaceKeys provided")
	end

	return getSduiApiStore().fetchIfNeeded(v5, p3)
end

return fetchSduiTemplates
