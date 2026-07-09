local Parent = script:FindFirstAncestor("PasskeyUpsell").Parent
local Logger = require(Parent.Loggers).Logger
local GetPromptAssignments = require(Parent.PromptAssignments).Thunks.GetPromptAssignments
local PromptType = require(Parent.PromptAssignments).Enum.PromptType

local function hasCooldown(p1, p2) -- line: 14
	-- upvalues: GetPromptAssignments (copy), PromptType (copy), Logger (copy)
	return p2:dispatch(GetPromptAssignments(p1)):andThen(function(p3) -- line: 17
		-- upvalues: PromptType (copy), Logger (copy)
		for _, v in ipairs(p3) do
			if v and PromptType.fromRawValue(v.promptType) == PromptType.PasskeyUpsell then
				Logger:info("User does NOT have a cooldown for passkey upsell.")

				return false
			end
		end

		Logger:info("User has a cooldown for passkey upsell.")

		return true
	end):catch(function(p4) -- line: 29
		-- upvalues: Logger (copy)
		Logger:debug("Error checking for passkey cooldown: {}", p4)

		return false
	end)
end

return hasCooldown
