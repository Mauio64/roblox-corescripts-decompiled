local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/BuilderIcons")

local GetSelectedUsersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetSelectedUsersStore")

local function FriendCountLabel()
	local v5 = GetSelectedUsersStore(false)
	local v6 = SignalsReact.useSignalBinding(v5.getSelectedUserIdsCount())
	local v7 = SignalsReact.useSignalBinding(v5.getMaxSize())

	local v8 = Foundation.Hooks.useTokens()
	return React.createElement(
		Foundation.View,
		{ tag = "col auto-xy padding-y-small gap-small align-x-center" },
		{
			React.createElement(Foundation.Icon, {
				style = v8.Color.Content.Emphasis,
				name = BuilderIcons.Migration.uiblox["icons/actions/friend_sort/add_friends"].name,
				variant = Foundation.Enums.IconVariant.Filled,
				size = Foundation.Enums.IconSize.Large,
				LayoutOrder = 1
			}),
			Label = React.createElement(Foundation.Text, {
				tag = "auto-xy text-truncate-end text-caption-large content-emphasis",
				Text = React.joinBindings({ v6, v7 }):map(function(list)
					return `{list[1]}/{list[2]}`
				end),
				LayoutOrder = 2
			})
		}
	)
end

return React.memo(FriendCountLabel)
