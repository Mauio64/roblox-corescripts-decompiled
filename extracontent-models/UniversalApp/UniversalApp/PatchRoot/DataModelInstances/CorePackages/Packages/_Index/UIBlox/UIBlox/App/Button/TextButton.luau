local App = script:FindFirstAncestor("App")
local AppParent = App.Parent
local Core = AppParent.Core
local AppParentParent = AppParent.Parent
local t = require(AppParentParent.t)
local Roact = require(AppParentParent.Roact)
local React = require(AppParentParent.React)
local Cryo = require(AppParentParent.Cryo)
local Interactable = require(Core.Control.Interactable)
local ControlState = require(Core.Control.Enum.ControlState)
local getContentStyle = require(Core.Button.getContentStyle)
local GetTextSize = require(Core.Text.GetTextSize)
local CleanRichTextTags = require(Core.Text.CleanRichTextTags)
local isReactTagProp = require(AppParent.Utility.isReactTagProp)
local CursorKind = require(App.SelectionImage.CursorKind)
local validateColorInfo = require(Core.Style.Validator.validateColorInfo)
local withStyle = require(Core.Style.withStyle)
local GenericTextLabel = require(Core.Text.GenericTextLabel.GenericTextLabel)
local useCursor = require(AppParent.App.SelectionCursor.useCursor)
local uDim = UDim.new(0, 8)
local v21 = Roact.PureComponent:extend("TextButton")

v21.validateProps = t.strictInterface({
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
v21.defaultProps = {
	layoutOrder = 0,
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
	debugControlState = nil,
	anchorPoint = Vector2.new(0, 0),
	position = UDim2.new(0, 0, 0, 0),
	size = UDim2.fromScale(0, 0),
	debugGetTextSize = GetTextSize
}

function v21.init(p1) -- line: 107
	-- upvalues: ControlState (copy)
	p1:setState({
		controlState = ControlState.Initialize
	})

	function p1.onStateChanged(p2, p3) -- line: 112
		-- upvalues: p1 (copy)
		p1:setState({
			controlState = p3
		})

		if p1.props.onStateChanged then
			p1.props.onStateChanged(p2, p3)
		end
	end
end
function v21.render(p4) -- line: 122
	-- upvalues: withStyle (copy)
	return withStyle(function(p5) -- line: 123
		-- upvalues: p4 (copy)
		return p4:renderWithProviders(p5, nil, nil)
	end)
end
function v21.renderWithProviders(p6, p7, p8, p9) -- line: 128
	-- upvalues: ControlState (copy), getContentStyle (copy), CleanRichTextTags (copy), Roact (copy), Interactable (copy), React (copy), uDim (copy), CursorKind (copy), GenericTextLabel (copy)
	local v30 = p6.props.debugControlState or p6.state.controlState
	local t1 = {
		[ControlState.Default] = p6.props.colorStyleDefault,
		[ControlState.Hover] = p6.props.colorStyleHover
	}
	local v32 = getContentStyle(t1, v30, p7)
	local v33 = p7.Font[p6.props.fontStyle]
	local v34 = v33.RelativeSize * p7.Font.BaseSize
	local X = p6.props.debugGetTextSize(p6.props.richText and CleanRichTextTags(p6.props.text) or p6.props.text, v34, v33.Font, Vector2.new(10000, 0)).X
	local v36 = if not p6.props.showBackground then {
		Color = nil,
		Transparency = 1
	} else p6.props.backgroundColor or p7.Theme.UIMuted
	local verticalPadding = p6.props.verticalPadding
	local horizontalPadding = p6.props.horizontalPadding
	local BackgroundOnHover = p7.Theme.BackgroundOnHover

	if p6.props.hoverBackgroundEnabled and v30 == ControlState.Hover then
		v36 = if not v36.Color then BackgroundOnHover else {
			Color = v36.Color:Lerp(BackgroundOnHover.Color, 1 - BackgroundOnHover.Transparency),
			Transparency = v36.Transparency
		}
	end

	return Roact.createElement(Interactable, {
		[React.Tag] = p6.props[React.Tag],
		AnchorPoint = p6.props.anchorPoint,
		LayoutOrder = p6.props.layoutOrder,
		Position = p6.props.position,
		Size = p6.props.size,
		isDisabled = p6.props.isDisabled,
		onStateChanged = p6.onStateChanged,
		userInteractionEnabled = p6.props.userInteractionEnabled,
		BackgroundColor3 = v36.Color,
		BackgroundTransparency = v36.Transparency,
		AutoButtonColor = false,
		SelectionImageObject = if not p9 then p8 and p8(CursorKind.RoundedRectNoInset) else p9(uDim),
		[Roact.Event.Activated] = p6.props.onActivated
	}, {
		corner = Roact.createElement("UICorner", {
			CornerRadius = uDim
		}),
		sizeConstraint = Roact.createElement("UISizeConstraint", {
			MinSize = Vector2.new(X + horizontalPadding * 2, v34 + verticalPadding * 2)
		}),
		textLabel = Roact.createElement(GenericTextLabel, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Text = p6.props.text,
			fontStyle = v33,
			colorStyle = v32,
			RichText = p6.props.richText
		})
	})
end

local function TextButtonFunctionalWrapper(p10) -- line: 203
	-- upvalues: useCursor (copy), uDim (copy), Roact (copy), v21 (copy), Cryo (copy)
	local v41 = useCursor(uDim)

	return Roact.createElement(v21, Cryo.Dictionary.join(p10, {
		cursor = v41
	}))
end

local v23 = Roact.PureComponent:extend("TextButtonOuterWrapper")

v23.validateProps = v21.validateProps

function v23.render(p11) -- line: 217
	-- upvalues: Roact (copy), TextButtonFunctionalWrapper (copy)
	return Roact.createElement(TextButtonFunctionalWrapper, p11.props)
end

return v23
