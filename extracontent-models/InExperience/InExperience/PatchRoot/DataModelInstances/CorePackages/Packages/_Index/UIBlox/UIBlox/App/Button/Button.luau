local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent
local core = parent3.Core

local React = require(parent4.React)
local Cryo = require(parent4.Cryo)
local RoactGamepad = require(parent4.RoactGamepad)
local t = require(parent4.t)
local Foundation = require(parent4.Foundation)
local FoundationButtonUtils = require(parent.FoundationButtonUtils)

local validateImage = require(core.ImageSet.Validator.validateImage)
local validateFontInfo = require(core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(parent3.Core.Style.Validator.validateTypographyInfo)

local ButtonType = require(parent.Enum.ButtonType)
local StandardButtonSize = require(core.Button.Enum.StandardButtonSize)
local GenericButton = require(core.Button.GenericButton)
local ControlState = require(core.Control.Enum.ControlState)

local isReactTagProp = require(parent3.Utility.isReactTagProp)

local Images = require(parent2.ImageSet.Images)
local CursorKind = require(parent2.SelectionImage.CursorKind)
local withSelectionCursorProvider = require(parent2.SelectionImage.withSelectionCursorProvider)
local useCursor = require(parent3.App.SelectionCursor.useCursor)
local UIBloxConfig = require(parent3.UIBloxConfig)

local extended = React.PureComponent:extend("Button")

local v = {}
local Alert = ButtonType.Alert
v[Alert] = { [ControlState.Default] = "Alert" }

local PrimaryContextual = ButtonType.PrimaryContextual
v[PrimaryContextual] = {
	[ControlState.Default] = "ContextualPrimaryDefault",
	[ControlState.Hover] = "ContextualPrimaryOnHover"
}

local PrimarySystem = ButtonType.PrimarySystem
v[PrimarySystem] = {
	[ControlState.Default] = "SystemPrimaryDefault",
	[ControlState.Hover] = "SystemPrimaryOnHover"
}

local Secondary = ButtonType.Secondary
v[Secondary] = {
	[ControlState.Default] = "SecondaryDefault",
	[ControlState.Hover] = "SecondaryOnHover"
}

local v2 = {}
local alert = ButtonType.Alert
v2[alert] = { [ControlState.Default] = "Alert" }

local primaryContextual = ButtonType.PrimaryContextual
v2[primaryContextual] = { [ControlState.Default] = "ContextualPrimaryContent" }

local primarySystem = ButtonType.PrimarySystem
v2[primarySystem] = { [ControlState.Default] = "SystemPrimaryContent" }

local secondary = ButtonType.Secondary
v2[secondary] = {
	[ControlState.Default] = "SecondaryContent",
	[ControlState.Hover] = "SecondaryOnHover"
}

local v3 = {
	[ButtonType.Alert] = Images["component_assets/circle_17_stroke_1"],
	[ButtonType.PrimaryContextual] = Images["component_assets/circle_17"],
	[ButtonType.PrimarySystem] = Images["component_assets/circle_17"],
	[ButtonType.Secondary] = Images["component_assets/circle_17_stroke_1"]
}

local component_assetsbulletRight_17s = {
	[ButtonType.PrimaryContextual] = Images["component_assets/bulletRight_17"],
	[ButtonType.PrimarySystem] = Images["component_assets/bulletRight_17"]
}

local v4 = {
	[ButtonType.Alert] = false,
	[ButtonType.PrimaryContextual] = true,
	[ButtonType.PrimarySystem] = false,
	[ButtonType.Secondary] = false
}

local udim = UDim.new(0, 8)

extended.validateProps = t.strictInterface({
	[React.Tag] = isReactTagProp,
	buttonType = t.optional(ButtonType.isEnumValue),
	automaticSize = t.optional(t.EnumItem),
	size = t.optional(t.UDim2),
	standardSize = t.optional(StandardButtonSize.isEnumValue),
	maxWidth = t.optional(t.numberPositive),
	fitContent = t.optional(t.boolean),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.number),
	icon = t.optional(validateImage),
	text = t.optional(t.string),
	inputIcon = t.optional(validateImage),
	fontStyle = t.optional(t.union(t.string, validateFontInfo, validateTypographyInfo)),
	buttonTextOverride = t.optional(t.table),
	isDisabled = t.optional(t.boolean),
	isLoading = t.optional(t.boolean),
	isHoverBackgroundEnabled = t.optional(t.boolean),
	isDelayedInput = t.optional(t.boolean),
	enableInputDelayed = t.optional(t.boolean),
	delayInputSeconds = t.optional(t.numberPositive),
	onActivated = t.callback,
	onStateChanged = t.optional(t.callback),
	userInteractionEnabled = t.optional(t.boolean),
	feedbackType = t.optional(t.string),
	Selectable = t.optional(t.boolean),
	NextSelectionDown = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	buttonRef = t.optional(t.union(t.table, t.callback)),
	isRoactGamepadEnabled = t.optional(t.boolean),
	cursor = t.optional(t.any),
	DO_NOT_USE_useUIBloxButton = t.optional(t.boolean),
	[React.Change.AbsoluteSize] = t.optional(t.callback),
	[React.Change.AbsolutePosition] = t.optional(t.callback)
})

extended.defaultProps = {
	buttonType = ButtonType.PrimarySystem,
	isDisabled = false,
	isLoading = false,
	isRoactGamepadEnabled = true
}

