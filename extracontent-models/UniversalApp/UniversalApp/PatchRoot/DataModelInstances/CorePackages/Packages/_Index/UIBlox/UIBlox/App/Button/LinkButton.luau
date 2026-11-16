local App = script:FindFirstAncestor("App")
local parent = App.Parent
local core = parent.Core
local parent2 = parent.Parent

local t = require(parent2.t)
local Roact = require(parent2.Roact)
local Cryo = require(parent2.Cryo)

local Interactable = require(core.Control.Interactable)

local ControlState = require(core.Control.Enum.ControlState)
local getContentStyle = require(core.Button.getContentStyle)
local GetTextSize = require(core.Text.GetTextSize)
local CleanRichTextTags = require(core.Text.CleanRichTextTags)

local withStyle = require(core.Style.withStyle)
local GenericTextLabel = require(core.Text.GenericTextLabel.GenericTextLabel)
local HoverButtonBackground = require(core.Button.HoverButtonBackground)

local useCursorByType = require(App.SelectionCursor.useCursorByType)
local CursorType = require(App.SelectionCursor.CursorType)
local RoactGamepad = require(parent2.RoactGamepad)
local Focusable = RoactGamepad.Focusable

local extended = Roact.PureComponent:extend("LinkButton")

extended.validateProps = t.strictInterface({
	onStateChanged = t.optional(t.callback),
	isDisabled = t.optional(t.boolean),
	fontStyle = t.optional(t.string),
	colorStyleDefault = t.optional(t.string),
	colorStyleHover = t.optional(t.string),
	hoverBackgroundEnabled = t.optional(t.boolean),
	underlineAlwaysEnabled = t.optional(t.boolean),
	userInteractionEnabled = t.optional(t.boolean),
	onActivated = t.optional(t.callback),
	anchorPoint = t.optional(t.Vector2),
	layoutOrder = t.optional(t.number),
	position = t.optional(t.UDim2),
	size = t.optional(t.UDim2),
	text = t.optional(t.string),
	minPaddingX = t.optional(t.number),
	minPaddingY = t.optional(t.number),
	selectionCursorKind = t.optional(t.userdata),
	debugGetTextSize = t.optional(t.callback),
	debugControlState = t.optional(ControlState.isEnumValue),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	buttonRef = t.optional(t.union(t.callback, t.table)),
	cursor = t.optional(t.table)
})

extended.defaultProps = {
	anchorPoint = Vector2.new(0, 0),
	layoutOrder = 0,
	position = UDim2.new(0, 0, 0, 0),
	size = UDim2.fromScale(0, 0),
	text = "",
	fontStyle = "Header2",
	colorStyleDefault = "TextLink",
	colorStyleHover = "TextLink",
	hoverBackgroundEnabled = false,
	underlineAlwaysEnabled = false,
	isDisabled = false,
	userInteractionEnabled = true,
	minPaddingX = 8,
	minPaddingY = 11,
	debugGetTextSize = GetTextSize,
	debugControlState = nil
}

function extended:init()
	self:setState({ controlState = ControlState.Initialize })

	function self.applyRichTextUnderline(p)
		return "<u>" .. p .. "</u>"
	end

	function self.onStateChanged(p, controlState)
		self:setState({ controlState = controlState })

		if self.props.onStateChanged then
			self.props.onStateChanged(p, controlState)
		end
	end
end

function extended:render()
	return self:renderWithSelectionCursorProvider(nil, self.props.cursor)
end

function extended:renderWithSelectionCursorProvider(_, selectionImageObject)
	return withStyle(function(p)
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

		if self.props.underlineAlwaysEnabled == true and debugControlState == ControlState.Hover then
			contentStyle.Transparency = 0.3
		end

		local v = fontStyle.RelativeSize * p.Font.BaseSize
		local x = self.props.debugGetTextSize(
			CleanRichTextTags(self.props.text),
			v,
			fontStyle.Font,
			Vector2.new(10000, 0)
		).X

		local text = self.props.text

		if
			self.props.underlineAlwaysEnabled
			or debugControlState == ControlState.Hover
			or debugControlState == ControlState.Pressed
		then
			text = self.applyRichTextUnderline(self.props.text)
		end

		local minPaddingX = self.props.minPaddingX
		local minPaddingY = self.props.minPaddingY

		local vector2 = Vector2.new(x + minPaddingX * 2, v + minPaddingY * 2)

		local createElement = Roact.createElement
		local v2 = Focusable[Interactable]
		local v3 = {
			AnchorPoint = self.props.anchorPoint,
			LayoutOrder = self.props.layoutOrder,
			Position = self.props.position,
			Size = self.props.size,
			isDisabled = self.props.isDisabled,
			onStateChanged = self.onStateChanged,
			userInteractionEnabled = self.props.userInteractionEnabled,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			SelectionImageObject = selectionImageObject,
			[Roact.Event.Activated] = self.props.onActivated,
			[Roact.Ref] = self.props.buttonRef,
			NextSelectionLeft = self.props.NextSelectionLeft,
			NextSelectionRight = self.props.NextSelectionRight,
			NextSelectionUp = self.props.NextSelectionUp,
			NextSelectionDown = self.props.NextSelectionDown
		}
		local v4 = {
			sizeConstraint = Roact.createElement("UISizeConstraint", { MinSize = vector2 }),
			textLabel = Roact.createElement(GenericTextLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				Text = text,
				fontStyle = fontStyle,
				colorStyle = contentStyle,
				RichText = true
			}),
			background = 0
		}

		local background = self.props.hoverBackgroundEnabled

		if background then
			if debugControlState == ControlState.Hover then
				background = Roact.createElement(HoverButtonBackground)
			else
				background = false
			end
		end

		v4.background = background
		return createElement(v2, v3, v4)
	end)
end

function LinkButtonFunctionalWrapper(p)
	local cursor = useCursorByType(CursorType.RoundedRectNoInset)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { cursor = cursor }))
end

return LinkButtonFunctionalWrapper
