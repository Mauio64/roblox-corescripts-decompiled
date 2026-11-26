local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Localization").Hooks.useLocalization

local enums = Foundation.Enums
local view = Foundation.View
local button = Foundation.Button
local inputSize = enums.InputSize

local function UserListFooter(props)
	local v5 = useLocalization({ showMore = "Feature.Friends.Action.ViewMore" })

	local createElement = React.createElement
	local v7 = {
		tag = "size-full-0 auto-y padding-top-medium padding-bottom-medium",
		LayoutOrder = props.layoutOrder
	}

	local v9 = if props.hasMore and props.onLoadMore then React.createElement(button, {
		size = inputSize.Small,
		onActivated = props.onLoadMore,
		text = v5.showMore,
		fillBehavior = enums.FillBehavior.Fill
	}) else nil
	return createElement(view, v7, { ShowMoreButton = v9 })
end

return UserListFooter
