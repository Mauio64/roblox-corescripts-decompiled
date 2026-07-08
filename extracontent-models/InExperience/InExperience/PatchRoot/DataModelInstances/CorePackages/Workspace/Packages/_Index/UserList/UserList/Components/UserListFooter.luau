local Parent = script:FindFirstAncestor("UserList").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Enums = Foundation.Enums
local View = Foundation.View
local Button = Foundation.Button
local InputSize = Enums.InputSize

local function UserListFooter(t1: {[any]: any}) -- line: 19
	-- upvalues: useLocalization (copy), React (copy), View (copy), Button (copy), InputSize (copy), Enums (copy)
	local v11 = useLocalization({
		showMore = "Feature.Friends.Action.ShowMore"
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y padding-top-medium padding-bottom-medium",
		LayoutOrder = t1.layoutOrder
	}, {
		ShowMoreButton = if not t1.hasMore or not t1.onLoadMore then nil else React.createElement(Button, {
			size = InputSize.Small,
			onActivated = t1.onLoadMore,
			text = v11.showMore,
			fillBehavior = Enums.FillBehavior.Fill
		})
	})
end

return UserListFooter
