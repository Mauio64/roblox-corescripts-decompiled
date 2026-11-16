local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local FlyoutNavigationItem = require(script.Parent.FlyoutNavigationItem)

local function FlyoutNavigationList(props)
	local v = useTokens()
	local v2 = React.useMemo(function()
		local children = {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v.Gap.Small)
			})
		}

		for i, navigationItem in ipairs(props.navigationItems) do
			if navigationItem and navigationItem.textKey then
				children[navigationItem.itemType] = React.createElement(FlyoutNavigationItem, {
					item = navigationItem,
					layoutOrder = i,
					closeDrawer = props.closeDrawer,
					buildCreatorWebNavUrl = props.buildCreatorWebNavUrl
				})
			end
		end

		return children
	end, { props.navigationItems, props.buildCreatorWebNavUrl, props.closeDrawer, v.Gap.Small })

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder
		},
		v2
	)
end

return FlyoutNavigationList
