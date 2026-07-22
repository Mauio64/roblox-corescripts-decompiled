local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

require(script.Parent.PromptsEntryPoint)
require(script.Parent.Types.PromptsTypes)

local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local UrlBase = require(Parent.UrlBuilder).UrlBase
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local FFlagSduiAllowNoConfigsBuilt = require(Parent.SharedFlags).FFlagSduiAllowNoConfigsBuilt
local FFlagEdpGameLeavePromptsHandlerEnabled = require(Parent.SharedFlags).FFlagEdpGameLeavePromptsHandlerEnabled

local function getPromptsUrl(p1, t1: {[any]: any}?) -- line: 29
	-- upvalues: UrlBuilder (copy), UrlBase (copy), HttpService (copy)
	local v14 = UrlBuilder.new({
		path = "modals-api/v1/prompts",
		base = UrlBase.APIS,
		query = {
			entryPoint = p1
		}
	})()

	if t1 == nil then
		return v14
	end

	return `{ v14 }&clientAttributes={ HttpService:UrlEncode(HttpService:JSONEncode(t1)) }`
end
local function fetchPrompts(p2, b1: boolean?) -- line: 46
	-- upvalues: Parent (copy), getSduiApiStore (copy), SduiResponseType (copy), FFlagEdpGameLeavePromptsHandlerEnabled (copy), getPromptsUrl (copy), UrlBuilder (copy), UrlBase (copy), FFlagSduiAllowNoConfigsBuilt (copy)
	local GetEligiblePromptsResponse = require(Parent.ServiceContractsProto).apppageplatform.prompts.prompts.GetEligiblePromptsResponse
	local fetchIfNeeded = getSduiApiStore().fetchIfNeeded
	local t2 = {
		responseType = SduiResponseType.ProtobufJson
	}
	local v20

	if FFlagEdpGameLeavePromptsHandlerEnabled then
		v20 = getPromptsUrl(p2.entryPoint, p2.clientAttributes)
	else
		local entryPoint = p2.entryPoint

		v20 = UrlBuilder.new({
			path = "modals-api/v1/prompts",
			base = UrlBase.APIS,
			query = {
				entryPoint = entryPoint
			}
		})()
	end

	t2.url = v20
	t2.surfaceKey = p2.surfaceKey
	t2.configKey = p2.configKey
	t2.clearOnEmptyResponse = p2.clearOnEmptyResponse
	t2.allowNoConfigsBuilt = if not FFlagSduiAllowNoConfigsBuilt then nil else p2.allowNoConfigsBuilt
	t2.loadTimer = p2.loadTimer
	t2.apiProto = GetEligiblePromptsResponse
	fetchIfNeeded(t2, b1)
end

return fetchPrompts
