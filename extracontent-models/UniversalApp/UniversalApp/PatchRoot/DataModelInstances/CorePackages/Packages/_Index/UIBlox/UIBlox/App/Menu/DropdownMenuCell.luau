local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Core = ParentParentParent.Core
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local Cryo = require(ParentParentParentParent.Cryo)
local Foundation = require(ParentParentParentParent.Foundation)
local Interactable = require(Core.Control.Interactable)
local ControlState = require(Core.Control.Enum.ControlState)
local withStyle = require(Core.Style.withStyle)
local useStyle = require(ParentParentParent.Core.Style.useStyle)
local withSelectionCursorProvider = require(ParentParent.SelectionImage.withSelectionCursorProvider)
local useCursorByType = require(ParentParent.SelectionCursor.useCursorByType)
local CursorType = require(ParentParent.SelectionCursor.CursorType)
local CursorKind = require(ParentParent.SelectionImage.CursorKind)
local ImageSetComponent = require(Core.ImageSet.ImageSetComponent)
local Skeleton = Foundation.Skeleton
local IconSize = require(ParentParent.Constant.IconSize)
local GenericTextLabel = require(Core.Text.GenericTextLabel.GenericTextLabel)
local validateImage = require(Core.ImageSet.Validator.validateImage)
local getContentStyle = require(Core.Button.getContentStyle)
local validateTypographyInfo = require(Core.Style.Validator.validateTypographyInfo)
local validateColorInfo = require(Core.Style.Validator.validateColorInfo)
local StyleDefaults = require(script.Parent.StyleDefaults)
local v26 = Roact.PureComponent:extend("DropdownMenuCell")

local function getColorFromMap(p1, p2) -- line: 40
	-- upvalues: ControlState (copy)
	local v33 = p1[p2] or p1[ControlState.Default]

	return {
		Color = v33.Color,
		Transparency = v33.Transparency
	}
end
local function getButtonStyle(p3, p4, p5, p6, p7) -- line: 48
	-- upvalues: ControlState (copy)
	local v39 = p3(p4, p5, p6)

	if p5 ~= ControlState.Disabled and (p5 ~= ControlState.Pressed and p7) then
		v39.Transparency = 0.5 * v39.Transparency + 0.5
	end

	return v39
end
local function getButtonContentStyle(p8, p9, p10, p11, p12, p13) -- line: 56
	-- upvalues: ControlState (copy)
	local v46 = p8(p9, p10, p11)

	if p10 ~= ControlState.Disabled and p10 ~= ControlState.Pressed and (p12 or not p13) then
		v46.Transparency = 0.5 * v46.Transparency + 0.5
	end

	return v46
end

function v26.init(p14) -- line: 68
	-- upvalues: ControlState (copy)
	p14:setState({
		controlState = ControlState.Initialize
	})

	function p14.onStateChanged(p15, p16) -- line: 73
		-- upvalues: p14 (copy)
		p14:setState({
			controlState = p16
		})

		if p14.props.onStateChanged then
			p14.props.onStateChanged(p15, p16)
		end
	end
end

local v30 = t.union(t.interface({
	[ControlState.Default] = t.string
}), t.interface({
	[ControlState.Default] = validateColorInfo
}))

