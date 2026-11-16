local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SquadExternalContractProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/SquadExternalContractProvider")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useGetConversationFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationFromId")

local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Hooks").useCurrentSquadParentChannelId

local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local images = UIBlox.App.ImageSet.Images

local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/EventNames")
local squadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext

local squadInvitePageNavSourceEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/Enums").SquadInvitePageNavSourceEnum

return function(p2)
	local v5 = React.useContext(squadExternalContractContext)
	local v6 = useCurrentSquadParentChannelId() or ""

	local v7 = useGetConversationFromId(v6)
	local participants = v7 and v7.participants or {}

	local v8 = useLocalization({
		tooManyPeopleText = {
			"Feature.Chat.Message.AddFriendsPartyLimit",
			friendNum = Constants.MAX_PARTICIPANT_COUNT,
			connectionsNum = Constants.MAX_PARTICIPANT_COUNT
		}
	})

	local v9 = React.useCallback(function()
		if #participants > Constants.MAX_PARTICIPANT_COUNT then
			p2.navigation.navigate(EnumScreens.RoactChatToast, {
				toastProps = {
					toastContent = { toastTitle = v8.tooManyPeopleText }
				}
			})
			return
		end

		v5.fireSquadAnalytics(EventNames.SquadInvitePageNavSource, {
			inviteNavSource = squadInvitePageNavSourceEnum.SquadLobbyAddFriendsIconButtonClicked,
			parentChannelId = v6
		})

		p2.navigation.navigate(EnumScreens.SquadInviteFriends, { conversationId = v6 })
	end, { v6, p2.navigation, participants })

	return React.createElement(iconButton, {
		size = UDim2.fromOffset(0, 0),
		icon = images["icons/actions/friends/friendAdd"],
		iconSize = iconSize.Medium,
		layoutOrder = 0,
		onActivated = v9
	})
end
