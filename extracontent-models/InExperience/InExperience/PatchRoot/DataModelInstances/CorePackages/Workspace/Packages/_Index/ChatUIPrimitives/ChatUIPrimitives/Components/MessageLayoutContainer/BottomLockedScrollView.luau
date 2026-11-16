local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(ChatUIPrimitives.Types)

local function isNearBottom(data): boolean -- 1 equivalent call inferred from this helper
	local y = data.AbsoluteWindowSize.Y
	local y2 = data.AbsoluteCanvasSize.Y
	return y2 <= y or data.CanvasPosition.Y / (y2 - y) >= 0.9
end

local function BottomLockedScrollView(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(true)

	local onScroll = props.onScroll
	local onCanvasPositionChanged = React.useCallback(function(data)
		ref2.current = isNearBottom(data) -- inferred equivalent call

		if onScroll and not ref2.current then
			onScroll()
		end
	end, { onScroll })

	local onAbsoluteCanvasSizeChanged = React.useCallback(function(p)
		if ref2.current then
			p.CanvasPosition = Vector2.new(0, 9007199254740992)
		end
	end, {})

	React.useEffect(function()
		local current = ref.current

		if current then
			current.CanvasPosition = Vector2.new(0, 9007199254740992)
		end
	end, {})

	local children = props.children
	local v = props.contentPadding and {
		paddedContent = React.createElement(
			Foundation.View,
			{ tag = "auto-y", Size = UDim2.fromScale(1, 0), padding = props.contentPadding },
			props.children
		)
	} or children

	return React.createElement(Foundation.ScrollView, {
		tag = "fill",
		Size = props.Size or UDim2.fromScale(1, 1),
		scrollingFrameRef = ref,
		scrollBarVisibility = "Auto",
		selection = props.selectableRows and { Selectable = false } or nil,
		scroll = { AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.fromScale(0, 0) },
		onCanvasPositionChanged = onCanvasPositionChanged,
		onAbsoluteCanvasSizeChanged = onAbsoluteCanvasSizeChanged
	}, v)
end

return React.memo(BottomLockedScrollView)
