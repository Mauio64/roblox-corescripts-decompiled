local parent = script:FindFirstAncestor("InteractionFeedback").Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)

local useTriggerFeedback = require(script.Parent.useTriggerFeedback)

local function withTriggerFeedback(p)
	return function(p2)
		local triggerFeedback = useTriggerFeedback()

		local joined = Cryo.Dictionary.join(p2, { triggerFeedback = triggerFeedback })

		return React.createElement(p, joined)
	end
end

return withTriggerFeedback
