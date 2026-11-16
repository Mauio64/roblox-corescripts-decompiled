local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local FFlagShareSheetScrollArrows = require(ShareSheet.Flags.FFlagShareSheetScrollArrows)
local ShareSheetRowWithScrollArrows = require(script.Parent.ShareSheetRowWithScrollArrows)

local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local useTokens = Foundation.Hooks.useTokens

local function ShareSheetRow(p)
	if FFlagShareSheetScrollArrows then
		return React.createElement(ShareSheetRowWithScrollArrows, p)
	end

	local v = useTokens()

	return React.createElement(ScrollView, {
		tag = "size-full-0 auto-y",
		LayoutOrder = p.LayoutOrder,
		padding = { left = UDim.new(0, v.Padding.XLarge), right = UDim.new(0, v.Padding.XLarge) },
		scroll = {
			AutomaticSize = Enum.AutomaticSize.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			CanvasSize = UDim2.fromScale(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.X,
			scrollBarVisibility = Visibility.None
		},
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, v.Padding.Medium)
		}
	}, p.children)
end

return ShareSheetRow
