local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local DropdownMenu = UIBlox.App.Menu.DropdownMenu
local ReportMenuItem = require(AbuseReportMenu.Components.MenuItems.ReportMenuItem)
local useStyle = UIBlox.Core.Style.useStyle
local getMenuItemSizings = require(AbuseReportMenu.Utility.getMenuItemSizings)

local FFlagHideShortcutsOnReportDropdown = require(AbuseReportMenu.Flags.FFlagHideShortcutsOnReportDropdown)

local Cryo = require(CorePackages.Packages.Cryo)

local function DropdownReportMenuItem(props)
	local theme = useStyle().Theme
	local menuItemSizings = getMenuItemSizings()
	local rightComponent

	if props.readonlyValue == nil then
		local createElement = React.createElement
		local v = {
			placeholder = props.placeholderText,
			onChange = props.onSelect,
			height = UDim.new(0, 48),
			screenSize = Vector2.new(2400, 1800),
			errorState = false,
			showDropShadow = true,
			fixedListHeight = 180,
			cellDatas = Cryo.List.map(props.selections, function(text)
				return { text = text }
			end),
			onMenuOpenChange = 0
		}
		local onMenuOpenChange

		if FFlagHideShortcutsOnReportDropdown then
			onMenuOpenChange = props.onMenuOpenChange
		end

		v.onMenuOpenChange = onMenuOpenChange
		rightComponent = createElement(DropdownMenu, v)
	else
		local createElement = React.createElement
		local v = {
			Text = props.readonlyValue,
			Font = AppFonts.default:getMedium(),
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextMuted.Transparency,
			TextSize = menuItemSizings.DropdownTextSize,
			TextWrapped = true,
			TextXAlignment = 0,
			AutomaticSize = 0,
			Size = 0,
			BackgroundTransparency = 1
		}
		local textXAlignment

		if props.isSmallPortraitViewport then
			textXAlignment = Enum.TextXAlignment.Left
		else
			textXAlignment = Enum.TextXAlignment.Center
		end

		v.TextXAlignment = textXAlignment

		v.AutomaticSize = Enum.AutomaticSize.Y
		v.Size = UDim2.new(1, 0, 0, props.minHeight)
		rightComponent = createElement("TextLabel", v)
	end

	return React.createElement(ReportMenuItem, {
		label = props.label,
		layoutOrder = props.layoutOrder,
		rightComponent = rightComponent,
		menuContainerWidth = props.menuContainerWidth,
		isSmallPortraitViewport = props.isSmallPortraitViewport
	})
end

return DropdownReportMenuItem
