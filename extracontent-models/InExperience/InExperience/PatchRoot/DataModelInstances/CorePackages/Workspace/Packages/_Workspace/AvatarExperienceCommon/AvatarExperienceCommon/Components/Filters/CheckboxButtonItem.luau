local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local Checkbox = Foundation.Checkbox
local Text = Foundation.Text
local View = Foundation.View
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local RoactGamepad = require(parent.RoactGamepad)
local Focusable = RoactGamepad.Focusable

local ExpandingFrame = require(script.Parent.ExpandingFrame)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCatalogSpecialFeaturesFilter = AvatarExperienceFlags.FFlagAXCatalogSpecialFeaturesFilter

local function CheckboxButtonItem(props)
	local v = useTokens()
	local v2 = useStyle()
	local onActivated = React.useCallback(function()
		if props.onActivated then
			props.onActivated(props.id)
		end
	end, { props.onActivated, props.id })

	local itemHeight = props.itemHeight or v.Size.Size_900

	local ref = React.useRef(nil)

	local v3, v4 = React.useBinding(itemHeight)

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		local v5 = itemHeight

		if p then
			v5 += p.AbsoluteSize.Y
		end

		if not props.hideDivider then
			v5 += FFlagAXCatalogSpecialFeaturesFilter and 1 or v.Size.Size_50
		end

		v4(v5)

		if props.onHeightChanged then
			props.onHeightChanged(v5)
		end
	end, { itemHeight, props.hideDivider, v4, props.onHeightChanged })

	React.useEffect(function()
		onAbsoluteSizeChanged(ref.current)
	end, {})

	local v5 = props.expandedView and props.isSelected == true
	local divider

	if FFlagAXCatalogSpecialFeaturesFilter and not props.hideDivider then
		divider = React.createElement(
			"Frame",
			{
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			{
				Line = React.createElement("Frame", {
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -12, 0, 0),
					Size = UDim2.new(1, -24, 1, 0),
					BackgroundColor3 = v.Color.Stroke.Emphasis.Color3,
					BackgroundTransparency = v.Color.Stroke.Emphasis.Transparency,
					BorderSizePixel = 0
				})
			}
		)
	end

	local createElement = React.createElement
	local v6 = {
		Size = v3:map(function(p)
			return UDim2.new(1, 0, 0, p)
		end),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ref = props.frameRef,
		NextSelectionLeft = props.NextSelectionLeft,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown
	}
	local v7 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		}),
		Contents = 0,
		ExpandingFrame = 0,
		Divider = 0
	}

	local createElement2 = React.createElement
	local size

	if FFlagAXCatalogSpecialFeaturesFilter then
		size = UDim2.new(1, 0, 0, itemHeight)
	end

	local v8 = {
		Size = size,
		tag = FFlagAXCatalogSpecialFeaturesFilter and "row items-center" or "size-full row items-center padding-left-large padding-y-medium padding-right-none",
		padding = FFlagAXCatalogSpecialFeaturesFilter and {
			left = UDim.new(0, 24),
			top = UDim.new(0, 12),
			bottom = UDim.new(0, 12),
			right = UDim.new(0, 12)
		} or nil,
		LayoutOrder = 1,
		ref = props.defaultChildRef,
		NextSelectionDown = 0,
		SelectionImageObject = 0
	}
	local nextSelectionDown

	if v5 then
		nextSelectionDown = ref
	end

	v8.NextSelectionDown = nextSelectionDown
	v8.SelectionImageObject = props.SelectionImageObject

	local createElement3 = React.createElement
	local size2

	if FFlagAXCatalogSpecialFeaturesFilter then
		size2 = UDim2.new(1, -24, 1, 0)
	else
		size2 = UDim2.new(1, -v.Size.Size_400 - v.Size.Size_400, 1, 0)
	end

	local v9 = {}
	v9.Size = size2
	v9.BackgroundTransparency = 1
	v9.Text = ""
	v9.Active = not props.isDisabled
	local activated = React.Event.Activated
	local v10

	if not props.isDisabled then
		v10 = onActivated
	end

	v9[activated] = v10
	v9.LayoutOrder = 1
	local v11 = {
		CustomViewFrame = props.customView and React.createElement(
			View,
			{ Size = UDim2.new(1, 0, 1, 0), tag = "gui-object-defaults", LayoutOrder = 1 },
			{ CustomView = props.customView }
		),
		TitleText = 0
	}

	local titleText = props.text and not props.customView

	if titleText then
		if FFlagAXCatalogSpecialFeaturesFilter then
			local createElement4 = React.createElement
			local v12 = {
				size = UDim2.new(1, 0, 1, 0),
				colorStyle = 0,
				fontStyle = 0,
				text = 0,
				layoutOrder = 1,
				textXAlignment = 0
			}
			local colorStyle

			if props.isSelected then
				colorStyle = v2.Theme.TextEmphasis
			else
				colorStyle = v2.Theme.TextDefault
			end

			v12.colorStyle = colorStyle

			v12.fontStyle = v2.Font.Header2
			v12.text = props.text

			v12.textXAlignment = Enum.TextXAlignment.Left
			titleText = createElement4(StyledTextLabel, v12)
		else
			titleText = React.createElement(Text, {
				Size = UDim2.new(1, 0, 1, 0),
				Text = props.text,
				LayoutOrder = 1,
				tag = "text-title-medium content-default text-align-x-left auto-y"
			})
		end
	end

	v11.TitleText = titleText
	local v12 = {
		ClickableTextArea = createElement3("TextButton", v9, v11),
		RightContent = 0
	}
	local rightContent

	if FFlagAXCatalogSpecialFeaturesFilter then
		rightContent = React.createElement(
			"Frame",
			{
				Size = UDim2.fromOffset(v.Size.Size_600, v.Size.Size_600),
				BackgroundTransparency = 1,
				LayoutOrder = 3
			},
			{
				UIScale = React.createElement("UIScale", {
					Scale = 24 / v.Size.Size_600
				}),
				Checkbox = React.createElement(Focusable[Checkbox], {
					label = "",
					isChecked = props.isSelected,
					isDisabled = props.isDisabled,
					onActivated = onActivated,
					size = InputSize.Medium
				})
			}
		)
	else
		rightContent = React.createElement(Focusable[Checkbox], {
			label = "",
			isChecked = props.isSelected,
			isDisabled = props.isDisabled,
			onActivated = onActivated,
			size = InputSize.Medium,
			LayoutOrder = 3
		})
	end

	v12.RightContent = rightContent
	v7.Contents = createElement2(View, v8, v12)

	v7.ExpandingFrame = props.expandedView and React.createElement(Focusable[ExpandingFrame], {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, props.expandedViewHeight or 0),
		isExpanded = props.isSelected == true,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		ref = ref,
		NextSelectionUp = props.defaultChildRef
	}, { ExpandedView = props.expandedView })

	v7.Divider = divider
	return createElement("Frame", v6, v7)
end

return React.forwardRef(function(p, frameRef)
	return React.createElement(CheckboxButtonItem, Cryo.Dictionary.join(p, { frameRef = frameRef }))
end)
