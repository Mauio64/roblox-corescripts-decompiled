local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local TweenService = game:GetService("TweenService")

require(Parent.React)

local function scrollToItem(p1, p2) -- line: 13
	-- upvalues: TweenService (copy)
	if not p1 or (not p1.current or not p2) then
		return
	end

	local ScrollingFrame = p1.current:FindFirstChildWhichIsA("ScrollingFrame", true)

	if not ScrollingFrame then
		return
	end

	task.wait()

	local current = p2.current

	if not current then
		return
	end

	local AbsolutePositionY = current.AbsolutePosition.Y
	local v9 = AbsolutePositionY + current.AbsoluteSize.Y
	local AbsolutePositionY2 = ScrollingFrame.AbsolutePosition.Y
	local v11 = AbsolutePositionY2 + ScrollingFrame.AbsoluteWindowSize.Y

	if AbsolutePositionY2 <= AbsolutePositionY and v9 <= v11 then
		return
	end

	local v12 = AbsolutePositionY - ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.CanvasPosition.Y
	local v13 = v9 - ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.CanvasPosition.Y
	local CanvasPositionY = ScrollingFrame.CanvasPosition.Y

	if AbsolutePositionY < AbsolutePositionY2 then
		CanvasPositionY = v12
	elseif v11 < v9 then
		CanvasPositionY = v13 - ScrollingFrame.AbsoluteWindowSize.Y
	end

	local v15 = math.max(0, (math.min(CanvasPositionY, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y)))
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	TweenService:Create(ScrollingFrame, tweenInfo, {
		CanvasPosition = Vector2.new(0, v15)
	}):Play()
end

return scrollToItem
