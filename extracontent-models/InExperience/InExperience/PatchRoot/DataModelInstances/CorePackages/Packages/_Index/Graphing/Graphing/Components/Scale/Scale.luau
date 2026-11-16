local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local CanvasContext = require(Graphing.CanvasContext)
local Types = require(Graphing.Types)
local ScaleTick = require(Graphing.Components.ScaleTick)
local GridUtil = require(Graphing.Util.GridUtil)
local StyleUtil = require(Graphing.Util.StyleUtil)

local function isX(side): boolean -- 2 equivalent calls inferred from this helper
	return side == Types.SIDE_TOP or side == Types.SIDE_BOTTOM
end

function Scale(props)
	local size = props.Size or StyleUtil.SCALE_SIZE

	local v = React.useContext(CanvasContext)

	SignalsReact.useSignalState(v.viewportRectGetter)
	local v2

	if isX(props.Side) then -- inferred equivalent call
		v2 = Types.AXIS_X
	else
		v2 = Types.AXIS_Y
	end

	local udim = UDim2.fromScale(0, 0)

	if props.Side == Types.SIDE_LEFT then
		udim = UDim2.new(-size, UDim.new(0, 0))
	elseif props.Side == Types.SIDE_RIGHT then
		udim = UDim2.fromScale(1, 0)
	elseif props.Side == Types.SIDE_TOP then
		udim = UDim2.new(UDim.new(0, 0), -size)
	elseif props.Side == Types.SIDE_BOTTOM then
		udim = UDim2.fromScale(0, 1)
	else
		assert(false, `Invalid side {props.Side}`)
	end

	local udim2

	if isX(props.Side) then -- inferred equivalent call
		udim2 = UDim2.new(UDim.new(1, 0), size)
	else
		udim2 = UDim2.new(size, UDim.new(1, 0))
	end

	local values = GridUtil.getValues(v2, props.Schema, v)
	local v3 = not props.SchemaMinor and {} or GridUtil.getValues(v2, props.SchemaMinor, v, values)

	local formatter = props.Formatter or GridUtil.trimRoundingError
	local tickLength = props.TickLength or StyleUtil.SCALE_TICK_LENGTH
	local tickLengthMinor = props.TickLengthMinor or StyleUtil.SCALE_TICK_LENGTH_MINOR

	local children = {}

	for _, value in values do
		children[`Tick{value}`] = React.createElement(ScaleTick, {
			Side = props.Side,
			Position = value,
			Length = tickLength,
			Thickness = props.TickThickness,
			TextPadding = props.TickTextPadding,
			TextSize = props.TickTextSize,
			Color3 = props.TickColor,
			Formatter = formatter
		})
	end

	for _, position in v3 do
		children[`TickM{position}`] = React.createElement(ScaleTick, {
			Side = props.Side,
			Position = position,
			Length = tickLengthMinor,
			Thickness = props.TickThickness,
			TextPadding = props.TickTextPadding,
			Color3 = props.TickColor,
			HasLabel = false
		})
	end

	children.Body = React.createElement("Frame", {
		Position = udim,
		Size = udim2,
		BackgroundColor3 = props.BackgroundColor3 or StyleUtil.SCALE_BACKGROUND_COLOR3,
		BackgroundTransparency = props.BackgroundTransparency or StyleUtil.SCALE_BACKGROUND_TRANSPARENCY,
		BorderSizePixel = 0,
		ZIndex = -1
	}, props.children)

	return React.createElement(
		"Frame",
		{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = props.ZIndex },
		children
	)
end

return Scale
