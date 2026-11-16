local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local PromptsEntryPoint = require(script.Parent.PromptsEntryPoint)
require(script.Parent.Types.PromptsTypes)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase

local NotificationsUpsell = require(parent.NotificationsUpsell)
local NativePushNotificationPermissionPrompt = NotificationsUpsell.NativePushNotificationPermissionPrompt

local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local parsePageEntriesFromResponse = SduiSharedUtilities.SduiProtobufResponseHelpers.parsePageEntriesFromResponse

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiAllowNoConfigsBuilt = SharedFlags.FFlagSduiAllowNoConfigsBuilt
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEdpGameLeavePromptsHandlerEnabled = SharedFlags2.FFlagEdpGameLeavePromptsHandlerEnabled
local SharedFlags3 = require(parent.SharedFlags)
local FFlagEdpOpenPromptsHandlerEnabled = SharedFlags3.FFlagEdpOpenPromptsHandlerEnabled

local SharedFlags4 = require(parent.SharedFlags)
local FFlagNotificationStreamPromptsHandlerEnabled = SharedFlags4.FFlagNotificationStreamPromptsHandlerEnabled

local SharedFlags5 = require(parent.SharedFlags)
local FFlagHomepagePromptsHandlerPassClientAttributes = SharedFlags5.FFlagHomepagePromptsHandlerPassClientAttributes
local SharedFlags6 = require(parent.SharedFlags)
local FFlagSduiExtendedCapabilitiesPrompts = SharedFlags6.FFlagSduiExtendedCapabilitiesPrompts

local SharedFlags7 = require(parent.SharedFlags)
local FFlagPushNotificationsUpsellHomePromptsExperiment = SharedFlags7.FFlagPushNotificationsUpsellHomePromptsExperiment
local SharedFlags8 = require(parent.SharedFlags)
local FFlagSplitPaneEducationalTour = SharedFlags8.FFlagSplitPaneEducationalTour
local SplitPaneTourPrompt

if FFlagSplitPaneEducationalTour then
	SplitPaneTourPrompt = require(script.Parent.SplitPaneTourPrompt)
else
	SplitPaneTourPrompt = nil
end

local SharedFlags9 = require(parent.SharedFlags)
local FFlagPromptsEdpOpenReplaceOnFetch = SharedFlags9.FFlagPromptsEdpOpenReplaceOnFetch

local function getPromptsUrl(entryPoint, p, promptStyles)
	local query = { entryPoint = entryPoint }

	if promptStyles ~= nil then
		query.promptStyle = table.concat(promptStyles, ",")
	end

	local v = urlBuilder.new({ base = UrlBase.APIS, path = "modals-api/v1/prompts", query = query })()

	if p == nil then
		return v
	end

	return `{v}&clientAttributes={HttpService:UrlEncode(HttpService:JSONEncode(p))}`
end

local function fetchPrompts(data, flag: boolean?)
	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local getEligiblePromptsResponse = ServiceContractsProto.apppageplatform.prompts.prompts.GetEligiblePromptsResponse
	local getEligiblePromptsRequest = ServiceContractsProto.apppageplatform.prompts.prompts.GetEligiblePromptsRequest
	local client_capabilities

	if FFlagSduiExtendedCapabilitiesPrompts then
		client_capabilities = SduiSharedUtilities.SduiCapabilities.buildClientCapabilities()
	end

	local v = {
		entry_points = { data.entryPoint },
		client_attributes = data.clientAttributes,
		client_capabilities = client_capabilities,
		prompt_styles = data.promptStyles
	}

	local fetchIfNeeded = getSduiApiStore().fetchIfNeeded
	local v2 = {
		responseType = SduiResponseType.ProtobufJson,
		url = 0,
		surfaceKey = 0,
		configKey = 0,
		clearOnEmptyResponse = 0,
		replaceOnFetch = 0,
		allowNoConfigsBuilt = 0,
		loadTimer = 0,
		apiProto = 0,
		parsePageEntriesFromResponse = 0,
		postConfig = 0
	}
	local url

	if FFlagSduiExtendedCapabilitiesPrompts then
		url = urlBuilder.new({ base = UrlBase.APIS, path = "modals-api/v1/prompts" })()
	elseif
		FFlagEdpGameLeavePromptsHandlerEnabled
		or FFlagEdpOpenPromptsHandlerEnabled
		or FFlagHomepagePromptsHandlerPassClientAttributes
		or FFlagNotificationStreamPromptsHandlerEnabled and data.entryPoint == PromptsEntryPoint.NotificationStreamOpen
	then
		url = getPromptsUrl(data.entryPoint, data.clientAttributes, data.promptStyles)
	else
		url = getPromptsUrl(data.entryPoint, nil, data.promptStyles)
	end

	v2.url = url

	v2.surfaceKey = data.surfaceKey
	v2.configKey = data.configKey
	v2.clearOnEmptyResponse = data.clearOnEmptyResponse
	local replaceOnFetch

	if FFlagPromptsEdpOpenReplaceOnFetch then
		replaceOnFetch = data.replaceOnFetch
	end

	v2.replaceOnFetch = replaceOnFetch
	local allowNoConfigsBuilt

	if FFlagSduiAllowNoConfigsBuilt then
		allowNoConfigsBuilt = data.allowNoConfigsBuilt
	end

	v2.allowNoConfigsBuilt = allowNoConfigsBuilt
	v2.loadTimer = data.loadTimer
	v2.apiProto = getEligiblePromptsResponse
	v2.parsePageEntriesFromResponse = data.entryPoint == PromptsEntryPoint.HomepageLaunch
		and (FFlagPushNotificationsUpsellHomePromptsExperiment and NativePushNotificationPermissionPrompt.isEnabled() or FFlagSplitPaneEducationalTour)
		and function(p)
			if
				FFlagPushNotificationsUpsellHomePromptsExperiment
				and NativePushNotificationPermissionPrompt.isEnabled()
			then
				NativePushNotificationPermissionPrompt.handlePromptsResponse(p)
			end

			if FFlagSplitPaneEducationalTour then
				SplitPaneTourPrompt.handlePromptsResponse(p)
			end

			return parsePageEntriesFromResponse(p)
		end
		or nil

	v2.postConfig = FFlagSduiExtendedCapabilitiesPrompts
		and {
			contentType = SduiSharedUtilities.SduiApiStorePostConfigContentType.Proto,
			protoMessage = getEligiblePromptsRequest,
			body = getEligiblePromptsRequest.new(v)
		}
		or nil
	fetchIfNeeded(v2, flag)
end

return fetchPrompts
