local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Immutable = require(script.Parent.Parent.Immutable)
local Constants = require(script.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local ArrowWidth = Constants.GeneralFormatting.ArrowWidth
local RightArrow = Constants.Image.RightArrow
local DownArrow = Constants.Image.DownArrow

local extended = Roact.Component:extend("BannerButton")

function extended.render(p)
	local v = p.props[Roact.Children] or {}

	local size = p.props.size
	local pos = p.props.pos
	local isExpandable = p.props.isExpandable
	local isExpanded = p.props.isExpanded
	local layoutOrder = p.props.layoutOrder
	local inset = p.props.inset or 0
	local hideLines = p.props.hideLines

	local onButtonPress = p.props.onButtonPress
	local onMouseEnter = p.props.onMouseEnter
	local onMouseLeave = p.props.onMouseLeave
	local onMouseMove = p.props.onMouseMove
	local onMouse2Click = p.props.onMouse2Click

	local children = {
		BannerButtonArrow = onButtonPress and Roact.createElement("ImageLabel", {
			Visible = isExpandable,
			Image = isExpanded and DownArrow or RightArrow,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, ArrowWidth, 0, ArrowWidth),
			Position = UDim2.new(0, inset, 0.5, -ArrowWidth / 2)
		})
	}

	if not hideLines then
		children.HorizontalLineTop = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, LineWidth),
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		})

		children.HorizontalLineBottom = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, LineWidth),
			Position = UDim2.new(0, 0, 1, -LineWidth),
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		})
	end

	return Roact.createElement("ImageButton", {
		Size = size,
		Position = pos,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		[Roact.Event.Activated] = onButtonPress,
		[Roact.Event.MouseEnter] = onMouseEnter,
		[Roact.Event.MouseLeave] = onMouseLeave,
		[Roact.Event.MouseMoved] = onMouseMove,
		[Roact.Event.MouseButton2Click] = onMouse2Click
	}, Immutable.JoinDictionaries(children, v))
end

return extended
