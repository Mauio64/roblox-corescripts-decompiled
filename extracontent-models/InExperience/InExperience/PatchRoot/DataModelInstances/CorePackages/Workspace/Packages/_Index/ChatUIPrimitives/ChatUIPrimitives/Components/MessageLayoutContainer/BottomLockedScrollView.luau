local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local ChatUIPrimitivesParent = ChatUIPrimitives.Parent
local React = require(ChatUIPrimitivesParent.React)
local Foundation = require(ChatUIPrimitivesParent.Foundation)

require(ChatUIPrimitives.Types)

local function isNearBottom(p1) -- line: 12
	local AbsoluteWindowSizeY = p1.AbsoluteWindowSize.Y
	local AbsoluteCanvasSizeY = p1.AbsoluteCanvasSize.Y

	if AbsoluteCanvasSizeY <= AbsoluteWindowSizeY then
		return true
	end

	return p1.CanvasPosition.Y / (AbsoluteCanvasSizeY - AbsoluteWindowSizeY) >= 0.9
end
local function BottomLockedScrollView(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), Foundation (copy)
	local v11 = React.useRef(nil)
	local v12 = React.useRef(true)
	local v13 = React.useCallback(function(p2) -- line: 31
		-- upvalues: v12 (copy)
		local v17 = v12
		local AbsoluteWindowSizeY = p2.AbsoluteWindowSize.Y
		local AbsoluteCanvasSizeY = p2.AbsoluteCanvasSize.Y

		v17.current = AbsoluteCanvasSizeY <= AbsoluteWindowSizeY or p2.CanvasPosition.Y / (AbsoluteCanvasSizeY - AbsoluteWindowSizeY) >= 0.9
	end, {})
	local v14 = React.useCallback(function(p3) -- line: 35
		-- upvalues: v12 (copy)
		if v12.current then
			p3.CanvasPosition = Vector2.new(0, 9007199254740992)
		end
	end, {})

	React.useEffect(function() -- line: 42
		-- upvalues: v11 (copy)
		local current = v11.current

		if current then
			current.CanvasPosition = Vector2.new(0, 9007199254740992)
		end
	end, {})

	local children = t1.children

	if t1.contentPadding then
		children = {
			paddedContent = React.createElement(Foundation.View, {
				tag = "auto-y",
				Size = UDim2.fromScale(1, 0),
				padding = t1.contentPadding
			}, t1.children)
		}
	end

	return React.createElement(Foundation.ScrollView, {
		tag = "fill",
		scrollBarVisibility = "Auto",
		Size = t1.Size or UDim2.fromScale(1, 1),
		scrollingFrameRef = v11,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(0, 0)
		},
		onCanvasPositionChanged = v13,
		onAbsoluteCanvasSizeChanged = v14
	}, children)
end

return React.memo(BottomLockedScrollView)
