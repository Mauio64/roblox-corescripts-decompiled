local updatePromptAssignment = require("@luauforge/bundled/fEu").Thunks.UpdatePromptAssignment
local promptType = require("@luauforge/bundled/fEu").Enum.PromptType
local promptAssignmentAction = require("@luauforge/bundled/fEu").Enum.PromptAssignmentAction
local HttpService = game:GetService("HttpService")
local logger = require("@luauforge/bundled/fEo").Logger

local function updateCooldown(p2, callback)
	return callback(updatePromptAssignment(
		p2,
		promptType.PasskeyUpsell,
		promptAssignmentAction.DismissPrompt
	)):catch(function(p3)
		logger:debug("Error updating passkey upsell prompt cooldown {}", HttpService:JSONEncode(p3))
	end)
end

return updateCooldown
