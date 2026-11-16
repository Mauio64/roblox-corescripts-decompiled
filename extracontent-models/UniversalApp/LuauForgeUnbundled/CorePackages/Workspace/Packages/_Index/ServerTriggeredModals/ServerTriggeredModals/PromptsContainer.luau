local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local sduiFeatureEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SduiSharedUtilities").SduiFeatureEntryPoint

local Logger = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Logger")
local reportPromptImpression = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/reportPromptImpression")
local sendModalImpressionEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/ServerTriggeredModalImpressions").sendModalImpressionEvent

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags")
local fFlagEnableHomepagePromptsForModalsAndBanners = SharedFlags.FFlagEnableHomepagePromptsForModalsAndBanners
local fFlagPromptsHandlerEnabled = SharedFlags.FFlagPromptsHandlerEnabled
local FFlagPromptsActionEventLogging = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Flags/FFlagPromptsActionEventLogging")

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
	local v6 = {
		configKey = props.configKey,
		identifier = 0,
		appPage = 0,
		additionalAnalyticsData = 0,
		shouldDisplayLoading = false,
		shouldDisplayError = false
	}

	local v7 = if fFlagEnableHomepagePromptsForModalsAndBanners or fFlagPromptsHandlerEnabled then props.modalId else nil
	v6.identifier = v7

	v6.appPage = props.appPage
	v6.additionalAnalyticsData = FFlagPromptsActionEventLogging and {
		promptInstanceId = modalId or nil
	} or nil
	return createElement(sduiFeatureEntryPoint, v6)
end

return React.memo(PromptsContainer)
