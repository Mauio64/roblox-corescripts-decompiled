local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/React")

local useTriggerFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/InteractionFeedback/useTriggerFeedback")

local function withTriggerFeedback(p2)
	return function(p3)
		local v5 = useTriggerFeedback()

		local joined = Cryo.Dictionary.join(p3, { triggerFeedback = v5 })

		return React.createElement(p2, joined)
	end
end

return withTriggerFeedback
