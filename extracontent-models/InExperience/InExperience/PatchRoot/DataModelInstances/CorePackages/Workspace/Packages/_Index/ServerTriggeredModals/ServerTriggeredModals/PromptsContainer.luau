local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local React = require(parent.React)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)

local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint

local Logger = require(ServerTriggeredModals.Logger)
local reportPromptImpression = require(ServerTriggeredModals.reportPromptImpression)
local ServerTriggeredModalImpressions = require(parent.ServerTriggeredModalImpressions)
local sendModalImpressionEvent = ServerTriggeredModalImpressions.sendModalImpressionEvent

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableHomepagePromptsForModalsAndBanners = SharedFlags.FFlagEnableHomepagePromptsForModalsAndBanners
local FFlagPromptsHandlerEnabled = SharedFlags.FFlagPromptsHandlerEnabled
local FFlagPromptsActionEventLogging = require(ServerTriggeredModals.Flags.FFlagPromptsActionEventLogging)

local function PromptsContainer(props)
	local modalId = props.modalId
	local modalType = props.modalType

	React.useEffect(function()
		if modalId and modalType then
			reportPromptImpression(modalType, modalId):catch(function()
				Logger:warning("Failed to report prompt impression")
			end)
			sendModalImpressionEvent(modalId, modalType)
		end
	end, { modalId, modalType })

	local createElement = React.createElement
	local v = {
		configKey = props.configKey,
		identifier = 0,
		appPage = 0,
		additionalAnalyticsData = 0,
		shouldDisplayLoading = false,
		shouldDisplayError = false
	}
	local identifier

	if FFlagEnableHomepagePromptsForModalsAndBanners or FFlagPromptsHandlerEnabled then
		identifier = props.modalId
	end

	v.identifier = identifier

	v.appPage = props.appPage
	v.additionalAnalyticsData = FFlagPromptsActionEventLogging and {
		promptInstanceId = modalId or nil
	} or nil
	return createElement(SduiFeatureEntryPoint, v)
end

return React.memo(PromptsContainer)
