local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation").Hooks.useTokens

local FlyoutNavigationItem = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/FlyoutNavigationItem")

local function FlyoutNavigationList(props)
	local v5 = useTokens()
	local v6 = React.useMemo(function()
		local children = {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v5.Gap.Small)
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
	end, {
		props.navigationItems,
		props.buildCreatorWebNavUrl,
		props.closeDrawer,
		v5.Gap.Small
	})

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder
		},
		v6
	)
end

return FlyoutNavigationList