v26.validateProps = t.interface({
	icon = t.optional(validateImage),
	text = t.optional(t.string),
	textFont = t.optional(validateTypographyInfo),
	buttonImage = validateImage,
	buttonStateColorMap = v30,
	contentStateColorMap = v30,
	textStateColorMap = t.optional(v30),
	iconStateColorMap = t.optional(v30),
	isDisabled = t.optional(t.boolean),
	isActivated = t.optional(t.boolean),
	hasContent = t.optional(t.boolean),
	isLoading = t.optional(t.boolean),
	onActivated = t.callback,
	onStateChanged = t.optional(t.callback),
	userInteractionEnabled = t.optional(t.boolean),
	iconSize = t.optional(t.number),
	containerPadding = t.optional(t.strictInterface({
		left = t.number,
		right = t.number
	})),
	iconTextSpacing = t.optional(t.number),
	border = t.optional(t.strictInterface({
		cornerRadius = t.number,
		size = t.number
	})),
	enableTokenOverride = t.optional(t.boolean),
	selectionOrder = t.optional(t.number),
	selectionCursor = t.optional(t.any)
})
v26.defaultProps = {
	isDisabled = false,
	isLoading = false,
	iconTextSpacing = 5,
	enableTokenOverride = false,
	SliceCenter = Rect.new(8, 8, 9, 9),
	iconSize = IconSize.Regular,
	containerPadding = {
		left = 12,
		right = 20
	},
	border = {
		cornerRadius = 8,
		size = 1
	}
}

