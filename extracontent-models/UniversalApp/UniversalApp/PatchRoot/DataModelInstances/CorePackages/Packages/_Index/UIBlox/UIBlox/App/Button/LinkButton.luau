local App = script:FindFirstAncestor("App")
local AppParent = App.Parent
local Core = AppParent.Core
local AppParentParent = AppParent.Parent
local t = require(AppParentParent.t)
local Roact = require(AppParentParent.Roact)
local Cryo = require(AppParentParent.Cryo)
local Interactable = require(Core.Control.Interactable)
local ControlState = require(Core.Control.Enum.ControlState)
local getContentStyle = require(Core.Button.getContentStyle)
local GetTextSize = require(Core.Text.GetTextSize)
local CleanRichTextTags = require(Core.Text.CleanRichTextTags)
local withStyle = require(Core.Style.withStyle)
local GenericTextLabel = require(Core.Text.GenericTextLabel.GenericTextLabel)
local HoverButtonBackground = require(Core.Button.HoverButtonBackground)
local useCursorByType = require(App.SelectionCursor.useCursorByType)
local CursorType = require(App.SelectionCursor.CursorType)
local Focusable = require(AppParentParent.RoactGamepad).Focusable
local v19 = Roact.PureComponent:extend("LinkButton")

v19.validateProps = t.strictInterface({
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
v19.defaultProps = {
	layoutOrder = 0,
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
	debugControlState = nil,
	anchorPoint = Vector2.new(0, 0),
	position = UDim2.new(0, 0, 0, 0),
	size = UDim2.fromScale(0, 0),
	debugGetTextSize = GetTextSize
}

function v19.init(p1) -- line: 109
	-- upvalues: ControlState (copy)
	p1:setState({
		controlState = ControlState.Initialize
	})

	function p1.applyRichTextUnderline(p2) -- line: 114
		return "<u>" .. p2 .. "</u>"
	end
	function p1.onStateChanged(p3, p4) -- line: 118
		-- upvalues: p1 (copy)
		p1:setState({
			controlState = p4
		})

		if p1.props.onStateChanged then
			p1.props.onStateChanged(p3, p4)
		end
	end
end
function v19.render(p5) -- line: 128
	return p5:renderWithSelectionCursorProvider(nil, p5.props.cursor)
end
function v19.renderWithSelectionCursorProvider(p6, _, p8) -- line: 132
	-- upvalues: withStyle (copy), ControlState (copy), getContentStyle (copy), CleanRichTextTags (copy), Roact (copy), Focusable (copy), Interactable (copy), GenericTextLabel (copy), HoverButtonBackground (copy)
	return withStyle(function(p9) -- line: 133
		-- upvalues: p6 (copy), ControlState (copy), getContentStyle (copy), CleanRichTextTags (copy), p8 (copy), Roact (copy), Focusable (copy), Interactable (copy), GenericTextLabel (copy), HoverButtonBackground (copy)
		local v31 = p6.props.debugControlState or p6.state.controlState
		local t1 = {
			[ControlState.Default] = p6.props.colorStyleDefault,
			[ControlState.Hover] = p6.props.colorStyleHover
		}
		local v33 = getContentStyle(t1, v31, p9)
		local v34 = p9.Font[p6.props.fontStyle]

		if p6.props.underlineAlwaysEnabled == true and v31 == ControlState.Hover then
			v33.Transparency = 0.3
		end

		local v35 = v34.RelativeSize * p9.Font.BaseSize
		local X = p6.props.debugGetTextSize(CleanRichTextTags(p6.props.text), v35, v34.Font, Vector2.new(10000, 0)).X
		local text = p6.props.text

		if p6.props.underlineAlwaysEnabled or v31 == ControlState.Hover or v31 == ControlState.Pressed then
			text = p6.applyRichTextUnderline(p6.props.text)
		end

		local minPaddingX = p6.props.minPaddingX
		local minPaddingY = p6.props.minPaddingY
		local vector2 = Vector2.new(X + minPaddingX * 2, v35 + minPaddingY * 2)
		local v41 = p8

		return Roact.createElement(Focusable[Interactable], {
			AnchorPoint = p6.props.anchorPoint,
			LayoutOrder = p6.props.layoutOrder,
			Position = p6.props.position,
			Size = p6.props.size,
			isDisabled = p6.props.isDisabled,
			onStateChanged = p6.onStateChanged,
			userInteractionEnabled = p6.props.userInteractionEnabled,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			SelectionImageObject = v41,
			[Roact.Event.Activated] = p6.props.onActivated,
			[Roact.Ref] = p6.props.buttonRef,
			NextSelectionLeft = p6.props.NextSelectionLeft,
			NextSelectionRight = p6.props.NextSelectionRight,
			NextSelectionUp = p6.props.NextSelectionUp,
			NextSelectionDown = p6.props.NextSelectionDown
		}, {
			sizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = vector2
			}),
			textLabel = Roact.createElement(GenericTextLabel, {
				BackgroundTransparency = 1,
				RichText = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Text = text,
				fontStyle = v34,
				colorStyle = v33
			}),
			background = p6.props.hoverBackgroundEnabled and (v31 == ControlState.Hover and Roact.createElement(HoverButtonBackground))
		})
	end)
end
function LinkButtonFunctionalWrapper(p10) -- line: 209
	-- upvalues: useCursorByType (copy), CursorType (copy), Roact (copy), v19 (copy), Cryo (copy)
	local v26 = useCursorByType(CursorType.RoundedRectNoInset)

	return Roact.createElement(v19, Cryo.Dictionary.join(p10, {
		cursor = v26
	}))
end

return LinkButtonFunctionalWrapper
