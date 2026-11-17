local Foundation = script:FindFirstAncestor("Foundation")

local DragIntent = require(Foundation.Enums.DragIntent)
require(Foundation.Enums.InternalDrawerSide)
local contentLock = require(script.Parent.contentLock)
local gestureInput = require(script.Parent.gestureInput)
local swipeMath = require(script.Parent.swipeMath)

local function showCapture(p, visible: boolean) -- 2 equivalent calls inferred from this helper
	local current = p.captureRef.current

	if current ~= nil then
		current.Visible = visible
	end
end

local function releaseLock(state) -- 2 equivalent calls inferred from this helper
	local unlock = state.unlock
	state.unlock = nil

	task.defer(function()
		if unlock ~= nil then
			unlock()
		end

		showCapture(state, false) -- inferred equivalent call
	end)
end

local function claim(state) -- 1 equivalent call inferred from this helper
	state.latest.current.onClaim()
	state.unlock = contentLock.lock(state.panelRef.current, state.backdropRef.current, state.scrollingFrameRef.current)
	showCapture(state, true) -- inferred equivalent call
end

local DismissSwipeHandlers = {}

function DismissSwipeHandlers.onInputBegan(state, p): boolean
	if not gestureInput.canBegin(state.gesture, p) then
		return false
	end

	local current = state.panelRef.current

	if current == nil then
		return false
	end

	local current2 = state.backdropRef.current
	local position = p.Position
	local inside = gestureInput.isInside(current, position)
	local v

	if current2 == nil then
		v = false
	else
		v = gestureInput.isInside(current2, position)
	end

	if
		not (inside or v)
		or gestureInput.isForeignHit(current, gestureInput.topGuiAt(current, position, current2), current2)
	then
		return false
	end

	state.gesture = gestureInput.beginGesture(p, os.clock())
	return true
end

function DismissSwipeHandlers.onInputChanged(state, p)
	local gesture = state.gesture

	if gesture == nil or not gestureInput.matchesMove(p, gesture.input) then
		return
	end

	local current = state.latest.current
	local v, v2, v3 = gestureInput.move(gesture, p, swipeMath.closeSign(current.side))

	if v then
		claim(state) -- inferred equivalent call
	end

	if not v2 then
		return
	end

	local distanceAlong = swipeMath.distanceAlong(swipeMath.closeSign(current.side), gesture.startX, v3)
	gestureInput.setProgressIfChanged(gesture, current.setDrag, 1 - swipeMath.progress(distanceAlong, current.travel))
end

function DismissSwipeHandlers.onInputEnded(state, p): boolean
	local gesture = state.gesture

	if gesture == nil or not gestureInput.matchesRelease(p, gesture.input) then
		return false
	end

	state.gesture = nil

	if gesture.intent ~= DragIntent.Claim then
		return true
	end

	releaseLock(state) -- inferred equivalent call
	local current = state.latest.current

	if not current.isOpen then
		return true
	end

	local shouldCommit = swipeMath.shouldCommit(
		gesture,
		swipeMath.closeSign(current.side),
		current.travel,
		current.distanceFraction,
		current.velocityThreshold,
		os.clock()
	)

	current.onRelease(shouldCommit)
	return true
end

function DismissSwipeHandlers.reset(state)
	local gesture = state.gesture
	state.gesture = nil

	if gesture ~= nil and gesture.intent == DragIntent.Claim then
		releaseLock(state) -- inferred equivalent call
		state.latest.current.onCancel()
	end
end

return DismissSwipeHandlers
