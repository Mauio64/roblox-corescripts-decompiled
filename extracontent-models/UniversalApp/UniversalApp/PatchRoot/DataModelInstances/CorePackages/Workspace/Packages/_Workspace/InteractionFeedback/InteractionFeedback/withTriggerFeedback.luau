local Parent = script:FindFirstAncestor("InteractionFeedback").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local useTriggerFeedback = require(script.Parent.useTriggerFeedback)

local function withTriggerFeedback(p1) -- line: 8
	-- upvalues: useTriggerFeedback (copy), Cryo (copy), React (copy)
	return function(p2) -- line: 9
		-- upvalues: useTriggerFeedback (copy), Cryo (copy), React (copy), p1 (copy)
		local v8 = useTriggerFeedback()
		local v9 = Cryo.Dictionary.join(p2, {
			triggerFeedback = v8
		})

		return React.createElement(p1, v9)
	end
end

return withTriggerFeedback
