local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local ServerTriggeredModalsParent = ServerTriggeredModals.Parent
local React = require(ServerTriggeredModalsParent.React)
local SduiFeatureEntryPoint = require(ServerTriggeredModalsParent.SduiSharedUtilities).SduiFeatureEntryPoint
local Logger = require(ServerTriggeredModals.Logger)
local reportPromptImpression = require(ServerTriggeredModals.reportPromptImpression)
local sendModalImpressionEvent = require(ServerTriggeredModals.sendModalImpressionEvent)
local SharedFlags = require(ServerTriggeredModalsParent.SharedFlags)
local FFlagEnableHomepagePromptsForModalsAndBanners = SharedFlags.FFlagEnableHomepagePromptsForModalsAndBanners
local FFlagPromptsHandlerEnabled = SharedFlags.FFlagPromptsHandlerEnabled

local function PromptsContainer(t1: {[any]: any}) -- line: 46
	-- upvalues: React (copy), reportPromptImpression (copy), Logger (copy), sendModalImpressionEvent (copy), SduiFeatureEntryPoint (copy), FFlagEnableHomepagePromptsForModalsAndBanners (copy), FFlagPromptsHandlerEnabled (copy)
	local modalId = t1.modalId
	local modalType = t1.modalType

	React.useEffect(function() -- line: 50
		-- upvalues: modalId (copy), modalType (copy), reportPromptImpression (copy), Logger (copy), sendModalImpressionEvent (copy)
		if modalId and modalType then
			reportPromptImpression(modalType, modalId):catch(function() -- line: 52
				-- upvalues: Logger (copy)
				Logger:warning("Failed to report prompt impression")
			end)
			sendModalImpressionEvent(modalId, modalType)
		end
	end, {
		modalId,
		modalType
	})

	return React.createElement(SduiFeatureEntryPoint, {
		shouldDisplayLoading = false,
		shouldDisplayError = false,
		configKey = t1.configKey,
		identifier = if not FFlagEnableHomepagePromptsForModalsAndBanners and not FFlagPromptsHandlerEnabled then nil else t1.modalId,
		appPage = t1.appPage
	})
end

return React.memo(PromptsContainer)
