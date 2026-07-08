local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local useStyle = UIBlox.Core.Style.useStyle
local Constants = require(AbuseReportMenu.Components.Constants)
local getMenuItemDimensions = require(AbuseReportMenu.Components.getMenuItemDimensions)

local function DropdownReportMenuItem(p1) -- line: 23
	-- upvalues: useStyle (copy), getMenuItemDimensions (copy), Constants (copy), React (copy), TextService (copy), AppFonts (copy), Cryo (copy)
	local v13 = useStyle()
	local v14 = if p1.label ~= "" and not p1.isRightComponentFullWidth then v13.Tokens.Size.Size_150 else 0
	local Theme = v13.Theme
	local v16 = getMenuItemDimensions(p1.menuContainerWidth)
	local v17 = math.max(p1.menuContainerWidth - Constants.MenuItemDynamicWidthOffset, v16.LeftWidth + v16.RightWidth)
	local v18, v19 = React.useState(v13.Tokens.Size.Size_1000)

	React.useEffect(function() -- line: 37
		-- upvalues: v19 (copy), v13 (copy), TextService (copy), p1 (copy), v16 (copy), AppFonts (copy), v17 (copy)
		v19((math.max(v13.Tokens.Size.Size_1000, TextService:GetTextSize(p1.label, v16.TextSize, AppFonts.default:getMedium(), Vector2.new((if not p1.isSmallPortraitViewport then v16.LeftWidth else v17), 1e999)).Y)))
	end, {})

	local t1 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = if not p1.isSmallPortraitViewport then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = if not p1.isSmallPortraitViewport then UDim.new(0, 0) else UDim.new(0, v14)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v14),
			PaddingBottom = UDim.new(0, v14)
		})
	}
	local v22

	if p1.isRightComponentFullWidth then
		local v21 = math.max(p1.menuContainerWidth - Constants.MenuItemDynamicWidthOffset, v16.LeftWidth + v16.RightWidth)

		v22 = Cryo.Dictionary.join(t1, {
			RightComponentWrapper = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(0, v21, 0, Constants.MenuItemHeight),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				RightComponent = p1.rightComponent
			})
		})
	else
		local v23 = math.max(0, p1.menuContainerWidth - v16.LeftWidth - v16.RightWidth - Constants.MenuItemDynamicWidthOffset)

		v22 = Cryo.Dictionary.join(t1, {
			Label = if p1.label == "" and p1.isSmallPortraitViewport then nil else React.createElement("TextLabel", {
				LayoutOrder = 1,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Text = p1.label,
				Font = AppFonts.default:getMedium(),
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextSize = v16.TextSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = if not p1.isSmallPortraitViewport then UDim2.new(0, v16.LeftWidth, 0, v18) else UDim2.new(0, v17, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}),
			MiddleSpaceHolder = if not p1.isSmallPortraitViewport then React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(0, v23, 0, Constants.MenuItemHeight)
			}) else nil,
			RightComponentWrapper = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = if not p1.isSmallPortraitViewport then UDim2.new(0, v16.RightWidth, 0, Constants.MenuItemHeight) else UDim2.new(0, v17, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = if not p1.isSmallPortraitViewport then nil else Enum.HorizontalAlignment.Left
				}),
				RightComponent = p1.rightComponent
			})
		})
	end

	if p1.heightOverride then
		v18 = p1.heightOverride
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v18),
		AutomaticSize = if not p1.isRightComponentFullWidth and not p1.isSmallPortraitViewport then nil else Enum.AutomaticSize.Y,
		LayoutOrder = p1.layoutOrder
	}, v22)
end

return DropdownReportMenuItem
