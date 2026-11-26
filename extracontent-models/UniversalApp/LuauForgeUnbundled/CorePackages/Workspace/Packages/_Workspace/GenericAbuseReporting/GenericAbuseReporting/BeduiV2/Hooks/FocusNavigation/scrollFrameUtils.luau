local gamepadUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/InputUi").Gamepad.GamepadUtils

return {
	getScrollableAncestor = function(scrollingFrame)
		if scrollingFrame == nil then
			return nil
		end

		if scrollingFrame:IsA("ScrollingFrame") then
			return scrollingFrame
		end

		return scrollingFrame:FindFirstAncestorWhichIsA("ScrollingFrame")
	end,
	canScrollVertically = function(data): boolean
		if data.ScrollingEnabled then
			return data.AbsoluteCanvasSize.Y > data.AbsoluteWindowSize.Y
		end

		return false
	end,
	clampCanvasY = function(p2, value)
		return (math.clamp(value, 0, (math.max(0, p2.AbsoluteCanvasSize.Y - p2.AbsoluteWindowSize.Y))))
	end,
	scrollByIncrement = function(state, p2)
		if state == nil then
			return
		end

		local v5 = state.AbsoluteCanvasSize.Y - state.AbsoluteWindowSize.Y

		if p2 > 0 then
			local y = state.CanvasPosition.Y

			if v5 - 350 <= y then
				state.CanvasPosition = Vector2.new(0, v5)
				return
			end
		end

		if p2 < 0 and state.CanvasPosition.Y <= 350 then
			state.CanvasPosition = Vector2.new(0, 0)
		else
			state.CanvasPosition += Vector2.new(0, p2)
		end
	end,
	scrollByAnalogInput = function(state, p2, p3)
		if state ~= nil then
			local v5

			if state.ScrollingEnabled then
				v5 = state.AbsoluteCanvasSize.Y > state.AbsoluteWindowSize.Y
			else
				v5 = false
			end

			if v5 then
				local vector2 = Vector2.new(p2.Position.X, p2.Position.Y)
				local stickByDeadzone = gamepadUtils.normalizeStickByDeadzone(vector2)

				if stickByDeadzone.Y == 0 then
					return
				end

				local v6 = math.clamp(
					state.CanvasPosition.Y + p3 * -stickByDeadzone.Y * 1000,
					0,
					(math.max(0, state.AbsoluteCanvasSize.Y - state.AbsoluteWindowSize.Y))
				)
				state.CanvasPosition = Vector2.new(state.CanvasPosition.X, v6)
			end
		end
	end,
	isInsideContainer = function(instance, ancestor)
		if instance == nil or ancestor == nil then
			return false
		end

		return instance == ancestor or instance:IsDescendantOf(ancestor)
	end,
	resolveScrollTarget = function(scrollingFrame, ancestor)
		if ancestor == nil then
			return nil
		end

		local v5

		if scrollingFrame == nil or ancestor == nil then
			v5 = false
		else
			v5 = scrollingFrame == ancestor or scrollingFrame:IsDescendantOf(ancestor)
		end

		if not v5 then
			return nil
		end

		if scrollingFrame == nil then
			scrollingFrame = nil
		elseif not scrollingFrame:IsA("ScrollingFrame") then
			scrollingFrame = scrollingFrame:FindFirstAncestorWhichIsA("ScrollingFrame")
		end

		if scrollingFrame == nil then
			return nil
		end

		if scrollingFrame == ancestor or scrollingFrame:IsDescendantOf(ancestor) then
			return scrollingFrame
		end

		return nil
	end,
	SCROLL_INCREMENT = 300,
	STICK_MAX_SPEED = 1000
}
