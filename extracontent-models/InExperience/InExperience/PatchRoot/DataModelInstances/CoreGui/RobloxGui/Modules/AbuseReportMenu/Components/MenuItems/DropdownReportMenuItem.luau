local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local DropdownMenu = UIBlox.App.Menu.DropdownMenu
local ReportMenuItem = require(AbuseReportMenu.Components.MenuItems.ReportMenuItem)
local useStyle = UIBlox.Core.Style.useStyle
local getMenuItemSizings = require(AbuseReportMenu.Utility.getMenuItemSizings)
local FFlagHideShortcutsOnReportDropdown = require(AbuseReportMenu.Flags.FFlagHideShortcutsOnReportDropdown)
local Cryo = require(CorePackages.Packages.Cryo)

local function DropdownReportMenuItem(p1) -- line: 29
	-- upvalues: useStyle (copy), getMenuItemSizings (copy), React (copy), AppFonts (copy), DropdownMenu (copy), Cryo (copy), FFlagHideShortcutsOnReportDropdown (copy), ReportMenuItem (copy)
	local Theme = useStyle().Theme
	local v15 = getMenuItemSizings()
	local v16 = if p1.readonlyValue == nil then React.createElement(DropdownMenu, {
		errorState = false,
		showDropShadow = true,
		fixedListHeight = 180,
		placeholder = p1.placeholderText,
		onChange = p1.onSelect,
		height = UDim.new(0, 48),
		screenSize = Vector2.new(2400, 1800),
		cellDatas = Cryo.List.map(p1.selections, function(p2) -- line: 58
			return {
				text = p2
			}
		end),
		onMenuOpenChange = if not FFlagHideShortcutsOnReportDropdown then nil else p1.onMenuOpenChange
	}) else React.createElement("TextLabel", {
		TextWrapped = true,
		BackgroundTransparency = 1,
		Text = p1.readonlyValue,
		Font = AppFonts.default:getMedium(),
		TextColor3 = Theme.TextEmphasis.Color,
		TextTransparency = Theme.TextMuted.Transparency,
		TextSize = v15.DropdownTextSize,
		TextXAlignment = if not p1.isSmallPortraitViewport then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, p1.minHeight)
	})

	return React.createElement(ReportMenuItem, {
		label = p1.label,
		layoutOrder = p1.layoutOrder,
		rightComponent = v16,
		menuContainerWidth = p1.menuContainerWidth,
		isSmallPortraitViewport = p1.isSmallPortraitViewport
	})
end

return DropdownReportMenuItem
