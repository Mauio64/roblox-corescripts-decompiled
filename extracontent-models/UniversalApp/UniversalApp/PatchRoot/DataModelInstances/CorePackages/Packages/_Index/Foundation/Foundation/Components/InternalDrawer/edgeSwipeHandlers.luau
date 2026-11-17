local Foundation = script:FindFirstAncestor("Foundation")

local DragIntent = require(Foundation.Enums.DragIntent)
require(Foundation.Enums.InternalDrawerSide)
local gestureInput = require(script.Parent.gestureInput)
local swipeMath = require(script.Parent.swipeMath)
local EdgeSwipeHandlers = {}

function EdgeSwipeHandlers.onInputBegan(state, p): boolean
	if not gestureInput.canBegin(state.gesture, p) then
		return false
	end

	local current = state.latest.current

	if current.isOpen then
		return false
	end

	local current2 = state.edgeRef.current

	if current2 == nil then
		return false
	end

	local position = p.Position

	if
		not gestureInput.isInside(current2, position)
		or gestureInput.isForeignHit(current2, gestureInput.topGuiAt(current2, position), nil)
	then
		return false
	end

	state.gesture = gestureInput.beginGesture(p, os.clock())
	current.onPress()
	return true
end

function EdgeSwipeHandlers.onInputChanged(p, p2)
	local gesture = p.gesture

	if gesture == nil or not gestureInput.matchesMove(p2, gesture.input) then
		return
	end

	local current = p.latest.current
	local v, v2, v3 = gestureInput.move(gesture, p2, swipeMath.openSign(current.side))

	if v then
		current.onClaim()
	end

	if not v2 then
		return
	end

	local distanceAlong = swipeMath.distanceAlong(swipeMath.openSign(current.side), gesture.startX, v3)
	gestureInput.setProgressIfChanged(gesture, current.setDrag, swipeMath.progress(distanceAlong, current.travel))
end

function EdgeSwipeHandlers.onInputEnded(state, p): boolean
	local gesture = state.gesture

	if gesture == nil or not gestureInput.matchesRelease(p, gesture.input) then
		return false
	end

	state.gesture = nil
	local current = state.latest.current

	if gesture.intent ~= DragIntent.Claim then
		current.onPressEnd()
		return true
	end

	if swipeMath.shouldCommit(
		gesture,
		swipeMath.openSign(current.side),
		current.travel,
		current.distanceFraction,
		current.velocityThreshold,
		os.clock()
	) then
		current.onCommit()
	else
		current.onDragCancel()
	end

	return true
end

function EdgeSwipeHandlers.reset(state)
	local gesture = state.gesture
	state.gesture = nil

	if gesture == nil then
		return
	end

	local current = state.latest.current

	if gesture.intent == DragIntent.Claim then
		current.onDragCancel()
	else
		current.onPressEnd()
	end
end

return EdgeSwipeHandlers