function v26.render(p17) -- line: 186
	-- upvalues: withStyle (copy), withSelectionCursorProvider (copy), t (copy), CursorKind (copy), getColorFromMap (copy), getContentStyle (copy), ControlState (copy), Roact (copy), Skeleton (copy), GenericTextLabel (copy), ImageSetComponent (copy), Cryo (copy), Interactable (copy)
	return withStyle(function(p18) -- line: 187
		-- upvalues: withSelectionCursorProvider (copy), t (copy), p17 (copy), CursorKind (copy), getColorFromMap (copy), getContentStyle (copy), ControlState (copy), Roact (copy), Skeleton (copy), GenericTextLabel (copy), ImageSetComponent (copy), Cryo (copy), Interactable (copy)
		return withSelectionCursorProvider(function(p19) -- line: 188
			-- upvalues: t (copy), p18 (copy), p17 (copy), CursorKind (copy), getColorFromMap (copy), getContentStyle (copy), ControlState (copy), Roact (copy), Skeleton (copy), GenericTextLabel (copy), ImageSetComponent (copy), Cryo (copy), Interactable (copy)
			assert(t.table(p18), "Style provider is missing.")

			local controlState = p17.state.controlState
			local text = p17.props.text
			local icon = p17.props.icon
			local iconSize = p17.props.iconSize
			local containerPadding = p17.props.containerPadding
			local iconTextSpacing = p17.props.iconTextSpacing
			local isLoading = p17.props.isLoading
			local isDisabled = p17.props.isDisabled
			local buttonStateColorMap = p17.props.buttonStateColorMap
			local contentStateColorMap = p17.props.contentStateColorMap
			local v67 = p17.props.textStateColorMap or contentStateColorMap
			local v68 = p17.props.iconStateColorMap or contentStateColorMap

			if isLoading then
				isDisabled = true
			end

			local v69 = p17.props.selectionCursor or p19 and p19(CursorKind.RoundedRectNoInset)
			local v70 = if not p17.props.enableTokenOverride then getContentStyle else getColorFromMap
			local v71 = p18
			local isActivated = p17.props.isActivated
			local v73 = v70(buttonStateColorMap, controlState, v71)

			if controlState ~= ControlState.Disabled and controlState ~= ControlState.Pressed and isActivated then
				v73.Transparency = 0.5 * v73.Transparency + 0.5
			end

			local v74 = text

			if v74 then
				local v75 = p18
				local isActivated2 = p17.props.isActivated
				local hasContent = p17.props.hasContent

				v74 = v70(v67, controlState, v75)

				if controlState ~= ControlState.Disabled and controlState ~= ControlState.Pressed and (isActivated2 or not hasContent) then
					v74.Transparency = 0.5 * v74.Transparency + 0.5
				end
			end

			local v78 = icon

			if v78 then
				local v79 = p18
				local isActivated3 = p17.props.isActivated

				v78 = v70(v68, controlState, v79)

				if controlState ~= ControlState.Disabled and controlState ~= ControlState.Pressed and isActivated3 then
					v78.Transparency = 0.5 * v78.Transparency + 0.5
				end
			end

			local buttonImage = p17.props.buttonImage
			local v82 = if not p17.props.enableTokenOverride then p18.Font.Header2 else p17.props.textFont
			local v83 = if icon == nil then containerPadding.right else iconSize + iconTextSpacing + containerPadding.right
			local v84 = if not isLoading then p17.props[Roact.Children] or {
				TextContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1)
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, containerPadding.left)
					}),
					Text = if not text then nil else Roact.createElement(GenericTextLabel, {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						TextWrapped = false,
						Text = text,
						fontStyle = v82,
						colorStyle = v74,
						Size = UDim2.new(1, -v83, 1, 0),
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				}),
				IconContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1)
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Padding = Roact.createElement("UIPadding", {
						PaddingRight = UDim.new(0, containerPadding.right)
					}),
					Icon = icon and Roact.createElement(ImageSetComponent.Label, {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Size = UDim2.fromOffset(iconSize, iconSize),
						Image = icon,
						ImageColor3 = v78.Color,
						ImageTransparency = v78.Transparency
					}) or nil
				})
			} else {
				isLoadingShimmer = Roact.createElement(Skeleton, {
					Size = UDim2.fromScale(1, 1)
				})
			}
			local t1 = {
				isActivated = Cryo.None,
				hasContent = Cryo.None,
				icon = Cryo.None,
				text = Cryo.None,
				textFont = Cryo.None,
				buttonImage = Cryo.None,
				buttonStateColorMap = Cryo.None,
				contentStateColorMap = Cryo.None,
				textStateColorMap = Cryo.None,
				iconStateColorMap = Cryo.None,
				iconSize = Cryo.None,
				containerPadding = Cryo.None,
				iconTextSpacing = Cryo.None,
				border = Cryo.None,
				enableTokenOverride = Cryo.None,
				onActivated = Cryo.None,
				isLoading = Cryo.None,
				[Roact.Children] = Cryo.None,
				isDisabled = isDisabled,
				onStateChanged = p17.onStateChanged,
				userInteractionEnabled = p17.props.userInteractionEnabled,
				ScaleType = Enum.ScaleType.Slice,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				selectionCursor = Cryo.None,
				SelectionImageObject = v69,
				SelectionOrder = p17.props.selectionOrder,
				[Roact.Event.Activated] = p17.props.onActivated
			}
			local uDim2, t2, v89

			if p17.props.enableTokenOverride then
				local size = p17.props.border.size

				uDim2 = UDim2.new(1, -2 * size, 1, -2 * size)
				t2 = {
					UIStroke = Roact.createElement("UIStroke", {
						Color = v73.Color,
						Transparency = v73.Transparency,
						Thickness = size
					}),
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, p17.props.border.cornerRadius)
					})
				}
				v89 = Cryo.Dictionary.join(p17.props, t1)
			else
				uDim2 = UDim2.new(1, 0, 1, 0)
				t2 = {}
				v89 = Cryo.Dictionary.join(p17.props, {
					Image = buttonImage,
					ImageColor3 = v73.Color,
					ImageTransparency = v73.Transparency
				}, t1)
			end

			return Roact.createElement(Interactable, v89, {
				ButtonContent = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = uDim2
				}, Cryo.Dictionary.join(t2, v84))
			})
		end)
	end)
end

return function(p20) -- line: 383
	-- upvalues: useCursorByType (copy), CursorType (copy), Cryo (copy), useStyle (copy), StyleDefaults (copy), Roact (copy), v26 (copy)
	local v50 = useCursorByType(CursorType.RoundedRectNoInset)
	local v51 = Cryo.Dictionary.join(p20, {
		selectionCursor = v50
	})

	if p20.enableTokenOverride then
		local v52 = useStyle()

		v51 = Cryo.Dictionary.join(StyleDefaults.getDropdownMenuCellDefaultTokens(v52), p20)
	end

	return Roact.createElement(v26, v51)
end
