local parent = script:FindFirstAncestor("UserList").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Enums = Foundation.Enums
local View = Foundation.View
local Button = Foundation.Button
local InputSize = Enums.InputSize

local function UserListFooter(props)
	local v = useLocalization({ showMore = "Feature.Friends.Action.ViewMore" })

	local createElement = React.createElement
	local v2 = {
		tag = "size-full-0 auto-y padding-top-medium padding-bottom-medium",
		LayoutOrder = props.layoutOrder
	}
	local showMoreButton

	if props.hasMore and props.onLoadMore then
		showMoreButton = React.createElement(Button, {
			size = InputSize.Small,
			onActivated = props.onLoadMore,
			text = v.showMore,
			fillBehavior = Enums.FillBehavior.Fill
		})
	end

	return createElement(View, v2, { ShowMoreButton = showMoreButton })
end

return UserListFooter