function extended.render(p)
	return withSelectionCursorProvider(function(callback)
		local isRoactGamepadEnabled = p.props.isRoactGamepadEnabled
		local createElement = React.createElement
		local v5

		if isRoactGamepadEnabled then
			v5 = RoactGamepad.Focusable[GenericButton]
		else
			v5 = GenericButton
		end

		local v6 = {
			[React.Tag] = p.props[React.Tag],
			Size = p.props.size,
			standardSize = p.props.standardSize,
			maxWidth = p.props.maxWidth,
			fitContent = p.props.fitContent,
			AnchorPoint = p.props.anchorPoint,
			Position = p.props.position,
			LayoutOrder = p.props.layoutOrder
		}
		local selectionImageObject

		if p.props.cursor then
			selectionImageObject = p.props.cursor
		else
			selectionImageObject = callback(CursorKind.RoundedRectNoInset)
		end

		v6.SelectionImageObject = selectionImageObject

		v6.icon = p.props.icon
		v6.text = p.props.text
		v6.inputIcon = p.props.inputIcon
		v6.fontStyle = p.props.fontStyle
		v6.isDisabled = p.props.isDisabled
		v6.isLoading = p.props.isLoading

		v6.isHoverBackgroundEnabled = v4[p.props.buttonType]
		v6.isDelayedInput = p.props.isDelayedInput
		v6.enableInputDelayed = p.props.enableInputDelayed
		v6.delayInputSeconds = p.props.delayInputSeconds

		v6.onActivated = p.props.onActivated
		v6.onStateChanged = p.props.onStateChanged
		v6.userInteractionEnabled = p.props.userInteractionEnabled
		v6.buttonImage = v3[p.props.buttonType]
		v6.delayedInputImage = component_assetsbulletRight_17s[p.props.buttonType]
		v6.buttonStateColorMap = v[p.props.buttonType]
		v6.contentStateColorMap = v2[p.props.buttonType]
		v6.buttonTextOverride = p.props.buttonTextOverride

		v6.Selectable = p.props.Selectable
		v6.NextSelectionUp = p.props.NextSelectionUp
		v6.NextSelectionDown = p.props.NextSelectionDown
		v6.NextSelectionLeft = p.props.NextSelectionLeft
		v6.NextSelectionRight = p.props.NextSelectionRight
		v6.ref = p.props.buttonRef

		v6.feedbackType = p.props.feedbackType

		v6[React.Change.AbsoluteSize] = p.props[React.Change.AbsoluteSize]
		v6[React.Change.AbsolutePosition] = p.props[React.Change.AbsolutePosition]
		return createElement(v5, v6)
	end)
end

local function fn(p)
	local cursor = useCursor(udim)
	local joined = Cryo.Dictionary.join({ cursor = cursor }, p)

	return React.createElement(extended, joined)
end

local forwardRef = React.forwardRef(function(p, p2)
	if not UIBloxConfig.useFoundationButton or p.DO_NOT_USE_useUIBloxButton then
		return React.createElement(fn, Cryo.Dictionary.join(p, {
			buttonRef = p.buttonRef or p2
		}))
	end

	local v5 = Foundation.Hooks.useTokens()
	local joined = Cryo.Dictionary.join(extended.defaultProps, p)
	local isRoactGamepadEnabled = joined.isRoactGamepadEnabled

	local maxWidth = FoundationButtonUtils.getMaxWidth(joined.standardSize, joined.maxWidth)

	local ref = React.useRef(nil)
	local buttonRef = p.buttonRef or p2 or ref

	React.useLayoutEffect(function()
		local uiSizeConstraint

		if maxWidth and buttonRef and typeof(buttonRef) == "table" and buttonRef.current then
			uiSizeConstraint = Instance.new("UISizeConstraint")
			uiSizeConstraint.MaxSize = Vector2.new(maxWidth, 1e999)
			uiSizeConstraint.Parent = buttonRef.current
		else
			uiSizeConstraint = nil
		end

		return function()
			if uiSizeConstraint then
				uiSizeConstraint.Parent = nil
				uiSizeConstraint:Destroy()
			end
		end
	end, { maxWidth, buttonRef })

	local createElement = React.createElement
	local v6

	if isRoactGamepadEnabled then
		v6 = RoactGamepad.Focusable[Foundation.Button]
	else
		v6 = Foundation.Button
	end

	return createElement(v6, {
		variant = FoundationButtonUtils.buttonMapping[joined.buttonType],
		size = FoundationButtonUtils.getSizeMapping(joined.standardSize, joined.size, v5),
		width = FoundationButtonUtils.getWidth(joined.standardSize, joined.size, joined.fitContent),
		icon = FoundationButtonUtils.findIcon(joined.icon),
		text = joined.text,
		isLoading = joined.isLoading,
		isDisabled = joined.isDisabled or joined.userInteractionEnabled == false or joined.isDelayedInput and not joined.enableInputDelayed,
		inputDelay = joined.isDelayedInput and joined.enableInputDelayed and (joined.delayInputSeconds or 3) or nil,
		onActivated = joined.onActivated,
		testId = FoundationButtonUtils.getTestId(joined[React.Tag]),
		ref = buttonRef,
		AnchorPoint = joined.anchorPoint,
		Position = joined.position,
		LayoutOrder = joined.layoutOrder,
		onAbsoluteSizeChanged = joined[React.Change.AbsoluteSize],
		onAbsolutePositionChanged = joined[React.Change.AbsolutePosition],
		Selectable = joined.Selectable,
		NextSelectionUp = joined.NextSelectionUp,
		NextSelectionDown = joined.NextSelectionDown,
		NextSelectionLeft = joined.NextSelectionLeft,
		NextSelectionRight = joined.NextSelectionRight
	})
end)

forwardRef.validateProps = extended.validateProps

return forwardRef
