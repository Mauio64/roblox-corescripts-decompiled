local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local Cryo = require(parent2.Cryo)
local t = require(parent2.t)
local withStyle = require(parent.Core.Style.withStyle)

local ControlState = require(parent2.UIBlox.Core.Control.Enum.ControlState)
local GenericCell = require(parent2.UIBlox.Core.Cell.GenericCell)
local ImageSetComponent = require(parent2.UIBlox.Core.ImageSet.ImageSetComponent)

local extended = Roact.PureComponent:extend("GenericSelectionCell")

local v = {
	[ControlState.Default] = "BackgroundDefault",
	[ControlState.Hover] = "BackgroundOnHover",
	[ControlState.Pressed] = "BackgroundOnPress"
}

local v2 = {
	[ControlState.Default] = "IconDefault",
	[ControlState.Hover] = "IconEmphasis",
	[ControlState.Pressed] = "IconDefault"
}

local function getCellStyle(p, default, p2)
	local v3 = p[default] or p[ControlState.Default]

	local cellStyle = { Color = p2.Theme[v3].Color, Transparency = p2.Theme[v3].Transparency }

	if default == ControlState.Default or default == ControlState.Disabled then
		cellStyle.Transparency = 1
	end

	return cellStyle
end

local function getIconStyle(p, default, p2)
	local v3 = p[default] or p[ControlState.Default]

	local iconStyle = { Color = p2.Theme[v3].Color, Transparency = p2.Theme[v3].Transparency }

	if default == ControlState.Disabled or default == ControlState.Pressed then
		iconStyle.Transparency = 0.5 * iconStyle.Transparency + 0.5
	end

	return iconStyle
end

local function getTextStyle(p, default) -- 2 equivalent calls inferred from this helper
	local textStyle = { Color = p.Color, Transparency = p.Transparency }

	if default == ControlState.Disabled or default == ControlState.Pressed then
		textStyle.Transparency = 0.5 * textStyle.Transparency + 0.5
	end

	return textStyle
end

extended.validateProps = t.strictInterface({
	text = t.string,
	subtitleText = t.optional(t.string),
	defaultImage = t.union(t.string, t.table),
	selectedImage = t.union(t.string, t.table),
	defaultImageSize = t.number,
	selectedImageSize = t.number,
	onActivated = t.optional(t.callback),
	isSelected = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	useDefaultControlState = t.optional(t.boolean),
	controlRef = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	SelectionImageObject = t.optional(t.table)
})

extended.defaultProps = { isSelected = false }

function extended:init()
	self.state = { controlState = ControlState.Default }

	function self.onStateChanged(_, controlState)
		self:setState({ controlState = controlState })
	end
end

function extended.render(data)
	assert(data.validateProps(data.props))

	return withStyle(function(p)
		local font = p.Font
		local theme = p.Theme

		local default = data.props.useDefaultControlState and ControlState.Default or data.state.controlState

		local iconStyle = getIconStyle(v2, default, p)
		local cellStyle = getCellStyle(v, default, p)
		local textStyle = getTextStyle(theme.TextEmphasis, default) -- inferred equivalent call
		local textStyle2 = getTextStyle(theme.TextDefault, default) -- inferred equivalent call
		local divider = theme.Divider

		return Roact.createElement(GenericCell, {
			titleText = data.props.text,
			colorStyle = cellStyle,
			textStyle = textStyle,
			fontStyle = font.Header2,
			subtitleText = data.props.subtitleText,
			subtitleTextStyle = textStyle2,
			subtitleFontStyle = font.Body,
			rightContentWidth = data.props.defaultImageSize,
			onActivated = data.props.onActivated,
			dividerStyle = divider,
			isDisabled = data.props.isDisabled,
			[Roact.Ref] = data.props.controlRef,
			NextSelectionUp = data.props.NextSelectionUp,
			NextSelectionDown = data.props.NextSelectionDown,
			NextSelectionLeft = data.props.NextSelectionLeft,
			NextSelectionRight = data.props.NextSelectionRight,
			SelectionImageObject = data.props.SelectionImageObject,
			renderRightContent = function()
				return Roact.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						Size = UDim2.new(0, data.props.defaultImageSize, 1, 0),
						LayoutOrder = 3
					},
					{
						SelectionImage = Roact.createElement(ImageSetComponent.Label, {
							BackgroundTransparency = 1,
							Image = data.props.defaultImage,
							Size = UDim2.new(0, data.props.defaultImageSize, 0, data.props.defaultImageSize),
							ImageColor3 = iconStyle.Color,
							ImageTransparency = iconStyle.Transparency,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0)
						}, {
							SelectedImage = data.props.isSelected and Roact.createElement(ImageSetComponent.Label, {
								BackgroundTransparency = 1,
								Image = data.props.selectedImage,
								Size = UDim2.new(0, data.props.selectedImageSize, 0, data.props.selectedImageSize),
								ImageColor3 = iconStyle.Color,
								ImageTransparency = iconStyle.Transparency,
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.new(0.5, 0, 0.5, 0)
							})
						})
					}
				)
			end,
			onStateChanged = data.onStateChanged
		})
	end)
end

return Roact.forwardRef(function(p, controlRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { controlRef = controlRef }))
end)
