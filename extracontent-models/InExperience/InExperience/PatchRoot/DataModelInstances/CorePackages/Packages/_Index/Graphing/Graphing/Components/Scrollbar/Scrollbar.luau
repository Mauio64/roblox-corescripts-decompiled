local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)

local CanvasContext = require(Graphing.CanvasContext)
local ScrollbarButton = require(Graphing.Components.ScrollbarButton)
local StyleUtil = require(Graphing.Util.StyleUtil)
local Types = require(Graphing.Types)
local useViewportBinding = require(Graphing.Util.useViewportBinding)
local useViewportBinding2 = useViewportBinding.useViewportBinding

local function getDim(p, axis) -- 12 equivalent calls inferred from this helper
	return if axis == Types.AXIS_X then p.X else p.Y
end

local function makeUDim2(udim: UDim, udim2: UDim, axis) -- 8 equivalent calls inferred from this helper
	if axis == Types.AXIS_X then
		return (UDim2.new(udim, udim2))
	end

	return (UDim2.new(udim2, udim))
end

function Scrollbar(props)
	local distance = props.Distance or StyleUtil.SCROLLBAR_DISTANCE
	local size = props.Size or StyleUtil.SCROLLBAR_SIZE
	local scrollButtonSize = props.ScrollButtonSize or StyleUtil.SCROLLBAR_SCROLL_BUTTON_SIZE
	local zoomButtonSize = props.ZoomButtonSize or StyleUtil.SCROLLBAR_ZOOM_BUTTON_SIZE

	local v = React.useContext(CanvasContext)

	local v2 = useViewportBinding2(function(data)
		local v2

		if props.Axis == Types.AXIS_X then
			v2 = data.plotToGraphX
		else
			v2 = data.plotToGraphY
		end

		local viewportRect = data.getViewportRect()
		local v3 = v2(getDim(viewportRect.Min, props.Axis)) -- inferred equivalent call
		local v4 = v2(getDim(viewportRect.Max, props.Axis)) -- inferred equivalent call
		return {
			position = makeUDim2(UDim.new(v3, 0), UDim.new(0, 0), props.Axis), -- inferred equivalent call
			size = makeUDim2(UDim.new(v4 - v3), UDim.new(1, 0), props.Axis) -- inferred equivalent call
		}
	end, { props.Axis })

	local v3 = React.useCallback(function(p: number)
		if props.OnViewChanged then
			local v3

			if props.Axis == Types.AXIS_X then
				v3 = v.plotToGraphX
			else
				v3 = v.plotToGraphY
			end

			local v4

			if props.Axis == Types.AXIS_X then
				v4 = v.graphToPlotX
			else
				v4 = v.graphToPlotY
			end

			local viewportRect = v.getViewportRect()
			local v5 = v3(getDim(viewportRect.Min, props.Axis)) -- inferred equivalent call
			local v6 = v3(getDim(viewportRect.Max, props.Axis)) -- inferred equivalent call

			local v7 = not props.ExpandedBounds and 0 or v3(props.ExpandedBounds.Min)
			local v8 = not props.ExpandedBounds and 1 or v3(props.ExpandedBounds.Max)

			local v9 = v5 + p
			local v10 = v6 + p

			local v11 = 0
			local v12 = math.min(v9, v10)
			local v13 = math.max(v9, v10)

			if v12 < v7 then
				v11 = v7 - v12
			elseif v8 < v13 then
				v11 = v8 - v13
			end

			local v14 = v9 + v11
			local v15 = v10 + v11

			local v16 = v4(v14)
			local v17 = v4(v15)

			props.OnViewChanged(v16, v17)
		end
	end, { props.OnViewChanged, props.Axis, props.ExpandedBounds })

	local onMoved = React.useCallback(function(vector2: Vector2)
		local v4

		if props.Axis == Types.AXIS_X then
			v4 = v.plotToGraphX
		else
			v4 = v.plotToGraphY
		end

		local v5 = v4(getDim(v.getViewportRect().Min, props.Axis)) -- inferred equivalent call
		v3(getDim(v.plotToView(vector2), props.Axis) - v5) -- inferred equivalent call
	end, { v3, props.Axis })

	local onMoved2 = React.useCallback(function(vector2: Vector2)
		if props.OnViewChanged then
			local plotToView = v.plotToView(vector2)
			local graphToPlot = v.graphToPlot(plotToView)

			local dim = getDim(v.getGraphRect().Min, props.Axis) -- inferred equivalent call
			local dim2 = getDim(v.getViewportRect().Max, props.Axis) -- inferred equivalent call

			local v4 = math.max(math.min(getDim(graphToPlot, props.Axis), dim2 - props.MinZoom), dim) -- inferred equivalent call

			props.OnViewChanged(v4, dim2)
		end
	end, { props.OnViewChanged, props.Axis, props.MinZoom })

	local onMoved3 = React.useCallback(function(vector2: Vector2)
		if props.OnViewChanged then
			local plotToView = v.plotToView(vector2)
			local graphToPlot = v.graphToPlot(plotToView)

			local dim = getDim(v.getGraphRect().Max, props.Axis) -- inferred equivalent call
			local dim2 = getDim(v.getViewportRect().Min, props.Axis) -- inferred equivalent call

			local v4 = math.min(math.max(getDim(graphToPlot, props.Axis), dim2 + props.MinZoom), dim) -- inferred equivalent call

			props.OnViewChanged(dim2, v4)
		end
	end, { props.OnViewChanged, props.Axis, props.MinZoom })

	local onClick = React.useCallback(function()
		v3(-0.04)
	end, { v3 })

	local onClick2 = React.useCallback(function()
		v3(0.04)
	end, { v3 })

	local udim2 = makeUDim2(UDim.new(0, -scrollButtonSize - zoomButtonSize), UDim.new(1, 0) + distance, props.Axis) -- inferred equivalent call
	local udim2_2 = makeUDim2(UDim.new(1, 0), size, props.Axis) -- inferred equivalent call
	local udim2_3 = makeUDim2(UDim.new(0, (scrollButtonSize + zoomButtonSize) * 2), UDim.new(0, 0), props.Axis) -- inferred equivalent call
	local udim2_4 = makeUDim2(UDim.new(0, scrollButtonSize), UDim.new(1, 0), props.Axis) -- inferred equivalent call
	local udim2_5 = makeUDim2(UDim.new(0, zoomButtonSize), UDim.new(1, 0), props.Axis) -- inferred equivalent call
	local rotation = props.Axis == Types.AXIS_X and 0 or 90

	local createElement = React.createElement
	local v4 = {
		Position = udim2,
		Size = udim2_2 + udim2_3,
		BorderSizePixel = props.OutlineThickness or StyleUtil.SCROLLBAR_OUTLINE_THICKNESS,
		BorderColor3 = props.OutlineColor3 or StyleUtil.SCROLLBAR_OUTLINE_COLOR3,
		BackgroundColor3 = props.Color3 or StyleUtil.SCROLLBAR_COLOR3,
		ZIndex = props.ZIndex,
		[React.Tag] = "ScrollbarFrame"
	}
	local children = {
		MinScrollButton = React.createElement(ScrollbarButton, {
			Position = UDim2.fromScale(0, 0),
			Rotation = rotation,
			Size = udim2_4,
			Image = StyleUtil.SCROLLBAR_LEFT_SCROLL_BUTTON_IMAGE,
			OnClick = onClick
		}),
		MaxScrollButton = 0,
		Inner = 0
	}

	local createElement2 = React.createElement
	local anchorPoint

	if props.Axis == Types.AXIS_X then
		anchorPoint = Vector2.new(1, 0)
	else
		anchorPoint = Vector2.new(0, 1)
	end

	children.MaxScrollButton = createElement2(ScrollbarButton, {
		AnchorPoint = anchorPoint,
		Position = makeUDim2(UDim.new(1, 0), UDim.new(0, 0), props.Axis), -- inferred equivalent call
		Rotation = rotation,
		Size = udim2_4,
		Image = StyleUtil.SCROLLBAR_RIGHT_SCROLL_BUTTON_IMAGE,
		OnClick = onClick2
	})

	local createElement3 = React.createElement
	local v5 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1) - udim2_3,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local createElement4 = React.createElement
	local v6 = {
		Position = v2:map(function(p)
			return p.position
		end),
		Size = v2:map(function(p)
			return p.size
		end),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local createElement5 = React.createElement
	local anchorPoint2

	if props.Axis == Types.AXIS_X then
		anchorPoint2 = Vector2.new(0, 0)
	else
		anchorPoint2 = Vector2.new(0, 1)
	end

	local position

	if props.Axis == Types.AXIS_X then
		position = UDim2.fromScale(0, 0)
	else
		position = UDim2.fromScale(0, 1)
	end

	local children2 = {
		MainButton = createElement5(ScrollbarButton, {
			AnchorPoint = anchorPoint2,
			Position = position,
			Size = UDim2.fromScale(1, 1),
			OnMoved = onMoved
		}),
		LeftButton = 0,
		RightButton = 0
	}

	local createElement6 = React.createElement
	local anchorPoint3

	if props.Axis == Types.AXIS_X then
		anchorPoint3 = Vector2.new(1, 0)
	else
		anchorPoint3 = Vector2.new(0, 0)
	end

	local position2

	if props.Axis == Types.AXIS_X then
		position2 = UDim2.fromScale(0, 0)
	else
		position2 = UDim2.fromScale(0, 1)
	end

	children2.LeftButton = createElement6(ScrollbarButton, {
		AnchorPoint = anchorPoint3,
		Position = position2,
		Rotation = rotation,
		Size = udim2_5,
		Image = StyleUtil.SCROLLBAR_LEFT_ZOOM_BUTTON_IMAGE,
		OnMoved = onMoved2
	})

	local createElement7 = React.createElement
	local anchorPoint4

	if props.Axis == Types.AXIS_X then
		anchorPoint4 = Vector2.new(0, 0)
	else
		anchorPoint4 = Vector2.new(0, 1)
	end

	local position3

	if props.Axis == Types.AXIS_X then
		position3 = UDim2.fromScale(1, 0)
	else
		position3 = UDim2.fromScale(0, 0)
	end

	children2.RightButton = createElement7(ScrollbarButton, {
		AnchorPoint = anchorPoint4,
		Position = position3,
		Rotation = rotation,
		Size = udim2_5,
		Image = StyleUtil.SCROLLBAR_RIGHT_ZOOM_BUTTON_IMAGE,
		OnMoved = onMoved3
	})
	children.Inner = createElement3("Frame", v5, {
		Body = createElement4("Frame", v6, children2)
	})
	return createElement("Frame", v4, children)
end

return Scrollbar
