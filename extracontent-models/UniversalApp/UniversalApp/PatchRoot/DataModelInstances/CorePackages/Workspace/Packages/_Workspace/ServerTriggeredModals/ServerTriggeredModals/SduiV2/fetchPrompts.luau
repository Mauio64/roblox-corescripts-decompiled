local Parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

require(script.Parent.PromptsEntryPoint)
require(script.Parent.Types.PromptsTypes)

local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local UrlBase = require(Parent.UrlBuilder).UrlBase
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local FFlagSduiAllowNoConfigsBuilt = require(Parent.SharedFlags).FFlagSduiAllowNoConfigsBuilt

local function getPromptsUrl(p1) -- line: 26
	-- upvalues: UrlBuilder (copy), UrlBase (copy)
	return UrlBuilder.new({
		path = "modals-api/v1/prompts",
		base = UrlBase.APIS,
		query = {
			entryPoint = p1
		}
	})()
end
local function fetchPrompts(p2, b1: boolean?) -- line: 37
	-- upvalues: Parent (copy), getSduiApiStore (copy), SduiResponseType (copy), getPromptsUrl (copy), FFlagSduiAllowNoConfigsBuilt (copy)
	local GetEligiblePromptsResponse = require(Parent.ServiceContractsProto).apppageplatform.prompts.prompts.GetEligiblePromptsResponse

	getSduiApiStore().fetchIfNeeded({
		responseType = SduiResponseType.ProtobufJson,
		url = getPromptsUrl(p2.entryPoint),
		surfaceKey = p2.surfaceKey,
		configKey = p2.configKey,
		clearOnEmptyResponse = p2.clearOnEmptyResponse,
		allowNoConfigsBuilt = if not FFlagSduiAllowNoConfigsBuilt then nil else p2.allowNoConfigsBuilt,
		loadTimer = p2.loadTimer,
		apiProto = GetEligiblePromptsResponse
	}, b1)
end

return fetchPrompts
