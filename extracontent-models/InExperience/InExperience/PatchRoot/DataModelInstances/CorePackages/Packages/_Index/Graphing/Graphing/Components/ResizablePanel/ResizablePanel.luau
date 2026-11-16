local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local Dash = require(parent.Dash)
local React = require(parent.React)

local CanvasContext = require(Graphing.CanvasContext)
local InputDetector = require(Graphing.Components.InputDetector)
local Panel = require(Graphing.Components.Panel)
local Types = require(Graphing.Types)

local function onDrag(props, vector2: Vector2, vector2_2: Vector2)
	if not props.SetRect then
		return
	end

	local minSize = props.MinSize or Vector2.zero

	local v = props.Rect.Min.X
	local v2 = props.Rect.Min.Y
	local v3 = props.Rect.Max.X
	local v4 = props.Rect.Max.Y

	if vector2_2.X == 0 then
		v = math.min(vector2.X, v3 - minSize.X)
	end

	if vector2_2.X == 1 then
		v3 = math.max(vector2.X, v + minSize.X)
	end

	if vector2_2.Y == 0 then
		v2 = math.min(vector2.Y, v4 - minSize.Y)
	end

	if vector2_2.Y == 1 then
		v4 = math.max(vector2.Y, v2 + minSize.Y)
	end

	assert(props.SetRect ~= nil, "props.SetRect is nil")

	props.SetRect(Rect.new(v, v2, v3, v4))
end

function ResizablePanel(props)
	local v = React.useContext(CanvasContext)

	local v2 = v.getXAxisScaling().Direction == Types.DIRECTION_REVERSED
	local v3 = v.getYAxisScaling().Direction == Types.DIRECTION_REVERSED

	local onDragMoved = React.useCallback(function(vector2: Vector2)
		if not props.SetRect then
			return
		end

		assert(props.SetRect, "props.SetRect was nil")

		props.SetRect(Rect.new(vector2.X, vector2.Y, vector2.X + props.Rect.Width, vector2.Y + props.Rect.Height))
	end, { props.Rect, props.SetRect })

	local onDragMoved2 = React.useCallback(function(vector2: Vector2)
		onDrag(props, vector2, Vector2.new(v2 and 1 or 0, 0.5))
	end, { props.Rect, props.SetRect, props.MinSize, v2 })

	local onDragMoved3 = React.useCallback(function(vector2: Vector2)
		onDrag(props, vector2, Vector2.new(v2 and 0 or 1, 0.5))
	end, { props.Rect, props.SetRect, props.MinSize, v2 })

	local onDragMoved4 = React.useCallback(function(vector2: Vector2)
		onDrag(props, vector2, Vector2.new(0.5, v3 and 0 or 1))
	end, { props.Rect, props.SetRect, props.MinSize, v3 })

	local onDragMoved5 = React.useCallback(function(vector2: Vector2)
		onDrag(props, vector2, Vector2.new(0.5, v3 and 1 or 0))
	end, { props.Rect, props.SetRect, props.MinSize, v3 })

	local onDragMoved6 = React.useCallback(function(vector2: Vector2)
		onDrag(props, vector2, Vector2.new(v2 and 1 or 0, v3 and 0 or 1))
	end, { props.Rect, props.SetRect, props.MinSize, v2, v3 })

	local onDragMoved7 = React.useCallback(function(vector2: Vector2)
		onDrag(props, vector2, Vector2.new(v2 and 0 or 1, v3 and 0 or 1))
	end, { props.Rect, props.SetRect, props.MinSize, v2, v3 })

	local onDragMoved8 = React.useCallback(function(vector2: Vector2)
		onDrag(props, vector2, Vector2.new(v2 and 1 or 0, v3 and 1 or 0))
	end, { props.Rect, props.SetRect, props.MinSize, v2, v3 })

	local onDragMoved9 = React.useCallback(function(vector2: Vector2)
		onDrag(props, vector2, Vector2.new(v2 and 0 or 1, v3 and 1 or 0))
	end, { props.Rect, props.SetRect, props.MinSize, v2, v3 })

	return React.createElement(Panel, Dash.join(props, {
		Rect = props.Rect,
		children = Dash.join(props.children, {
			CenterInput = props.DragEnabled and React.createElement(InputDetector, {
				AnchorPoint = Vector2.new(0, 0),
				XSnap = props.XSnap,
				YSnap = props.YSnap,
				OnDragMoved = onDragMoved,
				ZIndex = 0
			}),
			Left = props.EdgeLeftEnabled and React.createElement("Frame", {
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(0, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 1
			}, {
				Input = React.createElement(InputDetector, {
					Inflate = 5,
					XSnap = props.XSnap,
					YSnap = props.YSnap,
					OnDragMoved = onDragMoved2
				})
			}),
			Right = props.EdgeRightEnabled and React.createElement("Frame", {
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.fromScale(0, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 1
			}, {
				Input = React.createElement(InputDetector, {
					Inflate = 5,
					XSnap = props.XSnap,
					YSnap = props.YSnap,
					OnDragMoved = onDragMoved3
				})
			}),
			Top = props.EdgeTopEnabled and React.createElement("Frame", {
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 1
			}, {
				Input = React.createElement(InputDetector, {
					Inflate = 5,
					XSnap = props.XSnap,
					YSnap = props.YSnap,
					OnDragMoved = onDragMoved4
				})
			}),
			Bottom = props.EdgeBottomEnabled and React.createElement("Frame", {
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 1
			}, {
				Input = React.createElement(InputDetector, {
					Inflate = 5,
					XSnap = props.XSnap,
					YSnap = props.YSnap,
					OnDragMoved = onDragMoved5
				})
			}),
			TopLeft = props.CornerTopLeftEnabled and React.createElement("Frame", {
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2
			}, {
				Input = React.createElement(InputDetector, {
					Inflate = 5,
					XSnap = props.XSnap,
					YSnap = props.YSnap,
					OnDragMoved = onDragMoved6
				})
			}),
			TopRight = props.CornerTopRightEnabled and React.createElement("Frame", {
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.fromScale(0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2
			}, {
				Input = React.createElement(InputDetector, {
					Inflate = 5,
					XSnap = props.XSnap,
					YSnap = props.YSnap,
					OnDragMoved = onDragMoved7
				})
			}),
			BottomLeft = props.CornerBottomLeftEnabled and React.createElement("Frame", {
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.fromScale(0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2
			}, {
				Input = React.createElement(InputDetector, {
					Inflate = 5,
					XSnap = props.XSnap,
					YSnap = props.YSnap,
					OnDragMoved = onDragMoved8
				})
			}),
			BottomRight = props.CornerBottomRightEnabled and React.createElement("Frame", {
				Position = UDim2.fromScale(1, 1),
				Size = UDim2.fromScale(0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2
			}, {
				Input = React.createElement(InputDetector, {
					Inflate = 5,
					XSnap = props.XSnap,
					YSnap = props.YSnap,
					OnDragMoved = onDragMoved9
				})
			})
		})
	}))
end

return ResizablePanel
