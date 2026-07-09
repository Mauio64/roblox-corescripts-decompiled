local Parent = script:FindFirstAncestor("PasskeyUpsell").Parent
local UpdatePromptAssignment = require(Parent.PromptAssignments).Thunks.UpdatePromptAssignment
local PromptType = require(Parent.PromptAssignments).Enum.PromptType
local PromptAssignmentAction = require(Parent.PromptAssignments).Enum.PromptAssignmentAction
local HttpService = game:GetService("HttpService")
local Logger = require(Parent.Loggers).Logger

local function updateCooldown(p1, p2) -- line: 14
	-- upvalues: UpdatePromptAssignment (copy), PromptType (copy), PromptAssignmentAction (copy), Logger (copy), HttpService (copy)
	return p2(UpdatePromptAssignment(p1, PromptType.PasskeyUpsell, PromptAssignmentAction.DismissPrompt)):catch(function(p3) -- line: 16
		-- upvalues: Logger (copy), HttpService (copy)
		Logger:debug("Error updating passkey upsell prompt cooldown {}", HttpService:JSONEncode(p3))
	end)
end

return updateCooldown
