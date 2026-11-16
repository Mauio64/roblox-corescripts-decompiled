local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
local Logger = require(ServerTriggeredModals.Logger)
local reportPromptImpression = require(ServerTriggeredModals.reportPromptImpression)
local ServerTriggeredModalImpressions = require(parent.ServerTriggeredModalImpressions)
local sendModalImpressionEvent = ServerTriggeredModalImpressions.sendModalImpressionEvent

return {
	handlePromptsResponse = function(p)
		if type(p) ~= "table" or type(p.custom_prompts) ~= "table" then
			return
		end

		local currentUserId = localUserIdStore.getCurrentUserId(false)

		if not (currentUserId ~= "" and p.custom_prompts.SplitPaneEducationalTour ~= nil) then
			return
		end

		local SplitPane = require(parent.SplitPane)
		local splitPaneEducationalTourStore = SplitPane.getSplitPaneEducationalTourStore(false)

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
