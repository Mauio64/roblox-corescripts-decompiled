local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")

local defineFastInt = game:DefineFastInt("BuildHistoryLoadTriggerViewportHeightPercent", 100)

return {
	getBottomCanvasPosition = function(p2)
		return (math.max(0, p2.AbsoluteCanvasSize.Y - p2.AbsoluteWindowSize.Y))
	end,
	getDistanceFromBottom = function(data)
		return (math.max(
			0,
			math.max(0, data.AbsoluteCanvasSize.Y - data.AbsoluteWindowSize.Y) - data.CanvasPosition.Y
		))
	end,
	getOffsetInViewport = function(p2, p3)
		return p3.AbsolutePosition.Y - p2.AbsolutePosition.Y
	end,
	isScrolledToBottom = function(data): boolean
		return math.max(
			0,
			math.max(0, data.AbsoluteCanvasSize.Y - data.AbsoluteWindowSize.Y) - data.CanvasPosition.Y
		) <= chatConstants.BOTTOM_SCROLL_THRESHOLD
	end,
	isScrolledToTop = function(p2): boolean
		return p2.CanvasPosition.Y <= 0
	end,
	isScrolledNearTop = function(p2): boolean
		return p2.CanvasPosition.Y / p2.AbsoluteWindowSize.Y <= defineFastInt / 100
	end,
	scrollToBottom = function(state)
		state.CanvasPosition = Vector2.new(
			0,
			(math.max(0, state.AbsoluteCanvasSize.Y - state.AbsoluteWindowSize.Y))
		)
	end,
	syncScrollFromBottom = function(state, p2)
		local v5 = math.max(0, state.AbsoluteCanvasSize.Y - state.AbsoluteWindowSize.Y)

		if p2 <= chatConstants.BOTTOM_SCROLL_THRESHOLD then
			state.CanvasPosition = Vector2.new(0, v5)
		else
			state.CanvasPosition = Vector2.new(0, (math.max(0, v5 - p2)))
		end
	end
}
