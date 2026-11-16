local AppChat = script:FindFirstAncestor("AppChat")

local EnumScreens = require(AppChat.EnumScreens)
local parent = AppChat.Parent

local Constants = require(AppChat.Constants)
local React = require(parent.React)
local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)

local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId

local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images

local EventNames = require(parent.SquadsCore.EventNames)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext

local Enums = require(parent.Squads.Enums)
local SquadInvitePageNavSourceEnum = Enums.SquadInvitePageNavSourceEnum

return function(p)
	local v = React.useContext(SquadExternalContractContext)
	local v2 = useCurrentSquadParentChannelId() or ""

	local v3 = useGetConversationFromId(v2)
	local participants = v3 and v3.participants or {}

	local v4 = useLocalization({
		tooManyPeopleText = {
			"Feature.Chat.Message.AddFriendsPartyLimit",
			friendNum = Constants.MAX_PARTICIPANT_COUNT,
			connectionsNum = Constants.MAX_PARTICIPANT_COUNT
		}
	})

	local onActivated = React.useCallback(function()
		if #participants > Constants.MAX_PARTICIPANT_COUNT then
			p.navigation.navigate(EnumScreens.RoactChatToast, {
				toastProps = {
					toastContent = { toastTitle = v4.tooManyPeopleText }
				}
			})
			return
		end

		v.fireSquadAnalytics(EventNames.SquadInvitePageNavSource, {
			inviteNavSource = SquadInvitePageNavSourceEnum.SquadLobbyAddFriendsIconButtonClicked,
			parentChannelId = v2
		})

		p.navigation.navigate(EnumScreens.SquadInviteFriends, { conversationId = v2 })
	end, { v2, p.navigation, participants })

	return React.createElement(IconButton, {
		size = UDim2.fromOffset(0, 0),
		icon = Images["icons/actions/friends/friendAdd"],
		iconSize = IconSize.Medium,
		layoutOrder = 0,
		onActivated = onActivated
	})
end
