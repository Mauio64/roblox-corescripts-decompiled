local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)

local Types = require(Graphing.Types)
local SidePositioner = require(Graphing.Components.SidePositioner)
local GridUtil = require(Graphing.Util.GridUtil)
local StyleUtil = require(Graphing.Util.StyleUtil)

local function isX(side): boolean -- 1 equivalent call inferred from this helper
	return side == Types.SIDE_TOP or side == Types.SIDE_BOTTOM
end

function ScaleTick(props)
	local length = props.Length
	local thickness = props.Thickness or StyleUtil.SCALE_TICK_THICKNESS
	local textPadding = props.TextPadding or StyleUtil.SCALE_TICK_LABEL_PADDING
	local label = props.HasLabel == nil or props.HasLabel

	local anchorPointForSide = GridUtil.getAnchorPointForSide(props.Side)
	local textAlignmentsFromAnchorPoint, textYAlignment = GridUtil.getTextAlignmentsFromAnchorPoint(anchorPointForSide)
	local udim

	if isX(props.Side) then -- inferred equivalent call
		udim = UDim2.fromOffset(thickness, length)
	else
		udim = UDim2.fromOffset(length, thickness)
	end

	local v = length + textPadding

	local udim2 = UDim2.fromOffset(-2 * v * anchorPointForSide.X + v, -2 * v * anchorPointForSide.Y + v)

	local createElement = React.createElement
	local v2 = { Side = props.Side, Position = props.Position, ZIndex = props.ZIndex }
	local v3 = {
		Tick = React.createElement("Frame", {
			AnchorPoint = anchorPointForSide,
			Size = udim,
			BackgroundColor3 = props.Color3 or StyleUtil.SCALE_TICK_COLOR3,
			BorderSizePixel = 0
		}, props.children),
		Label = 0
	}

	if label then
		local createElement2 = React.createElement
		local text

		if props.Formatter then
			text = props.Formatter(props.Position)
		else
			text = tostring(props.Position)
		end

		label = createElement2("TextLabel", {
			AnchorPoint = anchorPointForSide,
			Position = udim2,
			Text = text,
			TextXAlignment = textAlignmentsFromAnchorPoint,
			TextYAlignment = textYAlignment,
			BackgroundTransparency = 1,
			TextColor3 = props.Color3 or StyleUtil.SCALE_TICK_LABEL_COLOR3,
			TextSize = props.TextSize or StyleUtil.SCALE_TICK_LABEL_SIZE
		})
	end

	v3.Label = label
	return createElement(SidePositioner, v2, v3)
end

return ScaleTick
