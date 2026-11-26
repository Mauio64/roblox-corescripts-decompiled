local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")

local FFlagShareSheetDesktopReadiness = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetDesktopReadiness")
local FFlagShareSheetScrollArrows = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetScrollArrows")
local ShareSheetRowWithScrollArrows = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetRowWithScrollArrows")

local scrollView = Foundation.ScrollView
local visibility = Foundation.Enums.Visibility
local useTokens = Foundation.Hooks.useTokens

local function ShareSheetRow(props)
	if FFlagShareSheetScrollArrows and not FFlagShareSheetDesktopReadiness then
		return React.createElement(ShareSheetRowWithScrollArrows, props)
	end

	local v5 = useTokens()
	local v6 = if FFlagShareSheetDesktopReadiness then props.margin else v5.Padding.XLarge

	local createElement = React.createElement
	local v8 = {
		tag = "size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		padding = { left = UDim.new(0, v6), right = UDim.new(0, v6) },
		scroll = 0,
		layout = 0
	}

	local v9 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollingDirection = Enum.ScrollingDirection.X,
		ScrollingEnabled = 0,
		scrollBarVisibility = 0
	}
	local v10 = if FFlagShareSheetDesktopReadiness then props.isScrollingEnabled else nil
	v9.ScrollingEnabled = v10
	v9.scrollBarVisibility = visibility.None
	v8.scroll = v9

	local v11 = {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = 0
	}
	local newUDim = UDim.new
	local v13 = if FFlagShareSheetDesktopReadiness then props.gap else v5.Padding.Medium
	v11.Padding = newUDim(0, v13)
	v8.layout = v11
	return createElement(scrollView, v8, props.children)
end

return ShareSheetRow
