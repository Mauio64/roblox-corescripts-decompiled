local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local interactable = UIBlox.Core.Control.Interactable
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local controlState = UIBlox.Core.Control.Enum.ControlState
local module = require("@luauforge/bundled/fCm")
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local expandingFrame = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.Filters.ExpandingFrame

local component_assetscircle_24_stroke_1 = images["component_assets/circle_24_stroke_1"]
local component_assetscircle_16 = images["component_assets/circle_16"]

local v5 = {
	[controlState.Default] = "BackgroundDefault",
	[controlState.Hover] = "BackgroundOnHover",
	[controlState.Pressed] = "BackgroundOnPress"
}

local v6 = {
	[controlState.Default] = "IconDefault",
	[controlState.Hover] = "IconEmphasis",
	[controlState.Pressed] = "IconDefault"
}

local function getCellStyle(p2, state, p3)
	local v7 = p2[state] or p2[controlState.Default]

	local cellStyle = {
		Color = p3.Theme[v7].Color,
		Transparency = p3.Theme[v7].Transparency
	}

	if state == controlState.Default or state == controlState.Disabled then
		cellStyle.Transparency = 1
	end

	return cellStyle
end

local function getIconStyle(p2, state, p3)
	local v7 = p2[state] or p2[controlState.Default]

	local iconStyle = {
		Color = p3.Theme[v7].Color,
		Transparency = p3.Theme[v7].Transparency
	}

	if state == controlState.Disabled or state == controlState.Pressed then
		iconStyle.Transparency = 0.5 * iconStyle.Transparency + 0.5
	end

	return iconStyle
end

local function getTextStyle(p2, p3)
	local textStyle = { Color = p2.Color, Transparency = p2.Transparency }

	if p3 == controlState.Disabled or p3 == controlState.Pressed then
		textStyle.Transparency = 0.5 * textStyle.Transparency + 0.5
	end

	return textStyle
end

local function RadioButtonItem(props)
	local state, setState = React.useState(controlState.Initialize)

	local v7 = React.useCallback(function(p2, p3)
		setState(p3)
	end, {})

	local v8 = React.useCallback(function()
		if props.onActivated then
			props.onActivated(props.id)
		end
	end, { props.onActivated, props.id })

	local v9 = useStyle()
	local font = v9.Font
	local theme = v9.Theme

	state = props.useDefaultControlState and controlState.Default or state

	local iconStyle = getIconStyle(v6, state, v9)
	local cellStyle = getCellStyle(v5, state, v9)
	local v10 = if props.isSelected then theme.TextEmphasis else theme.TextDefault
	local v11 = { Color = v10.Color, Transparency = v10.Transparency }

	if state == controlState.Disabled or state == controlState.Pressed then
		v11.Transparency = 0.5 * v11.Transparency + 0.5
	end

	local itemHeight = props.itemHeight or 45

	local ref = React.useRef(nil)

	local v12, v13 = React.useBinding(itemHeight)

	local function onAbsoluteSizeChanged(p2)
		local v14 = itemHeight

		if p2 then
			v14 += p2.AbsoluteSize.Y
		end

		if not props.hideDivider then
			v14 += 1
		end

		v13(v14)

		if props.onHeightChanged then
			props.onHeightChanged(v14)
		end
	end

	React.useEffect(function()
		local current = ref.current
		local v14 = itemHeight

		if current then
			v14 += current.AbsoluteSize.Y
		end

		if not props.hideDivider then
			v14 += 1
		end

		v13(v14)

		if props.onHeightChanged then
			props.onHeightChanged(v14)
		end
	end, {})

	local v14 = props.expandedView and props.isSelected == true

	return React.createElement("Frame", {
		Size = v12:map(module.mapHeightToSize),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ref = props.frameRef,
		NextSelectionLeft = props.NextSelectionLeft,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		}),
		Interactable = React.createElement(focusable[interactable], {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, itemHeight),
			BackgroundColor3 = cellStyle.Color,
			BackgroundTransparency = cellStyle.Transparency,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			[React.Event.Activated] = not props.isDisabled and v8,
			ref = props.defaultChildRef,
			NextSelectionDown = if v14 then ref else nil,
			SelectionImageObject = props.SelectionImageObject,
			isDisabled = props.isDisabled,
			onStateChanged = v7
		}, {
			Contents = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, itemHeight),
					LayoutOrder = 1
				},
				{
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 24),
						PaddingTop = UDim.new(0, 12),
						PaddingBottom = UDim.new(0, 12),
						PaddingRight = UDim.new(0, 12)
					}),
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					CustomViewFrame = props.customView and React.createElement(
						"Frame",
						{
							Size = UDim2.new(1, -48, 1, 0),
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							LayoutOrder = 1
						},
						{ CustomView = props.customView }
					),
					CustomViewSpacer = props.customView and React.createElement("Frame", {
						Size = UDim2.new(0, 24, 1, 0),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						LayoutOrder = 2
					}),
					TitleText = props.text and not props.customView and React.createElement(styledTextLabel, {
						size = UDim2.new(1, -24, 1, 0),
						colorStyle = v11,
						fontStyle = font.Header2,
						text = props.text,
						layoutOrder = 1,
						textXAlignment = Enum.TextXAlignment.Left
					}),
					RightContent = React.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							Size = UDim2.new(0, 24, 1, 0),
							LayoutOrder = 3
						},
						{
							SelectionImage = React.createElement(imageSetLabel, {
								BackgroundTransparency = 1,
								Image = component_assetscircle_24_stroke_1,
								Size = UDim2.new(0, 24, 0, 24),
								ImageColor3 = iconStyle.Color,
								ImageTransparency = iconStyle.Transparency,
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.new(0.5, 0, 0.5, 0)
							}, {
								SelectedImage = props.isSelected and React.createElement(imageSetLabel, {
									BackgroundTransparency = 1,
									Image = component_assetscircle_16,
									Size = UDim2.new(0, 16, 0, 16),
									ImageColor3 = iconStyle.Color,
									ImageTransparency = iconStyle.Transparency,
									AnchorPoint = Vector2.new(0.5, 0.5),
									Position = UDim2.new(0.5, 0, 0.5, 0)
								})
							})
						}
					)
				}
			)
		}),
		ExpandingFrame = props.expandedView and React.createElement(focusable[expandingFrame], {
			LayoutOrder = 2,
			Size = UDim2.new(1, -24, 0, props.expandedViewHeight or 0),
			isExpanded = props.isSelected == true,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			ref = ref,
			NextSelectionUp = props.defaultChildRef
		}, { ExpandedView = props.expandedView }),
		DividerFrame = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 1)
			},
			{
				Divider = not props.hideDivider and React.createElement("Frame", {
					Size = UDim2.new(1, -24, 0, 1),
					Position = UDim2.new(1, -12, 0, 0),
					AnchorPoint = Vector2.new(1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = theme.Divider.Color,
					BackgroundTransparency = theme.Divider.Transparency
				})
			}
		)
	})
end

return React.forwardRef(function(p2, p3)
	return React.createElement(RadioButtonItem, Cryo.Dictionary.join(p2, {
		frameRef = p3
	}))
end)
