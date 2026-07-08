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
local getIconSize = require(App.ImageSet.getIconSize)
local bindingValidator = require(Core.Utility.bindingValidator)
local validateImage = require(Core.ImageSet.Validator.validateImage)
local validateColorInfo = require(Core.Style.Validator.validateColorInfo)
local withStyle = require(Core.Style.withStyle)
local HoverButtonBackground = require(Core.Button.HoverButtonBackground)
local ImageSetComponent = require(Core.ImageSet.ImageSetComponent)
local IconSize = require(App.ImageSet.Enum.IconSize)
local Focusable = require(AppParentParent.RoactGamepad).Focusable
local isCallable = require(AppParent.Utility.isCallable)
local useCursor = require(AppParent.App.SelectionCursor.useCursor)
local uDim = UDim.new(0, 8)
local v23 = Roact.PureComponent:extend("IconButton")

v23.validateProps = t.strictInterface({
	onStateChanged = t.optional(isCallable),
	isDisabled = t.optional(t.boolean),
	colorStyleDefault = t.optional(t.string),
	colorStyleHover = t.optional(t.string),
	colorDefault = t.optional(validateColorInfo),
	colorHover = t.optional(validateColorInfo),
	userInteractionEnabled = t.optional(t.boolean),
	onActivated = t.optional(isCallable),
	onAbsolutePositionChanged = t.optional(isCallable),
	anchorPoint = t.optional(t.Vector2),
	layoutOrder = t.optional(t.number),
	position = t.optional(t.union(t.UDim2, t.table)),
	size = t.optional(t.union(t.UDim2, t.table)),
	icon = t.optional(validateImage),
	iconSize = t.optional(IconSize.isEnumValue),
	iconColor3 = t.optional(t.Color3),
	iconTransparency = t.optional(t.union(t.number, bindingValidator(t.number))),
	showBackground = t.optional(t.boolean),
	backgroundColor = t.optional(validateColorInfo),
	backgroundTransparency = t.optional(t.union(t.number, bindingValidator(t.number))),
	cursor = t.optional(t.table),
	[Roact.Children] = t.optional(t.table),
	debugControlState = t.optional(ControlState.isEnumValue),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	inputBindings = t.optional(t.table),
	buttonRef = t.optional(t.union(t.callback, t.table)),
	[Roact.Change.AbsoluteSize] = t.optional(t.callback),
	isRoactGamepadEnabled = t.optional(t.boolean)
})
v23.defaultProps = {
	layoutOrder = 0,
	size = nil,
	icon = "",
	colorStyleDefault = "IconEmphasis",
	colorStyleHover = "IconEmphasis",
	iconColor3 = nil,
	iconTransparency = nil,
	showBackground = false,
	backgroundColor = nil,
	backgroundTransparency = nil,
	isDisabled = false,
	userInteractionEnabled = true,
	debugControlState = nil,
	isRoactGamepadEnabled = true,
	anchorPoint = Vector2.new(0, 0),
	position = UDim2.new(0, 0, 0, 0),
	iconSize = IconSize.Medium
}

function v23.init(p1) -- line: 133
	-- upvalues: ControlState (copy), IconSize (copy)
	p1:setState({
		controlState = ControlState.Initialize
	})

	function p1.onStateChanged(p2, p3) -- line: 138
		-- upvalues: p1 (copy)
		p1:setState({
			controlState = p3
		})

		if p1.props.onStateChanged then
			p1.props.onStateChanged(p2, p3)
		end
	end

	local t1 = {
		[IconSize.Small] = 1,
		[IconSize.Medium] = 2,
		[IconSize.Large] = 3,
		[IconSize.XLarge] = 4,
		[IconSize.XXLarge] = 5
	}

	function p1.getSize(p4) -- line: 154
		-- upvalues: p1 (copy), t1 (copy)
		if p1.props.size then
			return p1.props.size
		end

		local v46 = p4 + 4 * t1[p1.props.iconSize]

		return UDim2.fromOffset(v46, v46)
	end
