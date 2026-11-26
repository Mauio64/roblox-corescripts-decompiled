local HttpService = game:GetService("HttpService")

local PromptsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsEntryPoint")
require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/Types/PromptsTypes")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SduiSharedUtilities")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/UrlBuilder").UrlBase

local nativePushNotificationPermissionPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/NotificationsUpsell").NativePushNotificationPermissionPrompt
local chatPushUpsellLegacyPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/NotificationsUpsell").ChatPushUpsellLegacyPrompt

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

local FFlagPlusUpsellSheetHomePrompt = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Flags/FFlagPlusUpsellSheetHomePrompt")

local v6 = if FFlagPlusUpsellSheetHomePrompt then require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PlusUpsellSheetPrompt") else nil

local fFlagPromptsEdpOpenReplaceOnFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FFlagPromptsEdpOpenReplaceOnFetch
local fFlagChatPushUpsellPromptsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FFlagChatPushUpsellPromptsEnabled

local function getPromptsUrl(entryPoint, p2, promptStyles)
	local v7 = { entryPoint = entryPoint }

	if promptStyles ~= nil then
		v7.promptStyle = table.concat(promptStyles, ",")
	end

	local v8 = urlBuilder.new({
		base = urlBase.APIS,
		path = "modals-api/v1/prompts",
		query = v7
	})()

	if p2 == nil then
		return v8
	end

	return `{v8}&clientAttributes={HttpService:UrlEncode(HttpService:JSONEncode(p2))}`
end

local function isChatLandingRequest(p2)
	return fFlagChatPushUpsellPromptsEnabled and p2.entryPoint == PromptsEntryPoint.ChatLandingOpen
end

local function getParsePageEntriesFromResponse(data)
	if fFlagChatPushUpsellPromptsEnabled and data.entryPoint == PromptsEntryPoint.ChatLandingOpen then
		return function(p2)
			chatPushUpsellLegacyPrompt.handlePromptsResponse(p2)
			return parsePageEntriesFromResponse(p2)
		end
	end

	if
		data.entryPoint == PromptsEntryPoint.HomepageLaunch
		and (fFlagPushNotificationsUpsellHomePromptsExperiment and nativePushNotificationPermissionPrompt.isEnabled() or fFlagSplitPaneEducationalTour or FFlagPlusUpsellSheetHomePrompt)
	then
		return function(p2)
			if
				fFlagPushNotificationsUpsellHomePromptsExperiment
				and nativePushNotificationPermissionPrompt.isEnabled()
			then
				nativePushNotificationPermissionPrompt.handlePromptsResponse(p2)
			end

			if fFlagSplitPaneEducationalTour then
				v5.handlePromptsResponse(p2)
			end

			if FFlagPlusUpsellSheetHomePrompt then
				v6.handlePromptsResponse(p2)
			end

			return parsePageEntriesFromResponse(p2)
		end
	end

	return nil
end

local function fetchPrompts(data, p2)
	local ServiceContractsProto = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/ServiceContractsProto")
	local getEligiblePromptsResponse = ServiceContractsProto.apppageplatform.prompts.prompts.GetEligiblePromptsResponse
	local getEligiblePromptsRequest = ServiceContractsProto.apppageplatform.prompts.prompts.GetEligiblePromptsRequest

	local v7 = if fFlagSduiExtendedCapabilitiesPrompts then SduiSharedUtilities.SduiCapabilities.buildClientCapabilities() else nil

	local v8 = {
		entry_points = { data.entryPoint },
		client_attributes = data.clientAttributes,
		client_capabilities = v7,
		prompt_styles = data.promptStyles
	}

	local fetchIfNeeded = getSduiApiStore().fetchIfNeeded
	local v9 = {
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
	local v10

	if fFlagSduiExtendedCapabilitiesPrompts then
		v10 = urlBuilder.new({ base = urlBase.APIS, path = "modals-api/v1/prompts" })()
	elseif
		fFlagEdpGameLeavePromptsHandlerEnabled
		or fFlagEdpOpenPromptsHandlerEnabled
		or fFlagHomepagePromptsHandlerPassClientAttributes
		or fFlagChatPushUpsellPromptsEnabled and data.entryPoint == PromptsEntryPoint.ChatLandingOpen
		or fFlagNotificationStreamPromptsHandlerEnabled and data.entryPoint == PromptsEntryPoint.NotificationStreamOpen
	then
		v10 = getPromptsUrl(data.entryPoint, data.clientAttributes, data.promptStyles)
	else
		v10 = getPromptsUrl(data.entryPoint, nil, data.promptStyles)
	end

	v9.url = v10

	v9.surfaceKey = data.surfaceKey
	v9.configKey = data.configKey
	v9.clearOnEmptyResponse = data.clearOnEmptyResponse
	local v11 = if fFlagPromptsEdpOpenReplaceOnFetch then data.replaceOnFetch else nil
	v9.replaceOnFetch = v11
	local v12 = if fFlagSduiAllowNoConfigsBuilt then data.allowNoConfigsBuilt else nil
	v9.allowNoConfigsBuilt = v12
	v9.loadTimer = data.loadTimer
	v9.apiProto = getEligiblePromptsResponse
	v9.parsePageEntriesFromResponse = getParsePageEntriesFromResponse(data)
	v9.postConfig = fFlagSduiExtendedCapabilitiesPrompts
		and {
			contentType = SduiSharedUtilities.SduiApiStorePostConfigContentType.Proto,
			protoMessage = getEligiblePromptsRequest,
			body = getEligiblePromptsRequest.new(v8)
		}
		or nil
	fetchIfNeeded(v9, p2)
end

return fetchPrompts
