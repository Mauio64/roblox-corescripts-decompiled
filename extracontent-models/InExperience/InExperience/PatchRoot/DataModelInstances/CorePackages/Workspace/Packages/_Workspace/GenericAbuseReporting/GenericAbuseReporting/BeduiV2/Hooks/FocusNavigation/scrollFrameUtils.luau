local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local GamepadUtils = require(Parent.InputUi).Gamepad.GamepadUtils

return {
	SCROLL_INCREMENT = 300,
	STICK_MAX_SPEED = 1000,
	getScrollableAncestor = function(p1) -- line: 26
		if p1 == nil then
			return nil
		end

		if p1:IsA("ScrollingFrame") then
			return p1
		end

		return p1:FindFirstAncestorWhichIsA("ScrollingFrame")
	end,
	canScrollVertically = function(p2) -- line: 36
		if not p2.ScrollingEnabled then
			return false
		end

		return p2.AbsoluteCanvasSize.Y > p2.AbsoluteWindowSize.Y
	end,
	clampCanvasY = function(p3, n1: number) -- line: 44
		return (math.clamp(n1, 0, (math.max(0, p3.AbsoluteCanvasSize.Y - p3.AbsoluteWindowSize.Y))))
	end,
	scrollByIncrement = function(p4, n2: number) -- line: 51
		if p4 == nil then
			return
		end

		local v9 = p4.AbsoluteCanvasSize.Y - p4.AbsoluteWindowSize.Y

		if n2 > 0 and p4.CanvasPosition.Y >= v9 - 350 then
			p4.CanvasPosition = Vector2.new(0, v9)

			return
		end

		if n2 < 0 and p4.CanvasPosition.Y <= 350 then
			p4.CanvasPosition = Vector2.new(0, 0)

			return
		end

		p4.CanvasPosition = p4.CanvasPosition + Vector2.new(0, n2)
	end,
	scrollByAnalogInput = function(p5, p6, n3: number) -- line: 69
		-- upvalues: GamepadUtils (copy)
		if p5 == nil or not if p5.ScrollingEnabled then p5.AbsoluteCanvasSize.Y > p5.AbsoluteWindowSize.Y else false then
			return
		end

		local vector2 = Vector2.new(p6.Position.X, p6.Position.Y)
		local v14 = GamepadUtils.normalizeStickByDeadzone(vector2)

		if v14.Y == 0 then
			return
		end

		local v15 = math.clamp(p5.CanvasPosition.Y + n3 * -v14.Y * 1000, 0, (math.max(0, p5.AbsoluteCanvasSize.Y - p5.AbsoluteWindowSize.Y)))

		p5.CanvasPosition = Vector2.new(p5.CanvasPosition.X, v15)
	end,
	isInsideContainer = function(p7, p8) -- line: 87
		if p7 == nil or p8 == nil then
			return false
		end

		return p7 == p8 or p7:IsDescendantOf(p8)
	end,
	resolveScrollTarget = function(p9, p10) -- line: 98
		if p10 == nil then
			return nil
		end

		if p9 == nil or (p10 == nil or p9 ~= p10 and not p9:IsDescendantOf(p10)) then
			return nil
		end

		local v20 = if p9 ~= nil then if not p9:IsA("ScrollingFrame") then p9:FindFirstAncestorWhichIsA("ScrollingFrame") else p9 else nil

		if v20 == nil then
			return nil
		end

		if v20 == p10 or v20:IsDescendantOf(p10) then
			return v20
		end

		return nil
	end
}
