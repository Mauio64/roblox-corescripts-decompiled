local HttpService = game:GetService("HttpService")

local PromptsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsEntryPoint")
require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/Types/PromptsTypes")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SduiSharedUtilities")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/UrlBuilder").UrlBase

local nativePushNotificationPermissionPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/NotificationsUpsell").NativePushNotificationPermissionPrompt

local sduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local parsePageEntriesFromResponse = SduiSharedUtilities.SduiProtobufResponseHelpers.parsePageEntriesFromResponse

local fFlagSduiAllowNoConfigsBuilt = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FFlagSduiAllowNoConfigsBuilt
local fFlagEdpGameLeavePromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FFlagEdpGameLeavePromptsHandlerEnabled
local fFlagEdpOpenPromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FFlagEdpOpenPromptsHandlerEnabled

local fFlagNotificationStreamPromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FFlagNotificationStreamPromptsHandlerEnabled

local fFlagHomepagePromptsHandlerPassClientAttributes = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FFlagHomepagePromptsHandlerPassClientAttributes
local fFlagSduiExtendedCapabilitiesPrompts = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FFlagSduiExtendedCapabilitiesPrompts

local fFlagPushNotificationsUpsellHomePromptsExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FFlagPushNotificationsUpsellHomePromptsExperiment
local fFlagSplitPaneEducationalTour = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FFlagSplitPaneEducationalTour

local v5 = if fFlagSplitPaneEducationalTour then require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/SplitPaneTourPrompt") else nil

local fFlagPromptsEdpOpenReplaceOnFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FFlagPromptsEdpOpenReplaceOnFetch

local function getPromptsUrl(entryPoint, p2, promptStyles)
	local v6 = { entryPoint = entryPoint }

	if promptStyles ~= nil then
		v6.promptStyle = table.concat(promptStyles, ",")
	end

	local v7 = urlBuilder.new({
		base = urlBase.APIS,
		path = "modals-api/v1/prompts",
		query = v6
	})()

	if p2 == nil then
		return v7
	end

	return `{v7}&clientAttributes={HttpService:UrlEncode(HttpService:JSONEncode(p2))}`
end

local function fetchPrompts(data, p2)
	local ServiceContractsProto = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/ServiceContractsProto")
	local getEligiblePromptsResponse = ServiceContractsProto.apppageplatform.prompts.prompts.GetEligiblePromptsResponse
	local getEligiblePromptsRequest = ServiceContractsProto.apppageplatform.prompts.prompts.GetEligiblePromptsRequest

	local v6 = if fFlagSduiExtendedCapabilitiesPrompts then SduiSharedUtilities.SduiCapabilities.buildClientCapabilities() else nil

	local v7 = {
		entry_points = { data.entryPoint },
		client_attributes = data.clientAttributes,
		client_capabilities = v6,
		prompt_styles = data.promptStyles
	}

	local fetchIfNeeded = getSduiApiStore().fetchIfNeeded
	local v8 = {
		responseType = sduiResponseType.ProtobufJson,
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
	local v9

	if fFlagSduiExtendedCapabilitiesPrompts then
		v9 = urlBuilder.new({ base = urlBase.APIS, path = "modals-api/v1/prompts" })()
	elseif
		fFlagEdpGameLeavePromptsHandlerEnabled
		or fFlagEdpOpenPromptsHandlerEnabled
		or fFlagHomepagePromptsHandlerPassClientAttributes
		or fFlagNotificationStreamPromptsHandlerEnabled and data.entryPoint == PromptsEntryPoint.NotificationStreamOpen
	then
		v9 = getPromptsUrl(data.entryPoint, data.clientAttributes, data.promptStyles)
	else
		v9 = getPromptsUrl(data.entryPoint, nil, data.promptStyles)
	end

	v8.url = v9

	v8.surfaceKey = data.surfaceKey
	v8.configKey = data.configKey
	v8.clearOnEmptyResponse = data.clearOnEmptyResponse
	local v10 = if fFlagPromptsEdpOpenReplaceOnFetch then data.replaceOnFetch else nil
	v8.replaceOnFetch = v10
	local v11 = if fFlagSduiAllowNoConfigsBuilt then data.allowNoConfigsBuilt else nil
	v8.allowNoConfigsBuilt = v11
	v8.loadTimer = data.loadTimer
	v8.apiProto = getEligiblePromptsResponse
	v8.parsePageEntriesFromResponse = data.entryPoint == PromptsEntryPoint.HomepageLaunch
		and (fFlagPushNotificationsUpsellHomePromptsExperiment and nativePushNotificationPermissionPrompt.isEnabled() or fFlagSplitPaneEducationalTour)
		and function(p3)
			if
				fFlagPushNotificationsUpsellHomePromptsExperiment
				and nativePushNotificationPermissionPrompt.isEnabled()
			then
				nativePushNotificationPermissionPrompt.handlePromptsResponse(p3)
			end

			if fFlagSplitPaneEducationalTour then
				v5.handlePromptsResponse(p3)
			end

			return parsePageEntriesFromResponse(p3)
		end
		or nil

	v8.postConfig = fFlagSduiExtendedCapabilitiesPrompts
		and {
			contentType = SduiSharedUtilities.SduiApiStorePostConfigContentType.Proto,
			protoMessage = getEligiblePromptsRequest,
			body = getEligiblePromptsRequest.new(v7)
		}
		or nil
	fetchIfNeeded(v8, p2)
end

return fetchPrompts
