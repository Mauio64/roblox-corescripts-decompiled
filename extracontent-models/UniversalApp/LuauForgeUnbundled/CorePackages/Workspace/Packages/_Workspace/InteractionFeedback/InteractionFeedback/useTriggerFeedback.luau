local triggerFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/InteractionFeedback/triggerFeedback")
local InteractionFeedbackContext = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/InteractionFeedback/InteractionFeedbackContext")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/RoactUtils")
local useInputType = RoactUtils.Hooks.useInputType
local useLaserPointerHand = RoactUtils.Hooks.useLaserPointerHand
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/React")
local isSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/AppCommonLib").isSpatial

local function useHapticPositionAndRadius()
	local v5 = useInputType()
	local v6 = useLaserPointerHand()
	return (React.useMemo(function()
		if not isSpatial() then
			return { Vector3.new(0, 0, 0), 100 }
		end

		if v6 == "Right" then
			return { Vector3.new(1, 0, 0), 0.1 }
		end

		return { Vector3.new(-1, 0, 0), 0.1 }
	end, { v5, v6 }))
end

local function useTriggerFeedback()
	local v5 = React.useContext(InteractionFeedbackContext)

	local v6 = useHapticPositionAndRadius()
	local v7 = v6[1]
	local v8 = v6[2]

	if not v5 then
		error("useTriggerFeedback must be used within an InteractionFeedbackProvider")
	end

	return (React.useCallback(function(p2, p3, p4, p5)
		return triggerFeedback(p2, p3, v5, v7, v8, p4, p5)
	end, { v5, v7, v8 }))
end

return useTriggerFeedback
