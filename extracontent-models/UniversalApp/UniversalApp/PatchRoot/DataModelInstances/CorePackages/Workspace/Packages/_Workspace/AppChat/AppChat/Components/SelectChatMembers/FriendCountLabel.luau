local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local SignalsReact = require(AppChatParent.SignalsReact)
local BuilderIcons = require(AppChatParent.BuilderIcons)
local GetSelectedUsersStore = require(AppChat.Stores.GetSelectedUsersStore)

local function FriendCountLabel() -- line: 13
	-- upvalues: GetSelectedUsersStore (copy), SignalsReact (copy), Foundation (copy), React (copy), BuilderIcons (copy)
	local v9 = GetSelectedUsersStore(false)
	local v10 = SignalsReact.useSignalBinding(v9.getSelectedUserIdsCount())
	local v11 = SignalsReact.useSignalBinding(v9.getMaxSize())
	local v12 = Foundation.Hooks.useTokens()

	return React.createElement(Foundation.View, {
		tag = "col auto-xy padding-y-small gap-small align-x-center"
	}, {
		React.createElement(Foundation.Icon, {
			LayoutOrder = 1,
			style = v12.Color.Content.Emphasis,
			name = BuilderIcons.Migration.uiblox["icons/actions/friend_sort/add_friends"].name,
			variant = Foundation.Enums.IconVariant.Filled,
			size = Foundation.Enums.IconSize.Large
		}),
		Label = React.createElement(Foundation.Text, {
			tag = "auto-xy text-truncate-end text-caption-large content-emphasis",
			LayoutOrder = 2,
			Text = React.joinBindings({
				v10,
				v11
			}):map(function(p1) -- line: 32
				return `{ p1[1] }/{ p1[2] }`
			end)
		})
	})
end

return React.memo(FriendCountLabel)
