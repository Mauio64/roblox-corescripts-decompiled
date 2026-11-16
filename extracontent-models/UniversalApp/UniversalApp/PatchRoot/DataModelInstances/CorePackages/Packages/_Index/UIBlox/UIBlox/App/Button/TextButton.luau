local App = script:FindFirstAncestor("App")
local parent = App.Parent
local core = parent.Core
local parent2 = parent.Parent

local t = require(parent2.t)
local Roact = require(parent2.Roact)
local React = require(parent2.React)
local Cryo = require(parent2.Cryo)

local Interactable = require(core.Control.Interactable)

local ControlState = require(core.Control.Enum.ControlState)
local getContentStyle = require(core.Button.getContentStyle)
local GetTextSize = require(core.Text.GetTextSize)
local CleanRichTextTags = require(core.Text.CleanRichTextTags)
local isReactTagProp = require(parent.Utility.isReactTagProp)
local CursorKind = require(App.SelectionImage.CursorKind)

local validateColorInfo = require(core.Style.Validator.validateColorInfo)
local withStyle = require(core.Style.withStyle)
local GenericTextLabel = require(core.Text.GenericTextLabel.GenericTextLabel)

local useCursor = require(parent.App.SelectionCursor.useCursor)

local udim = UDim.new(0, 8)

local extended = Roact.PureComponent:extend("TextButton")

extended.validateProps = t.strictInterface({
	[React.Tag] = isReactTagProp,
	onStateChanged = t.optional(t.callback),
	isDisabled = t.optional(t.boolean),
	fontStyle = t.optional(t.string),
	colorStyleDefault = t.optional(t.string),
	colorStyleHover = t.optional(t.string),
	hoverBackgroundEnabled = t.optional(t.boolean),
	richText = t.optional(t.boolean),
	showBackground = t.optional(t.boolean),
	backgroundColor = t.optional(validateColorInfo),
	horizontalPadding = t.optional(t.number),
	verticalPadding = t.optional(t.number),
	userInteractionEnabled = t.optional(t.boolean),
	onActivated = t.optional(t.callback),
	anchorPoint = t.optional(t.Vector2),
	layoutOrder = t.optional(t.number),
	position = t.optional(t.UDim2),
	size = t.optional(t.UDim2),
	text = t.optional(t.string),
	cursor = t.optional(t.table),
	debugGetTextSize = t.optional(t.callback),
	debugControlState = t.optional(ControlState.isEnumValue)
})

extended.defaultProps = {
	anchorPoint = Vector2.new(0, 0),
	layoutOrder = 0,
	position = UDim2.new(0, 0, 0, 0),
	size = UDim2.fromScale(0, 0),
	text = "",
	verticalPadding = 11,
	horizontalPadding = 8,
	showBackground = false,
	fontStyle = "Header2",
	colorStyleDefault = "TextEmphasis",
	colorStyleHover = "TextEmphasis",
	hoverBackgroundEnabled = true,
	richText = false,
	isDisabled = false,
	userInteractionEnabled = true,
	debugGetTextSize = GetTextSize,
	debugControlState = nil
}

function extended:init()
	self:setState({ controlState = ControlState.Initialize })

	function self.onStateChanged(p, controlState)
		self:setState({ controlState = controlState })

		if self.props.onStateChanged then
			self.props.onStateChanged(p, controlState)
		end
	end
end

function extended:render()
	return withStyle(function(p)
		return self:renderWithProviders(p, nil, nil)
	end)
end

function extended:renderWithProviders(p, callback, callback2)
	local debugControlState = self.props.debugControlState or self.state.controlState

	local contentStyle = getContentStyle(
		{
			[ControlState.Default] = self.props.colorStyleDefault,
			[ControlState.Hover] = self.props.colorStyleHover
		},
		debugControlState,
		p
	)
	local fontStyle = p.Font[self.props.fontStyle]

	local v = fontStyle.RelativeSize * p.Font.BaseSize
	local x = self.props.debugGetTextSize(
		self.props.richText and CleanRichTextTags(self.props.text) or self.props.text,
		v,
		fontStyle.Font,
		Vector2.new(10000, 0)
	).X

	local v2 = not self.props.showBackground and { Color = nil, Transparency = 1 }
		or self.props.backgroundColor
		or p.Theme.UIMuted

	local verticalPadding = self.props.verticalPadding
	local horizontalPadding = self.props.horizontalPadding

	local backgroundOnHover = p.Theme.BackgroundOnHover

	if self.props.hoverBackgroundEnabled and debugControlState == ControlState.Hover then
		v2 = v2.Color and {
			Color = v2.Color:Lerp(backgroundOnHover.Color, 1 - backgroundOnHover.Transparency),
			Transparency = v2.Transparency
		} or backgroundOnHover
	end

	local createElement = Roact.createElement
	local v3 = {
		[React.Tag] = self.props[React.Tag],
		AnchorPoint = self.props.anchorPoint,
		LayoutOrder = self.props.layoutOrder,
		Position = self.props.position,
		Size = self.props.size,
		isDisabled = self.props.isDisabled,
		onStateChanged = self.onStateChanged,
		userInteractionEnabled = self.props.userInteractionEnabled,
		BackgroundColor3 = v2.Color,
		BackgroundTransparency = v2.Transparency,
		AutoButtonColor = false
	}
	local selectionImageObject

	if callback2 then
		selectionImageObject = callback2(udim)
	else
		selectionImageObject = callback and callback(CursorKind.RoundedRectNoInset)
	end

	v3.SelectionImageObject = selectionImageObject

	v3[Roact.Event.Activated] = self.props.onActivated
	return createElement(Interactable, v3, {
		corner = Roact.createElement("UICorner", { CornerRadius = udim }),
		sizeConstraint = Roact.createElement("UISizeConstraint", {
			MinSize = Vector2.new(x + horizontalPadding * 2, v + verticalPadding * 2)
		}),
		textLabel = Roact.createElement(GenericTextLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			Text = self.props.text,
			fontStyle = fontStyle,
			colorStyle = contentStyle,
			RichText = self.props.richText
		})
	})
end

local function TextButtonFunctionalWrapper(p)
	local cursor = useCursor(udim)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { cursor = cursor }))
end

local extended2 = Roact.PureComponent:extend("TextButtonOuterWrapper")

extended2.validateProps = extended.validateProps

function extended2.render(p)
	return Roact.createElement(TextButtonFunctionalWrapper, p.props)
end

return extended2
