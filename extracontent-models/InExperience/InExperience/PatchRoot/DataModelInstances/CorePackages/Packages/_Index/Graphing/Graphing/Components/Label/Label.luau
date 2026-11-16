local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)

local StyleUtil = require(Graphing.Util.StyleUtil)
require(Graphing.Types)
local useViewportBinding = require(Graphing.Util.useViewportBinding)
local useViewportBinding2 = useViewportBinding.useViewportBinding
local useViewportVisibility = useViewportBinding.useViewportVisibility

local function anchorForAlignment(p, p2)
	local v

	if p == Enum.TextXAlignment.Left then
		v = 0
	elseif p == Enum.TextXAlignment.Center then
		v = 0.5
	else
		v = if p == Enum.TextXAlignment.Right then 1 else 0
	end

	local v2

	if p2 == Enum.TextYAlignment.Top then
		v2 = 0
	elseif p2 == Enum.TextYAlignment.Center then
		v2 = 0.5
	else
		v2 = if p2 == Enum.TextYAlignment.Bottom then 1 else 0
	end

	return Vector2.new(v, v2)
end

function Label(props)
	local textXAlignment

	if props.TextXAlignment then
		textXAlignment = props.TextXAlignment
	else
		textXAlignment = Enum.TextXAlignment.Center
	end

	local textYAlignment

	if props.TextYAlignment then
		textYAlignment = props.TextYAlignment
	else
		textYAlignment = Enum.TextYAlignment.Center
	end

	local anchorPoint = React.useMemo(function()
		return anchorForAlignment(textXAlignment, textYAlignment)
	end, { props.TextXAlignment, props.TextYAlignment })

	local position = useViewportBinding2(function(p)
		local v

		if props.Offset then
			v = props.Offset
		else
			v = Vector2.new(0, 0)
		end

		local plotToView = p.plotToView(props.Position)
		return UDim2.new(plotToView.X, v.X, plotToView.Y, v.Y)
	end, { props.Position, props.Offset })

	if useViewportVisibility(function(p)
		return p.isPointInViewport(props.Position)
	end, { props.Position }) then
		return React.createElement("TextLabel", {
			AnchorPoint = anchorPoint,
			Position = position,
			Text = props.Text,
			TextXAlignment = textXAlignment,
			TextYAlignment = textYAlignment,
			BackgroundTransparency = 1,
			TextColor3 = props.Color3 or StyleUtil.GRID_LABEL_COLOR3,
			TextSize = props.FontSize or StyleUtil.GRID_LABEL_FONT_SIZE,
			ZIndex = props.ZIndex
		}, props.children)
	end

	return nil
end

return Label
