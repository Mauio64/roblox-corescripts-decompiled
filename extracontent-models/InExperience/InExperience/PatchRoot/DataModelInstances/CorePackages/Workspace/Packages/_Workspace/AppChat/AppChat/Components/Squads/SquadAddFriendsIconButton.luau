local AppChat = script:FindFirstAncestor("AppChat")
local EnumScreens = require(AppChat.EnumScreens)
local AppChatParent = AppChat.Parent
local Constants = require(AppChat.Constants)
local React = require(AppChatParent.React)
local SquadExternalContractProvider = require(AppChatParent.SquadsCore.SquadExternalContractProvider)
local UIBlox = require(AppChatParent.UIBlox)
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local useCurrentSquadParentChannelId = require(AppChatParent.SquadsCore.Hooks).useCurrentSquadParentChannelId
local FFlagConnectionsToFriendsRename = require(AppChatParent.SharedFlags).FFlagConnectionsToFriendsRename
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local EventNames = require(AppChatParent.SquadsCore.EventNames)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local SquadInvitePageNavSourceEnum = require(AppChatParent.Squads.Enums).SquadInvitePageNavSourceEnum

return function(t1: {[any]: any}) -- line: 29
	-- upvalues: React (copy), SquadExternalContractContext (copy), useCurrentSquadParentChannelId (copy), useGetConversationFromId (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), Constants (copy), EnumScreens (copy), EventNames (copy), SquadInvitePageNavSourceEnum (copy), IconButton (copy), Images (copy), IconSize (copy)
	local v19 = React.useContext(SquadExternalContractContext)
	local v20 = useCurrentSquadParentChannelId() or ""
	local v21 = useGetConversationFromId(v20)
	local v22 = v21 and v21.participants or {}
	local v23 = useLocalization({
		tooManyPeopleText = {
			not FFlagConnectionsToFriendsRename and "Feature.Chat.Message.AddConnectionsPartyLimit" or "Feature.Chat.Message.AddFriendsPartyLimit",
			friendNum = Constants.MAX_PARTICIPANT_COUNT,
			connectionsNum = Constants.MAX_PARTICIPANT_COUNT
		}
	})
	local v24 = React.useCallback(function() -- line: 46
		-- upvalues: v22 (copy), Constants (copy), t1 (copy), EnumScreens (copy), v23 (copy), v19 (copy), EventNames (copy), SquadInvitePageNavSourceEnum (copy), v20 (copy)
		if #v22 > Constants.MAX_PARTICIPANT_COUNT then
			t1.navigation.navigate(EnumScreens.RoactChatToast, {
				toastProps = {
					toastContent = {
						toastTitle = v23.tooManyPeopleText
					}
				}
			})

			return
		end

		v19.fireSquadAnalytics(EventNames.SquadInvitePageNavSource, {
			inviteNavSource = SquadInvitePageNavSourceEnum.SquadLobbyAddFriendsIconButtonClicked,
			parentChannelId = v20
		})
		t1.navigation.navigate(EnumScreens.SquadInviteFriends, {
			conversationId = v20
		})
	end, {
		v20,
		t1.navigation,
		v22
	})

	return React.createElement(IconButton, {
		layoutOrder = 0,
		size = UDim2.fromOffset(0, 0),
		icon = Images["icons/actions/friends/friendAdd"],
		iconSize = IconSize.Medium,
		onActivated = v24
	})
end
