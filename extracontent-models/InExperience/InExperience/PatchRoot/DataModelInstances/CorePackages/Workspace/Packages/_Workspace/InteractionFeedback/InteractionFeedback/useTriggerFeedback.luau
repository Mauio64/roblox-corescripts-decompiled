local parent = script:FindFirstAncestor("InteractionFeedback").Parent

local triggerFeedback = require(script.Parent.triggerFeedback)
local InteractionFeedbackContext = require(script.Parent.InteractionFeedbackContext)
local RoactUtils = require(parent.RoactUtils)
local useInputType = RoactUtils.Hooks.useInputType
local useLaserPointerHand = RoactUtils.Hooks.useLaserPointerHand
local React = require(parent.React)
local AppCommonLib = require(parent.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial

local function useHapticPositionAndRadius()
	local v = useInputType()
	local v2 = useLaserPointerHand()
	return (React.useMemo(function()
		if not isSpatial() then
			return { Vector3.new(0, 0, 0), 100 }
		end

		if v2 == "Right" then
			return { Vector3.new(1, 0, 0), 0.1 }
		end

		return { Vector3.new(-1, 0, 0), 0.1 }
	end, { v, v2 }))
end

local function useTriggerFeedback()
	local v = React.useContext(InteractionFeedbackContext)

	local v2 = useHapticPositionAndRadius()
	local v3 = v2[1]
	local v4 = v2[2]

	if not v then
		error("useTriggerFeedback must be used within an InteractionFeedbackProvider")
	end

	return (React.useCallback(function(p: string, p2, p3: string?, p4)
		return triggerFeedback(p, p2, v, v3, v4, p3, p4)
	end, { v, v3, v4 }))
end

return useTriggerFeedback
