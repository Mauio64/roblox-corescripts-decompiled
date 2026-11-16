local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")

local FFlagShareSheetScrollArrows = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetScrollArrows")
local ShareSheetRowWithScrollArrows = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetRowWithScrollArrows")

local scrollView = Foundation.ScrollView
local visibility = Foundation.Enums.Visibility
local useTokens = Foundation.Hooks.useTokens

local function ShareSheetRow(p2)
	if FFlagShareSheetScrollArrows then
		return React.createElement(ShareSheetRowWithScrollArrows, p2)
	end

	local v5 = useTokens()

	return React.createElement(scrollView, {
		tag = "size-full-0 auto-y",
		LayoutOrder = p2.LayoutOrder,
		padding = {
			left = UDim.new(0, v5.Padding.XLarge),
			right = UDim.new(0, v5.Padding.XLarge)
		},
		scroll = {
			AutomaticSize = Enum.AutomaticSize.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			CanvasSize = UDim2.fromScale(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.X,
			scrollBarVisibility = visibility.None
		},
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, v5.Padding.Medium)
		}
	}, p2.children)
end

return ShareSheetRow
