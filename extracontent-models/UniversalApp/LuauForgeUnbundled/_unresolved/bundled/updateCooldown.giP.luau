local updatePromptAssignment = require("@luauforge/bundled/giO").Thunks.UpdatePromptAssignment
local promptType = require("@luauforge/bundled/giO").Enum.PromptType
local promptAssignmentAction = require("@luauforge/bundled/giO").Enum.PromptAssignmentAction
local HttpService = game:GetService("HttpService")
local logger = require("@luauforge/bundled/giI").Logger

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
