local chatConstants = require(script.Parent.chatConstants)

return {
	getBottomCanvasPosition = function(p1) -- line: 3
		return (math.max(0, p1.AbsoluteCanvasSize.Y - p1.AbsoluteWindowSize.Y))
	end,
	getDistanceFromBottom = function(p2) -- line: 7
		return (math.max(0, math.max(0, p2.AbsoluteCanvasSize.Y - p2.AbsoluteWindowSize.Y) - p2.CanvasPosition.Y))
	end,
	isScrolledToBottom = function(p3) -- line: 11
		-- upvalues: chatConstants (copy)
		return math.max(0, math.max(0, p3.AbsoluteCanvasSize.Y - p3.AbsoluteWindowSize.Y) - p3.CanvasPosition.Y) <= chatConstants.BOTTOM_SCROLL_THRESHOLD
	end,
	isScrolledToTop = function(p4) -- line: 15
		return p4.CanvasPosition.Y <= 0
	end,
	scrollToBottom = function(p5) -- line: 19
		p5.CanvasPosition = Vector2.new(0, (math.max(0, p5.AbsoluteCanvasSize.Y - p5.AbsoluteWindowSize.Y)))
	end,
	syncScrollFromBottom = function(p6, n1: number) -- line: 24
		-- upvalues: chatConstants (copy)
		local v9 = math.max(0, p6.AbsoluteCanvasSize.Y - p6.AbsoluteWindowSize.Y)

		if n1 <= chatConstants.BOTTOM_SCROLL_THRESHOLD then
			p6.CanvasPosition = Vector2.new(0, v9)

			return
		end

		p6.CanvasPosition = Vector2.new(0, (math.max(0, v9 - n1)))
	end
}
