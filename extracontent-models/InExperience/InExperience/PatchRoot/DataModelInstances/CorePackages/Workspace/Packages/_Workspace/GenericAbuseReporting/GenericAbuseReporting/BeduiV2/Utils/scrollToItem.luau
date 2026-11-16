local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local TweenService = game:GetService("TweenService")

require(parent.React)

local function scrollToItem(p, p2)
	if not (p and p.current and p2) then
		return
	end

	local scrollingFrame = p.current:FindFirstChildWhichIsA("ScrollingFrame", true)

	if not scrollingFrame then
		return
	end

	task.wait()

	local current = p2.current

	if not current then
		return
	end

	local y = current.AbsolutePosition.Y
	local v = y + current.AbsoluteSize.Y
	local y2 = scrollingFrame.AbsolutePosition.Y
	local v2 = y2 + scrollingFrame.AbsoluteWindowSize.Y

	if y2 <= y and v <= v2 then
		return
	end

	local v3 = y - scrollingFrame.AbsolutePosition.Y + scrollingFrame.CanvasPosition.Y
	local v4 = v - scrollingFrame.AbsolutePosition.Y + scrollingFrame.CanvasPosition.Y

	local v5 = scrollingFrame.CanvasPosition.Y

	if y < y2 then
		v5 = v3
	elseif v2 < v then
		v5 = v4 - scrollingFrame.AbsoluteWindowSize.Y
	end

	local v6 = math.max(0, (math.min(v5, scrollingFrame.AbsoluteCanvasSize.Y - scrollingFrame.AbsoluteWindowSize.Y)))

	TweenService:Create(scrollingFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		CanvasPosition = Vector2.new(0, v6)
	}):Play()
end

return scrollToItem
