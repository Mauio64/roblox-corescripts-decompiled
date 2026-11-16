local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local useTokens = Foundation.Hooks.useTokens

local function ItemDetailsChipRow(p2)
	local v5 = useTokens()

	return React.createElement(Foundation.ScrollView, {
		LayoutOrder = p2.LayoutOrder,
		tag = "size-full-0 auto-y",
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v5.Gap.Small),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		scroll = {
			ScrollingDirection = Enum.ScrollingDirection.X,
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			AutomaticSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(),
			scrollBarVisibility = Foundation.Enums.Visibility.None
		}
	}, p2.children)
end

return React.memo(ItemDetailsChipRow)
