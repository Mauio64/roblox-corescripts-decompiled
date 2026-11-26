local logger = require("@luauforge/bundled/giI").Logger
local getPromptAssignments = require("@luauforge/bundled/giO").Thunks.GetPromptAssignments
local promptType = require("@luauforge/bundled/giO").Enum.PromptType

local function hasCooldown(p2, object)
	return object:dispatch(getPromptAssignments(p2)):andThen(function(list): boolean
		for i, item in ipairs(list) do
			if item and promptType.fromRawValue(item.promptType) == promptType.PasskeyUpsell then
				logger:info("User does NOT have a cooldown for passkey upsell.")
				return false
			end
		end

		logger:info("User has a cooldown for passkey upsell.")
		return true
	end):catch(function(p3): boolean
		logger:debug("Error checking for passkey cooldown: {}", p3)

		return false
	end)
end

return hasCooldown
