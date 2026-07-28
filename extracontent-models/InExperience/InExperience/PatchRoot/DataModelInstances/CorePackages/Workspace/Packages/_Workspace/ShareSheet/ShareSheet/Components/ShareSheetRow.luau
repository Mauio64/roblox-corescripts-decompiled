local Parent = script:FindFirstAncestor("ShareSheet").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local useTokens = Foundation.Hooks.useTokens

local function ShareSheetRow(t1: {[any]: any}) -- line: 16
	-- upvalues: useTokens (copy), React (copy), ScrollView (copy), Visibility (copy)
	local v9 = useTokens()

	return React.createElement(ScrollView, {
		tag = "size-full-0 auto-y",
		LayoutOrder = t1.LayoutOrder,
		padding = {
			left = UDim.new(0, v9.Padding.XLarge),
			right = UDim.new(0, v9.Padding.XLarge)
		},
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
			Padding = UDim.new(0, v9.Padding.Medium)
		}
	}, t1.children)
end

return ShareSheetRow
