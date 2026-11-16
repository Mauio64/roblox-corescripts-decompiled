local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local InputUi = require(parent.InputUi)
local GamepadUtils = InputUi.Gamepad.GamepadUtils

local function getScrollableAncestor(scrollingFrame) -- 1 equivalent call inferred from this helper
	if scrollingFrame == nil then
		return nil
	end

	if scrollingFrame:IsA("ScrollingFrame") then
		return scrollingFrame
	end

	return scrollingFrame:FindFirstAncestorWhichIsA("ScrollingFrame")
end

local function canScrollVertically(data): boolean -- 1 equivalent call inferred from this helper
	if data.ScrollingEnabled then
		return data.AbsoluteCanvasSize.Y > data.AbsoluteWindowSize.Y
	end

	return false
end

local function clampCanvasY(data, value: number) -- 1 equivalent call inferred from this helper
	return (math.clamp(value, 0, (math.max(0, data.AbsoluteCanvasSize.Y - data.AbsoluteWindowSize.Y))))
end

local function isInsideContainer(instance, ancestor) -- 1 equivalent call inferred from this helper
	if instance == nil or ancestor == nil then
		return false
	end

	return instance == ancestor or instance:IsDescendantOf(ancestor)
end

local ScrollFrameUtils = {}
ScrollFrameUtils.getScrollableAncestor = getScrollableAncestor
ScrollFrameUtils.canScrollVertically = canScrollVertically
ScrollFrameUtils.clampCanvasY = clampCanvasY

function ScrollFrameUtils.scrollByIncrement(state, p: number)
	if state == nil then
		return
	end

	local v = state.AbsoluteCanvasSize.Y - state.AbsoluteWindowSize.Y

	if p > 0 then
		local y = state.CanvasPosition.Y

		if v - 350 <= y then
			state.CanvasPosition = Vector2.new(0, v)
			return
		end
	end

	if p < 0 and state.CanvasPosition.Y <= 350 then
		state.CanvasPosition = Vector2.new(0, 0)
	else
		state.CanvasPosition += Vector2.new(0, p)
	end
end

function ScrollFrameUtils.scrollByAnalogInput(data, p, p2: number)
	if data ~= nil and canScrollVertically(data) then -- inferred equivalent call
		local vector2 = Vector2.new(p.Position.X, p.Position.Y)
		local stickByDeadzone = GamepadUtils.normalizeStickByDeadzone(vector2)

		if stickByDeadzone.Y == 0 then
			return
		end

		local v = clampCanvasY(data, data.CanvasPosition.Y + p2 * -stickByDeadzone.Y * 1000) -- inferred equivalent call
		data.CanvasPosition = Vector2.new(data.CanvasPosition.X, v)
	end
end

ScrollFrameUtils.isInsideContainer = isInsideContainer

function ScrollFrameUtils.resolveScrollTarget(instance, ancestor)
	if not (ancestor ~= nil and isInsideContainer(instance, ancestor)) then -- inferred equivalent call
		return nil
	end

	instance = getScrollableAncestor(instance) -- inferred equivalent call

	if instance == nil then
		return nil
	end

	if instance == ancestor or instance:IsDescendantOf(ancestor) then
		return instance
	end

	return nil
end

ScrollFrameUtils.SCROLL_INCREMENT = 300
ScrollFrameUtils.STICK_MAX_SPEED = 1000
return ScrollFrameUtils
