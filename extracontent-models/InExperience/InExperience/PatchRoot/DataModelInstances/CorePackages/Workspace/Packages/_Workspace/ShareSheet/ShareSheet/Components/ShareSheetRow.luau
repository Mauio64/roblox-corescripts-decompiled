local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local FFlagShareSheetDesktopReadiness = require(ShareSheet.Flags.FFlagShareSheetDesktopReadiness)
local FFlagShareSheetScrollArrows = require(ShareSheet.Flags.FFlagShareSheetScrollArrows)
local ShareSheetRowWithScrollArrows = require(script.Parent.ShareSheetRowWithScrollArrows)

local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local useTokens = Foundation.Hooks.useTokens

local function ShareSheetRow(props)
	if FFlagShareSheetScrollArrows and not FFlagShareSheetDesktopReadiness then
		return React.createElement(ShareSheetRowWithScrollArrows, props)
	end

	local v = useTokens()
	local v2

	if FFlagShareSheetDesktopReadiness then
		v2 = props.margin
	else
		v2 = v.Padding.XLarge
	end

	local createElement = React.createElement
	local v3 = {
		tag = "size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		padding = { left = UDim.new(0, v2), right = UDim.new(0, v2) },
		scroll = 0,
		layout = 0
	}

	local scroll = {
		AutomaticSize = Enum.AutomaticSize.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollingDirection = Enum.ScrollingDirection.X,
		ScrollingEnabled = 0,
		scrollBarVisibility = 0
	}
	local scrollingEnabled

	if FFlagShareSheetDesktopReadiness then
		scrollingEnabled = props.isScrollingEnabled
	end

	scroll.ScrollingEnabled = scrollingEnabled
	scroll.scrollBarVisibility = Visibility.None
	v3.scroll = scroll

	local layout = {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = 0
	}
	local v4

	if FFlagShareSheetDesktopReadiness then
		v4 = props.gap
	else
		v4 = v.Padding.Medium
	end

	layout.Padding = UDim.new(0, v4)
	v3.layout = layout
	return createElement(ScrollView, v3, props.children)
end

return ShareSheetRow
