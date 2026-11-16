local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UserList")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Localization").Hooks.useLocalization
local useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/FriendsCommon").Hooks.useGetPresenceByUserId
local userModel = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UserLib").Models.UserModel

local GameInviteInviteButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/GameInviteInviteButton")
local friendMetadataLine = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/friendMetadataLine")
local FFlagGameInviteInExpLivePresence = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Flags/FFlagGameInviteInExpLivePresence")

local v5 = { skipFetch = true }

local v6 = {
	[userModel.PresenceType.ONLINE] = "Online",
	[userModel.PresenceType.IN_GAME] = "InGame",
	[userModel.PresenceType.IN_STUDIO] = "InStudio",
	[userModel.PresenceType.OFFLINE] = "Offline"
}

local function GameInviteFriendRow(data)
	local friend = data.friend
	local id = friend.id
	local rowNumber = data.rowNumber
	local v7 = useLocalization({
		inStudio = "Common.Presence.Label.RobloxStudio",
		online = FFlagGameInviteInExpLivePresence and "Common.Presence.Label.Online" or nil
	})

	local v8 = friendMetadataLine.getContextText(friend, v7)
	local v9

	if FFlagGameInviteInExpLivePresence then
		v9 = v6[friend.presence]
		local lastLocation = friend.lastLocation
		local v10 = useGetPresenceByUserId(id, v5)

		if v10 ~= nil then
			v9 = friendMetadataLine.getLivePresenceType(v10)
			lastLocation = v10.lastLocation
		end

		v8 = friendMetadataLine.getContextTextForPresence(v9, lastLocation, v7)
	end

	local v10 = React.useMemo(function()
		if v8 == nil then
			return nil
		end

		return { text = v8 }
	end, { v8 })
	local v11 = React.useMemo(function()
		return React.createElement(GameInviteInviteButton, { userId = id, rowNumber = rowNumber })
	end, { id, rowNumber })

	local createRow = data.createRow

	if not FFlagGameInviteInExpLivePresence then
		v9 = v6[friend.presence]
	end

	return createRow({ contextualInfo = v10, presence = v9, trailingContent = v11 })
end

return GameInviteFriendRow
