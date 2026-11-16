local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SignalsReact = require(parent.SignalsReact)
local BuilderIcons = require(parent.BuilderIcons)

local GetSelectedUsersStore = require(AppChat.Stores.GetSelectedUsersStore)

local function FriendCountLabel()
	local selectedUsersStore = GetSelectedUsersStore(false)
	local v = SignalsReact.useSignalBinding(selectedUsersStore.getSelectedUserIdsCount())
	local v2 = SignalsReact.useSignalBinding(selectedUsersStore.getMaxSize())

	local v3 = Foundation.Hooks.useTokens()
	return React.createElement(Foundation.View, {
		tag = "col auto-xy padding-y-small gap-small align-x-center"
	}, {
		React.createElement(Foundation.Icon, {
			style = v3.Color.Content.Emphasis,
			name = BuilderIcons.Migration.uiblox["icons/actions/friend_sort/add_friends"].name,
			variant = Foundation.Enums.IconVariant.Filled,
			size = Foundation.Enums.IconSize.Large,
			LayoutOrder = 1
		}),
		Label = React.createElement(Foundation.Text, {
			tag = "auto-xy text-truncate-end text-caption-large content-emphasis",
			Text = React.joinBindings({ v, v2 }):map(function(list)
				return `{list[1]}/{list[2]}`
			end),
			LayoutOrder = 2
		})
	})
end

return React.memo(FriendCountLabel)
