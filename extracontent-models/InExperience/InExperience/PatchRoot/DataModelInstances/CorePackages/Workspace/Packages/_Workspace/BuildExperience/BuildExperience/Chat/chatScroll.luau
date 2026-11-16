local chatConstants = require(script.Parent.chatConstants)

local defineFastInt = game:DefineFastInt("BuildHistoryLoadTriggerViewportHeightPercent", 100)

local function getBottomCanvasPosition(p) -- 3 equivalent calls inferred from this helper
	return (math.max(0, p.AbsoluteCanvasSize.Y - p.AbsoluteWindowSize.Y))
end

local function getDistanceFromBottom(p) -- 1 equivalent call inferred from this helper
	return (math.max(0, getBottomCanvasPosition(p) - p.CanvasPosition.Y)) -- inferred equivalent call
end

local ChatScroll = {}
ChatScroll.getBottomCanvasPosition = getBottomCanvasPosition
ChatScroll.getDistanceFromBottom = getDistanceFromBottom

function ChatScroll.getOffsetInViewport(p, p2)
	return p2.AbsolutePosition.Y - p.AbsolutePosition.Y
end

function ChatScroll.isScrolledToBottom(p): boolean
	return getDistanceFromBottom(p) <= chatConstants.BOTTOM_SCROLL_THRESHOLD -- inferred equivalent call
end

function ChatScroll.isScrolledToTop(p): boolean
	return p.CanvasPosition.Y <= 0
end

function ChatScroll.isScrolledNearTop(p): boolean
	return p.CanvasPosition.Y / p.AbsoluteWindowSize.Y <= defineFastInt / 100
end

function ChatScroll.scrollToBottom(p)
	p.CanvasPosition = Vector2.new(0, getBottomCanvasPosition(p)) -- inferred equivalent call
end

function ChatScroll.syncScrollFromBottom(p, p2: number)
	local bottomCanvasPosition = getBottomCanvasPosition(p) -- inferred equivalent call

	if p2 <= chatConstants.BOTTOM_SCROLL_THRESHOLD then
		p.CanvasPosition = Vector2.new(0, bottomCanvasPosition)
	else
		p.CanvasPosition = Vector2.new(0, (math.max(0, bottomCanvasPosition - p2)))
	end
end

return ChatScroll
