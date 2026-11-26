local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Localization").Hooks.useLocalization
require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Config/FlyoutContentSettings")
local PrimaryNavigationItem = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/PrimaryNavigationItem")

local useFlyoutItemNavigation = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useFlyoutItemNavigation")

local function FlyoutNavigationItem(props)
	local v5 = useFlyoutItemNavigation(props.item, props.closeDrawer, props.buildCreatorWebNavUrl)

	local v6 = useLocalization({ text = props.item.textKey })

	return React.createElement(PrimaryNavigationItem, {
		layoutOrder = props.layoutOrder,
		onActivated = v5,
		icon = props.item.icon,
		text = v6.text,
		notificationCount = props.item.notificationCount,
		testId = props.item.itemType
	})
end

return FlyoutNavigationItem
