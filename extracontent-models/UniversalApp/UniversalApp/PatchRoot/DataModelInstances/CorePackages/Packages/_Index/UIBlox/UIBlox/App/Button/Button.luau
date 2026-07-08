local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local scriptParentParentParentParent = scriptParentParentParent.Parent
local Core = scriptParentParentParent.Core
local React = require(scriptParentParentParentParent.React)
local Cryo = require(scriptParentParentParentParent.Cryo)
local RoactGamepad = require(scriptParentParentParentParent.RoactGamepad)
local t = require(scriptParentParentParentParent.t)
local Foundation = require(scriptParentParentParentParent.Foundation)
local FoundationButtonUtils = require(scriptParent.FoundationButtonUtils)
local validateImage = require(Core.ImageSet.Validator.validateImage)
local validateFontInfo = require(Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(scriptParentParentParent.Core.Style.Validator.validateTypographyInfo)
local ButtonType = require(scriptParent.Enum.ButtonType)
local StandardButtonSize = require(Core.Button.Enum.StandardButtonSize)
local GenericButton = require(Core.Button.GenericButton)
local ControlState = require(Core.Control.Enum.ControlState)
local isReactTagProp = require(scriptParentParentParent.Utility.isReactTagProp)
local Images = require(scriptParentParent.ImageSet.Images)
local CursorKind = require(scriptParentParent.SelectionImage.CursorKind)
local withSelectionCursorProvider = require(scriptParentParent.SelectionImage.withSelectionCursorProvider)
local useCursor = require(scriptParentParentParent.App.SelectionCursor.useCursor)
local UIBloxConfig = require(scriptParentParentParent.UIBloxConfig)
local v25 = React.PureComponent:extend("Button")
local t1 = {
	[ButtonType.Alert] = {
		[ControlState.Default] = "Alert"
	},
	[ButtonType.PrimaryContextual] = {
		[ControlState.Default] = "ContextualPrimaryDefault",
		[ControlState.Hover] = "ContextualPrimaryOnHover"
	},
	[ButtonType.PrimarySystem] = {
		[ControlState.Default] = "SystemPrimaryDefault",
		[ControlState.Hover] = "SystemPrimaryOnHover"
	},
	[ButtonType.Secondary] = {
		[ControlState.Default] = "SecondaryDefault",
		[ControlState.Hover] = "SecondaryOnHover"
	}
}
local t2 = {
	[ButtonType.Alert] = {
		[ControlState.Default] = "Alert"
	},
	[ButtonType.PrimaryContextual] = {
		[ControlState.Default] = "ContextualPrimaryContent"
	},
	[ButtonType.PrimarySystem] = {
		[ControlState.Default] = "SystemPrimaryContent"
	},
	[ButtonType.Secondary] = {
		[ControlState.Default] = "SecondaryContent",
		[ControlState.Hover] = "SecondaryOnHover"
	}
}
local t3 = {
	[ButtonType.Alert] = Images["component_assets/circle_17_stroke_1"],
	[ButtonType.PrimaryContextual] = Images["component_assets/circle_17"],
	[ButtonType.PrimarySystem] = Images["component_assets/circle_17"],
	[ButtonType.Secondary] = Images["component_assets/circle_17_stroke_1"]
}
local t4 = {
	[ButtonType.PrimaryContextual] = Images["component_assets/bulletRight_17"],
	[ButtonType.PrimarySystem] = Images["component_assets/bulletRight_17"]
}
local t5 = {
	[ButtonType.Alert] = false,
	[ButtonType.PrimaryContextual] = true,
	[ButtonType.PrimarySystem] = false,
	[ButtonType.Secondary] = false
}
local uDim = UDim.new(0, 8)

v25.validateProps = t.strictInterface({
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
v25.defaultProps = {
	isDisabled = false,
	isLoading = false,
	isRoactGamepadEnabled = true,
	buttonType = ButtonType.PrimarySystem
}

function v25.render(p1) -- line: 173
	-- upvalues: withSelectionCursorProvider (copy), React (copy), RoactGamepad (copy), GenericButton (copy), CursorKind (copy), t5 (copy), t3 (copy), t4 (copy), t1 (copy), t2 (copy)
	return withSelectionCursorProvider(function(p2) -- line: 174
		-- upvalues: p1 (copy), React (copy), RoactGamepad (copy), GenericButton (copy), CursorKind (copy), t5 (copy), t3 (copy), t4 (copy), t1 (copy), t2 (copy)
		local isRoactGamepadEnabled = p1.props.isRoactGamepadEnabled

		return React.createElement(if not isRoactGamepadEnabled then GenericButton else RoactGamepad.Focusable[GenericButton], {
			[React.Tag] = p1.props[React.Tag],
			Size = p1.props.size,
			standardSize = p1.props.standardSize,
			maxWidth = p1.props.maxWidth,
			fitContent = p1.props.fitContent,
			AnchorPoint = p1.props.anchorPoint,
			Position = p1.props.position,
			LayoutOrder = p1.props.layoutOrder,
			SelectionImageObject = if not p1.props.cursor then p2(CursorKind.RoundedRectNoInset) else p1.props.cursor,
			icon = p1.props.icon,
			text = p1.props.text,
			inputIcon = p1.props.inputIcon,
			fontStyle = p1.props.fontStyle,
			isDisabled = p1.props.isDisabled,
			isLoading = p1.props.isLoading,
			isHoverBackgroundEnabled = t5[p1.props.buttonType],
			isDelayedInput = p1.props.isDelayedInput,
			enableInputDelayed = p1.props.enableInputDelayed,
			delayInputSeconds = p1.props.delayInputSeconds,
			onActivated = p1.props.onActivated,
			onStateChanged = p1.props.onStateChanged,
			userInteractionEnabled = p1.props.userInteractionEnabled,
			buttonImage = t3[p1.props.buttonType],
			delayedInputImage = t4[p1.props.buttonType],
			buttonStateColorMap = t1[p1.props.buttonType],
			contentStateColorMap = t2[p1.props.buttonType],
			buttonTextOverride = p1.props.buttonTextOverride,
			Selectable = p1.props.Selectable,
			NextSelectionUp = p1.props.NextSelectionUp,
			NextSelectionDown = p1.props.NextSelectionDown,
			NextSelectionLeft = p1.props.NextSelectionLeft,
			NextSelectionRight = p1.props.NextSelectionRight,
			ref = p1.props.buttonRef,
			feedbackType = p1.props.feedbackType,
			[React.Change.AbsoluteSize] = p1.props[React.Change.AbsoluteSize],
			[React.Change.AbsolutePosition] = p1.props[React.Change.AbsolutePosition]
		})
	end)
end

local function v32(p3) -- line: 227
	-- upvalues: useCursor (copy), uDim (copy), Cryo (copy), React (copy), v25 (copy)
	local v36 = useCursor(uDim)
	local v37 = Cryo.Dictionary.join({
		cursor = v36
	}, p3)

	return React.createElement(v25, v37)
end

local v33 = React.forwardRef(function(p4, p5) -- line: 235
	-- upvalues: UIBloxConfig (copy), Foundation (copy), Cryo (copy), v25 (copy), FoundationButtonUtils (copy), React (copy), RoactGamepad (copy), v32 (copy)
	if UIBloxConfig.useFoundationButton and not p4.DO_NOT_USE_useUIBloxButton then
		local v40 = Foundation.Hooks.useTokens()
		local v41 = Cryo.Dictionary.join(v25.defaultProps, p4)
		local isRoactGamepadEnabled = v41.isRoactGamepadEnabled
		local v43 = FoundationButtonUtils.getMaxWidth(v41.standardSize, v41.maxWidth)
		local v44 = React.useRef(nil)
		local v45 = p4.buttonRef or (p5 or v44)

		React.useLayoutEffect(function() -- line: 246
			-- upvalues: v43 (copy), v45 (copy)
			local UISizeConstraint = nil

			if v43 and (v45 and typeof(v45) == "table" and v45.current) then
				UISizeConstraint = Instance.new("UISizeConstraint")
				UISizeConstraint.MaxSize = Vector2.new(v43, 1e999)
				UISizeConstraint.Parent = v45.current
			end

			return function() -- line: 254
				-- upvalues: UISizeConstraint (ref)
				if UISizeConstraint then
					UISizeConstraint.Parent = nil
					UISizeConstraint:Destroy()
				end
			end
		end, {
			v43,
			v45
		})

		return React.createElement(if not isRoactGamepadEnabled then Foundation.Button else RoactGamepad.Focusable[Foundation.Button], {
			variant = FoundationButtonUtils.buttonMapping[v41.buttonType],
			size = FoundationButtonUtils.getSizeMapping(v41.standardSize, v41.size, v40),
			width = FoundationButtonUtils.getWidth(v41.standardSize, v41.size, v41.fitContent),
			icon = FoundationButtonUtils.findIcon(v41.icon),
			text = v41.text,
			isLoading = v41.isLoading,
			isDisabled = v41.isDisabled or (v41.userInteractionEnabled == false or v41.isDelayedInput and not v41.enableInputDelayed),
			inputDelay = if not v41.isDelayedInput or not v41.enableInputDelayed then nil else v41.delayInputSeconds or 3,
			onActivated = v41.onActivated,
			testId = FoundationButtonUtils.getTestId(v41[React.Tag]),
			ref = v45,
			AnchorPoint = v41.anchorPoint,
			Position = v41.position,
			LayoutOrder = v41.layoutOrder,
			Selectable = v41.Selectable,
			NextSelectionUp = v41.NextSelectionUp,
			NextSelectionDown = v41.NextSelectionDown,
			NextSelectionLeft = v41.NextSelectionLeft,
			NextSelectionRight = v41.NextSelectionRight
		})
	end

	return React.createElement(v32, Cryo.Dictionary.join(p4, {
		buttonRef = p4.buttonRef or p5
	}))
end)

v33.validateProps = v25.validateProps

return v33
