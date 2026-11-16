local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local UIBlox = require(CorePackages.Packages.UIBlox)

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local useStyle = UIBlox.Core.Style.useStyle
local Constants = require(AbuseReportMenu.Components.Constants)
local getMenuItemDimensions = require(AbuseReportMenu.Components.getMenuItemDimensions)

local function DropdownReportMenuItem(props)
	local v = useStyle()
	local v2 = (props.label == "" or props.isRightComponentFullWidth) and 0 or v.Tokens.Size.Size_150
	local theme = v.Theme

	local menuItemDimensions = getMenuItemDimensions(props.menuContainerWidth)
	local v3 = math.max(
		props.menuContainerWidth - Constants.MenuItemDynamicWidthOffset,
		menuItemDimensions.LeftWidth + menuItemDimensions.RightWidth
	)

	local state, setState = React.useState(v.Tokens.Size.Size_1000)
	React.useEffect(function()
		local size_1000 = v.Tokens.Size.Size_1000

		local label = props.label
		local textSize = menuItemDimensions.TextSize
		local medium = AppFonts.default:getMedium()
		local v4

		if props.isSmallPortraitViewport then
			v4 = v3
		else
			v4 = menuItemDimensions.LeftWidth
		end

		setState((math.max(size_1000, TextService:GetTextSize(label, textSize, medium, Vector2.new(v4, 1e999)).Y)))
	end, {})

	local createElement = React.createElement
	local fillDirection

	if props.isSmallPortraitViewport then
		fillDirection = Enum.FillDirection.Vertical
	else
		fillDirection = Enum.FillDirection.Horizontal
	end

	local v4 = {
		FillDirection = fillDirection,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = 0
	}
	local padding

	if props.isSmallPortraitViewport then
		padding = UDim.new(0, v2)
	else
		padding = UDim.new(0, 0)
	end

	v4.Padding = padding
	local children = {
		Layout = createElement("UIListLayout", v4),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v2),
			PaddingBottom = UDim.new(0, v2)
		})
	}
	local v5

	if props.isRightComponentFullWidth then
		local v6 = math.max(
			props.menuContainerWidth - Constants.MenuItemDynamicWidthOffset,
			menuItemDimensions.LeftWidth + menuItemDimensions.RightWidth
		)

		v5 = Cryo.Dictionary.join(children, {
			RightComponentWrapper = React.createElement(
				"Frame",
				{
					Size = UDim2.new(0, v6, 0, Constants.MenuItemHeight),
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					AutomaticSize = Enum.AutomaticSize.Y
				},
				{
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					RightComponent = props.rightComponent
				}
			)
		})
	else
		local v6 = math.max(
			0,
			props.menuContainerWidth - menuItemDimensions.LeftWidth - menuItemDimensions.RightWidth - Constants.MenuItemDynamicWidthOffset
		)

		local join = Cryo.Dictionary.join
		local label

		if not (props.label == "" and props.isSmallPortraitViewport) then
			local createElement2 = React.createElement
			local v7 = {
				Text = props.label,
				Font = AppFonts.default:getMedium(),
				LayoutOrder = 1,
				TextColor3 = theme.TextEmphasis.Color,
				TextTransparency = theme.TextEmphasis.Transparency,
				TextSize = menuItemDimensions.TextSize,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = 0,
				AutomaticSize = 0,
				BackgroundTransparency = 1
			}
			local size

			if props.isSmallPortraitViewport then
				size = UDim2.new(0, v3, 0, 0)
			else
				size = UDim2.new(0, menuItemDimensions.LeftWidth, 0, state)
			end

			v7.Size = size

			v7.AutomaticSize = Enum.AutomaticSize.Y
			label = createElement2("TextLabel", v7)
		end

		local middleSpaceHolder

		if not props.isSmallPortraitViewport then
			middleSpaceHolder = React.createElement("Frame", {
				Size = UDim2.new(0, v6, 0, Constants.MenuItemHeight),
				BackgroundTransparency = 1,
				LayoutOrder = 2
			})
		end

		local createElement2 = React.createElement
		local size

		if props.isSmallPortraitViewport then
			size = UDim2.new(0, v3, 0, 0)
		else
			size = UDim2.new(0, menuItemDimensions.RightWidth, 0, Constants.MenuItemHeight)
		end

		local v7 = {
			Size = size,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 3
		}

		local createElement3 = React.createElement
		local v8 = {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = 0
		}
		local horizontalAlignment

		if props.isSmallPortraitViewport then
			horizontalAlignment = Enum.HorizontalAlignment.Left
		end

		v8.HorizontalAlignment = horizontalAlignment
		v5 = join(children, {
			Label = label,
			MiddleSpaceHolder = middleSpaceHolder,
			RightComponentWrapper = createElement2("Frame", v7, {
				Layout = createElement3("UIListLayout", v8),
				RightComponent = props.rightComponent
			})
		})
	end

	if props.heightOverride then
		state = props.heightOverride
	end

	local createElement2 = React.createElement
	local v6 = {
		Size = UDim2.new(1, 0, 0, state),
		AutomaticSize = 0,
		BackgroundTransparency = 1,
		LayoutOrder = 0
	}
	local automaticSize

	if props.isRightComponentFullWidth or props.isSmallPortraitViewport then
		automaticSize = Enum.AutomaticSize.Y
	end

	v6.AutomaticSize = automaticSize

	v6.LayoutOrder = props.layoutOrder
	return createElement2("Frame", v6, v5)
end

return DropdownReportMenuItem
