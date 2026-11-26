local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local checkbox = Foundation.Checkbox
local text = Foundation.Text
local view = Foundation.View
local inputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local focusable = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/RoactGamepad").Focusable

local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/Filters/ExpandingFrame")
local fFlagAXCatalogSpecialFeaturesFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FFlagAXCatalogSpecialFeaturesFilter

local function CheckboxButtonItem(props)
	local v5 = useTokens()
	local v6 = useStyle()
	local v7 = React.useCallback(function()
		if props.onActivated then
			props.onActivated(props.id)
		end
	end, { props.onActivated, props.id })

	local itemHeight = props.itemHeight or v5.Size.Size_900

	local ref = React.useRef(nil)

	local v8, v9 = React.useBinding(itemHeight)

	local v10 = React.useCallback(function(p2)
		local v11 = itemHeight

		if p2 then
			v11 += p2.AbsoluteSize.Y
		end

		if not props.hideDivider then
			v11 += fFlagAXCatalogSpecialFeaturesFilter and 1 or v5.Size.Size_50
		end

		v9(v11)

		if props.onHeightChanged then
			props.onHeightChanged(v11)
		end
	end, { itemHeight, props.hideDivider, v9, props.onHeightChanged })

	React.useEffect(function()
		v10(ref.current)
	end, {})

	local v11 = props.expandedView and props.isSelected == true
	local v12

	if fFlagAXCatalogSpecialFeaturesFilter and not props.hideDivider then
		v12 = React.createElement(
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
					BackgroundColor3 = v5.Color.Stroke.Emphasis.Color3,
					BackgroundTransparency = v5.Color.Stroke.Emphasis.Transparency,
					BorderSizePixel = 0
				})
			}
		)
	end

	local createElement = React.createElement
	local v14 = {
		Size = v8:map(function(p2)
			return UDim2.new(1, 0, 0, p2)
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
	local v15 = {
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
	local v18 = if fFlagAXCatalogSpecialFeaturesFilter then UDim2.new(1, 0, 0, itemHeight) else nil
	local v17 = {
		Size = v18,
		tag = fFlagAXCatalogSpecialFeaturesFilter and "row items-center" or "size-full row items-center padding-left-large padding-y-medium padding-right-none",
		padding = fFlagAXCatalogSpecialFeaturesFilter and {
			left = UDim.new(0, 24),
			top = UDim.new(0, 12),
			bottom = UDim.new(0, 12),
			right = UDim.new(0, 12)
		} or nil,
		LayoutOrder = 1,
		ref = props.defaultChildRef,
		NextSelectionDown = if v11 then ref else nil,
		SelectionImageObject = props.SelectionImageObject
	}

	local createElement3 = React.createElement

	local v23 = if fFlagAXCatalogSpecialFeaturesFilter then UDim2.new(1, -24, 1, 0) else UDim2.new(1, -v5.Size.Size_400 - v5.Size.Size_400, 1, 0)
	local v22 = {}
	v22.Size = v23
	v22.BackgroundTransparency = 1
	v22.Text = ""
	v22.Active = not props.isDisabled
	local activated = React.Event.Activated
	local v24 = if not props.isDisabled then v7 else nil
	v22[activated] = v24
	v22.LayoutOrder = 1
	local v25 = {
		CustomViewFrame = props.customView and React.createElement(
			view,
			{
				Size = UDim2.new(1, 0, 1, 0),
				tag = "gui-object-defaults",
				LayoutOrder = 1
			},
			{ CustomView = props.customView }
		),
		TitleText = 0
	}

	local v26 = props.text and not props.customView

	if v26 then
		if fFlagAXCatalogSpecialFeaturesFilter then
			local createElement4 = React.createElement
			local v28 = {
				size = UDim2.new(1, 0, 1, 0),
				colorStyle = 0,
				fontStyle = 0,
				text = 0,
				layoutOrder = 1,
				textXAlignment = 0
			}
			local v29 = if props.isSelected then v6.Theme.TextEmphasis else v6.Theme.TextDefault
			v28.colorStyle = v29

			v28.fontStyle = v6.Font.Header2
			v28.text = props.text

			v28.textXAlignment = Enum.TextXAlignment.Left
			v26 = createElement4(styledTextLabel, v28)
		else
			v26 = React.createElement(text, {
				Size = UDim2.new(1, 0, 1, 0),
				Text = props.text,
				LayoutOrder = 1,
				tag = "text-title-medium content-default text-align-x-left auto-y"
			})
		end
	end

	v25.TitleText = v26
	local v20 = {
		ClickableTextArea = createElement3("TextButton", v22, v25),
		RightContent = 0
	}
	local v27

	if fFlagAXCatalogSpecialFeaturesFilter then
		v27 = React.createElement(
			"Frame",
			{
				Size = UDim2.fromOffset(v5.Size.Size_600, v5.Size.Size_600),
				BackgroundTransparency = 1,
				LayoutOrder = 3
			},
			{
				UIScale = React.createElement("UIScale", {
					Scale = 24 / v5.Size.Size_600
				}),
				Checkbox = React.createElement(focusable[checkbox], {
					label = "",
					isChecked = props.isSelected,
					isDisabled = props.isDisabled,
					onActivated = v7,
					size = inputSize.Medium
				})
			}
		)
	else
		v27 = React.createElement(focusable[checkbox], {
			label = "",
			isChecked = props.isSelected,
			isDisabled = props.isDisabled,
			onActivated = v7,
			size = inputSize.Medium,
			LayoutOrder = 3
		})
	end

	v20.RightContent = v27
	v15.Contents = createElement2(view, v17, v20)

	v15.ExpandingFrame = props.expandedView and React.createElement(focusable[module5], {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, props.expandedViewHeight or 0),
		isExpanded = props.isSelected == true,
		onAbsoluteSizeChanged = v10,
		ref = ref,
		NextSelectionUp = props.defaultChildRef
	}, { ExpandedView = props.expandedView })

	v15.Divider = v12
	return createElement("Frame", v14, v15)
end

return React.forwardRef(function(p2, p3)
	return React.createElement(CheckboxButtonItem, Cryo.Dictionary.join(p2, {
		frameRef = p3
	}))
end)
