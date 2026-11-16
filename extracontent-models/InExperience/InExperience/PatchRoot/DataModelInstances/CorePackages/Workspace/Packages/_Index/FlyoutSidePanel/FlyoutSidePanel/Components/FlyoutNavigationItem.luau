local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
require(script.Parent.Parent.Config.FlyoutContentSettings)
local PrimaryNavigationItem = require(script.Parent.PrimaryNavigationItem)

local useFlyoutItemNavigation = require(script.Parent.Parent.Hooks.useFlyoutItemNavigation)

local function FlyoutNavigationItem(props)
	local onActivated = useFlyoutItemNavigation(props.item, props.closeDrawer, props.buildCreatorWebNavUrl)

	local v = useLocalization({ text = props.item.textKey })

	return React.createElement(PrimaryNavigationItem, {
		layoutOrder = props.layoutOrder,
		onActivated = onActivated,
		icon = props.item.icon,
		text = v.text,
		notificationCount = props.item.notificationCount,
		testId = props.item.itemType
	})
end

return FlyoutNavigationItem
