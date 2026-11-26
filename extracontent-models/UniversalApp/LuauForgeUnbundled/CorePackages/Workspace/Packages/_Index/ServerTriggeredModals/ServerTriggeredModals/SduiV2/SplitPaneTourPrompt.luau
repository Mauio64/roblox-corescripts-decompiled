local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/LocalUserIdStore").LocalUserIdStore
local Logger = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Logger")
local reportPromptImpression = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/reportPromptImpression")
local sendModalImpressionEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/ServerTriggeredModalImpressions").sendModalImpressionEvent

return {
	handlePromptsResponse = function(p2)
		if type(p2) ~= "table" or type(p2.custom_prompts) ~= "table" then
			return
		end

		local currentUserId = localUserIdStore.getCurrentUserId(false)

		if not (currentUserId ~= "" and p2.custom_prompts.SplitPaneEducationalTour ~= nil) then
			return
		end

		local splitPaneEducationalTourStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SplitPane").getSplitPaneEducationalTourStore(false)

		if splitPaneEducationalTourStore.hasHandledCustomPromptForUser(currentUserId) then
			return
		end

		splitPaneEducationalTourStore.setHasHandledCustomPromptForUser(currentUserId, true)
		splitPaneEducationalTourStore.setPendingUserId(currentUserId)
		splitPaneEducationalTourStore.setOnTourVisible(function()
			reportPromptImpression("SplitPaneEducationalTour", "SplitPaneEducationalTour"):catch(function()
				Logger:warning("Failed to report split-pane educational prompt impression")
			end)
			sendModalImpressionEvent("SplitPaneEducationalTour", "SplitPaneEducationalTour")
		end)
		splitPaneEducationalTourStore.setIsOpen(true)
	end
}
