local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local CanvasContext = require(Graphing.CanvasContext)
local Types = require(Graphing.Types)
local GridLine = require(Graphing.Components.GridLine)
local GridUtil = require(Graphing.Util.GridUtil)
local StyleUtil = require(Graphing.Util.StyleUtil)

function Grid(props)
	local v = React.useContext(CanvasContext)

	SignalsReact.useSignalState(v.viewportRectGetter)

	local zIndex = props.ZIndex or -1

	local v2 = not props.XAxis and {} or GridUtil.getValues(Types.AXIS_X, props.XAxis, v)
	local v3 = not props.YAxis and {} or GridUtil.getValues(Types.AXIS_Y, props.YAxis, v)
	local v4 = not props.XAxisMinor and {} or GridUtil.getValues(Types.AXIS_X, props.XAxisMinor, v, v2)
	local v5 = not props.YAxisMinor and {} or GridUtil.getValues(Types.AXIS_Y, props.YAxisMinor, v, v3)

	local children = {}

	for _, position in v2 do
		children[`X{position}`] = React.createElement(GridLine, {
			Orientation = "Vertical",
			Position = position,
			Tag = props.Tag,
			Color3 = StyleUtil.GRID_COLOR3,
			Thickness = StyleUtil.GRID_THICKNESS,
			Transparency = StyleUtil.GRID_TRANSPARENCY
		})
	end

	for _, position in v4 do
		children[`Xm{position}`] = React.createElement(GridLine, {
			Orientation = "Vertical",
			Position = position,
			Tag = props.Tag,
			Color3 = StyleUtil.GRID_COLOR3_MINOR,
			Thickness = StyleUtil.GRID_THICKNESS_MINOR,
			Transparency = StyleUtil.GRID_TRANSPARENCY_MINOR
		})
	end

	for _, position in v3 do
		children[`Y{position}`] = React.createElement(GridLine, {
			Orientation = "Horizontal",
			Position = position,
			Tag = props.Tag,
			Color3 = StyleUtil.GRID_COLOR3,
			Thickness = StyleUtil.GRID_THICKNESS,
			Transparency = StyleUtil.GRID_TRANSPARENCY
		})
	end

	for _, position in v5 do
		children[`Ym{position}`] = React.createElement(GridLine, {
			Orientation = "Horizontal",
			Position = position,
			Tag = props.Tag,
			Color3 = StyleUtil.GRID_COLOR3_MINOR,
			Thickness = StyleUtil.GRID_THICKNESS_MINOR,
			Transparency = StyleUtil.GRID_TRANSPARENCY_MINOR
		})
	end

	return React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 1),
			ZIndex = zIndex,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		children
	)
end

return Grid
