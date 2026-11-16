local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)

local StyleUtil = require(Graphing.Util.StyleUtil)
local Types = require(Graphing.Types)
local useViewportBinding = require(Graphing.Util.useViewportBinding)
local useViewportBinding2 = useViewportBinding.useViewportBinding
local useViewportVisibility = useViewportBinding.useViewportVisibility

function GridLine(props)
	assert(
		props.Orientation == Types.ORIENTATION_VERTICAL or props.Orientation == Types.ORIENTATION_HORIZONTAL,
		`Invalid orientation {props.Orientation}`
	)

	local color3 = props.Color3 or StyleUtil.GRID_LINE_COLOR3
	local transparency = props.Transparency or StyleUtil.GRID_LINE_TRANSPARENCY
	local thickness = props.Thickness or StyleUtil.GRID_LINE_THICKNESS

	local v = useViewportBinding2(function(p)
		local v

		if props.Orientation == Types.ORIENTATION_VERTICAL then
			v = p.plotToViewX(props.Position)
		else
			v = p.plotToViewY(props.Position)
		end

		local v2, v3

		if props.OppositeAxisBounds then
			if props.Orientation == Types.ORIENTATION_VERTICAL then
				v2 = p.plotToViewY(props.OppositeAxisBounds.Min)
				v3 = p.plotToViewY(props.OppositeAxisBounds.Max)
			else
				v2 = p.plotToViewX(props.OppositeAxisBounds.Min)
				v3 = p.plotToViewX(props.OppositeAxisBounds.Max)
			end
		else
			v2 = 0
			v3 = 1
		end

		local udim, udim2

		if props.Orientation == Types.ORIENTATION_VERTICAL then
			udim = UDim2.fromScale(v, (v2 + v3) / 2)
			udim2 = UDim2.new(0, thickness, v3 - v2, 0)
		else
			udim = UDim2.fromScale((v2 + v3) / 2, v)
			udim2 = UDim2.new(v3 - v2, 0, 0, thickness)
		end

		return { position = udim, size = udim2 }
	end, { props.Orientation, props.Position, props.OppositeAxisBounds, thickness })

	if useViewportVisibility(function(data)
		if props.OppositeAxisBounds then
			if props.Orientation == Types.ORIENTATION_VERTICAL then
				return (data.isRectInViewport(Rect.new(
					props.Position,
					props.OppositeAxisBounds.Min,
					props.Position,
					props.OppositeAxisBounds.Max
				)))
			end

			return (data.isRectInViewport(Rect.new(
				props.OppositeAxisBounds.Min,
				props.Position,
				props.OppositeAxisBounds.Max,
				props.Position
			)))
		elseif props.Orientation == Types.ORIENTATION_VERTICAL then
			return (data.isPointInViewportX(props.Position))
		else
			return (data.isPointInViewportY(props.Position))
		end
	end, { props.Orientation, props.Position, props.OppositeAxisBounds }) then
		return React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = v:map(function(p)
				return p.position
			end),
			Size = v:map(function(p)
				return p.size
			end),
			BorderSizePixel = 0,
			BackgroundColor3 = color3,
			BackgroundTransparency = transparency,
			ZIndex = props.ZIndex
		}, props.children)
	end

	return nil
end

return GridLine
