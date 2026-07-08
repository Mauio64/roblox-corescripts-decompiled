local Parent = script:FindFirstAncestor("InteractionFeedback").Parent
local SharedFlags = require(Parent.SharedFlags)
local triggerFeedback = require(script.Parent.triggerFeedback)
local InteractionFeedbackContext = require(script.Parent.InteractionFeedbackContext)
local RoactUtils = require(Parent.RoactUtils)
local useInputType = RoactUtils.Hooks.useInputType
local useLaserPointerHand = RoactUtils.Hooks.useLaserPointerHand
local React = require(Parent.React)
local isSpatial = require(Parent.AppCommonLib).isSpatial
local FFlagLuaAppHapticTriggeredTelemetry = SharedFlags.FFlagLuaAppHapticTriggeredTelemetry

local function useHapticPositionAndRadius() -- line: 18
	-- upvalues: useInputType (copy), useLaserPointerHand (copy), React (copy), isSpatial (copy)
	local v13 = useInputType()
	local v14 = useLaserPointerHand()

	return (React.useMemo(function() -- line: 21
		-- upvalues: isSpatial (copy), v14 (copy)
		if isSpatial() then
			if v14 == "Right" then
				return {
					Vector3.new(1, 0, 0),
					0.1
				}
			end

			return {
				Vector3.new(-1, 0, 0),
				0.1
			}
		end

		return {
			Vector3.new(0, 0, 0),
			100
		}
	end, {
		v13,
		v14
	}))
end
local function useTriggerFeedback() -- line: 38
	-- upvalues: React (copy), InteractionFeedbackContext (copy), useHapticPositionAndRadius (copy), triggerFeedback (copy), FFlagLuaAppHapticTriggeredTelemetry (copy)
	local v15 = React.useContext(InteractionFeedbackContext)
	local v16 = useHapticPositionAndRadius()
	local u17 = v16[1]
	local u18 = v16[2]

	if not v15 then
		error("useTriggerFeedback must be used within an InteractionFeedbackProvider")
	end

	return (React.useCallback(function(s1: string, p1, s2: string?, t1: {[any]: any}?) -- line: 52
		-- upvalues: triggerFeedback (copy), v15 (copy), u17 (ref), u18 (ref), FFlagLuaAppHapticTriggeredTelemetry (copy)
		return triggerFeedback(s1, p1, v15, u17, u18, if not FFlagLuaAppHapticTriggeredTelemetry then nil else s2, if not FFlagLuaAppHapticTriggeredTelemetry then nil else t1)
	end, {
		v15,
		u17,
		u18
	}))
end

return useTriggerFeedback