end
function v23.render(p5) -- line: 165
	-- upvalues: withStyle (copy)
	return withStyle(function(p6) -- line: 166
		-- upvalues: p5 (copy)
		return p5:renderWithProviders(p6, nil, nil)
	end)
end
function v23.renderWithProviders(p7, p8, _, _) -- line: 171
	-- upvalues: getIconSize (copy), ControlState (copy), getContentStyle (copy), Roact (copy), Focusable (copy), Interactable (copy), ImageSetComponent (copy), HoverButtonBackground (copy), uDim (copy)
	local v33 = getIconSize(p7.props.iconSize, p8)
	local v34 = p7.getSize(v33)
	local showBackground = p7.props.showBackground
	local v36 = p7.props.debugControlState or p7.state.controlState
	local t2 = {
		[ControlState.Default] = p7.props.colorStyleDefault,
		[ControlState.Hover] = p7.props.colorStyleHover
	}
	local v38 = getContentStyle(t2, v36, p8)
	local v39 = if p7.props.backgroundColor ~= nil then p7.props.backgroundColor else p8.Theme.UIMuted

	return Roact.createElement(if not p7.props.isRoactGamepadEnabled then Interactable else Focusable[Interactable], {
		AnchorPoint = p7.props.anchorPoint,
		LayoutOrder = p7.props.layoutOrder,
		Position = p7.props.position,
		Size = v34,
		isDisabled = p7.props.isDisabled,
		onStateChanged = p7.onStateChanged,
		userInteractionEnabled = p7.props.userInteractionEnabled,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		[Roact.Change.AbsoluteSize] = p7.props[Roact.Change.AbsoluteSize],
		[Roact.Change.AbsolutePosition] = p7.props.onAbsolutePositionChanged,
		[Roact.Event.Activated] = p7.props.onActivated,
		[Roact.Ref] = p7.props.buttonRef,
		NextSelectionLeft = p7.props.NextSelectionLeft,
		NextSelectionRight = p7.props.NextSelectionRight,
		NextSelectionUp = p7.props.NextSelectionUp,
		NextSelectionDown = p7.props.NextSelectionDown,
		inputBindings = if not p7.props.isRoactGamepadEnabled then nil else p7.props.inputBindings,
		SelectionImageObject = p7.props.cursor
	}, {
		sizeConstraint = Roact.createElement("UISizeConstraint", {
			MinSize = Vector2.new(v33, v33)
		}),
		imageLabel = Roact.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(v33, v33),
			Image = p7.props.icon,
			ImageColor3 = p7.props.iconColor3 or v38.Color,
			ImageTransparency = p7.props.iconTransparency or v38.Transparency
		}, p7.props[Roact.Children]),
		hoverBackground = v36 == ControlState.Hover and Roact.createElement(HoverButtonBackground) or nil,
		background = showBackground and Roact.createElement("Frame", {
			ZIndex = 0,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v39.Color,
			BackgroundTransparency = p7.props.backgroundTransparency or v39.Transparency
		}, {
			corner = Roact.createElement("UICorner", {
				CornerRadius = uDim
			})
		}) or nil
	})
end

local function IconButtonFunctionalWrapper(p11) -- line: 239
	-- upvalues: useCursor (copy), uDim (copy), Roact (copy), v23 (copy), Cryo (copy)
	local v41 = useCursor(uDim)

	return Roact.createElement(v23, Cryo.Dictionary.join(p11, {
		cursor = v41
	}))
end

local v25 = Roact.PureComponent:extend("IconButtonOuterWrapper")

v25.validateProps = v23.validateProps

function v25.render(p12) -- line: 253
	-- upvalues: Roact (copy), IconButtonFunctionalWrapper (copy)
	return Roact.createElement(IconButtonFunctionalWrapper, p12.props)
end

return v25
