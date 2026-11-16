local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent

require(SduiSharedUtilities.SduiLoadTimer)
local createTemplateApiPrewarmRequestConfig = require(SduiSharedUtilities.createTemplateApiPrewarmRequestConfig)
local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)
local Promise = require(parent.Promise)

local function fetchSduiTemplates(p, flag: boolean?)
	local templateApiPrewarmRequestConfig = createTemplateApiPrewarmRequestConfig(p)

	if templateApiPrewarmRequestConfig == nil then
		return Promise.reject("No valid SDUI surfaceKeys provided")
	end

	return getSduiApiStore().fetchIfNeeded(templateApiPrewarmRequestConfig, flag)
end

return fetchSduiTemplates
