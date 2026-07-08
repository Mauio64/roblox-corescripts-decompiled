local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Immutable = require(script.Parent.Parent.Immutable)
local Constants = require(script.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local ArrowWidth = Constants.GeneralFormatting.ArrowWidth
local RightArrow = Constants.Image.RightArrow
local DownArrow = Constants.Image.DownArrow
local v10 = Roact.Component:extend("BannerButton")

function v10.render(p1) -- line: 14
	-- upvalues: Roact (copy), DownArrow (copy), RightArrow (copy), ArrowWidth (copy), LineWidth (copy), LineColor (copy), Immutable (copy)
	local v12 = p1.props[Roact.Children] or {}
	local size = p1.props.size
	local pos = p1.props.pos
	local isExpandable = p1.props.isExpandable
	local isExpanded = p1.props.isExpanded
	local layoutOrder = p1.props.layoutOrder
	local v18 = p1.props.inset or 0
	local hideLines = p1.props.hideLines
	local onButtonPress = p1.props.onButtonPress
	local onMouseEnter = p1.props.onMouseEnter
	local onMouseLeave = p1.props.onMouseLeave
	local onMouseMove = p1.props.onMouseMove
	local onMouse2Click = p1.props.onMouse2Click
	local t1 = {
		BannerButtonArrow = onButtonPress and Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Visible = isExpandable,
			Image = isExpanded and DownArrow or RightArrow,
			Size = UDim2.new(0, ArrowWidth, 0, ArrowWidth),
			Position = UDim2.new(0, v18, 0.5, -ArrowWidth / 2)
		})
	}

	if not hideLines then
		t1.HorizontalLineTop = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, LineWidth),
			BackgroundColor3 = LineColor
		})
		t1.HorizontalLineBottom = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, LineWidth),
			Position = UDim2.new(0, 0, 1, -LineWidth),
			BackgroundColor3 = LineColor
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
	}, Immutable.JoinDictionaries(t1, v12))
end

return v10
