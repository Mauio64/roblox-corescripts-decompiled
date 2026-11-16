local TweenService = game:GetService("TweenService")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local function scrollToItem(p2, p3)
	if not (p2 and p2.current and p3) then
		return
	end

	local scrollingFrame = p2.current:FindFirstChildWhichIsA("ScrollingFrame", true)

	if not scrollingFrame then
		return
	end

	task.wait()

	local current = p3.current

	if not current then
		return
	end

	local y = current.AbsolutePosition.Y
	local v5 = y + current.AbsoluteSize.Y
	local y2 = scrollingFrame.AbsolutePosition.Y
	local v6 = y2 + scrollingFrame.AbsoluteWindowSize.Y

	if y2 <= y and v5 <= v6 then
		return
	end

	local v7 = y - scrollingFrame.AbsolutePosition.Y + scrollingFrame.CanvasPosition.Y
	local v8 = v5 - scrollingFrame.AbsolutePosition.Y + scrollingFrame.CanvasPosition.Y

	local v9 = scrollingFrame.CanvasPosition.Y

	if y < y2 then
		v9 = v7
	elseif v6 < v5 then
		v9 = v8 - scrollingFrame.AbsoluteWindowSize.Y
	end

	local v10 = math.max(
		0,
		(math.min(v9, scrollingFrame.AbsoluteCanvasSize.Y - scrollingFrame.AbsoluteWindowSize.Y))
	)

	TweenService:Create(
		scrollingFrame,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ CanvasPosition = Vector2.new(0, v10) }
	):Play()
end

return scrollToItem
