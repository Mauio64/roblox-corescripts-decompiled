local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent

local React = require(parent.React)
require(parent.UserList)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local FriendsCommon = require(parent.FriendsCommon)
local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
local UserLib = require(parent.UserLib)
local UserModel = UserLib.Models.UserModel

local GameInviteInviteButton = require(script.Parent.GameInviteInviteButton)
local friendMetadataLine = require(script.Parent.friendMetadataLine)
local FFlagGameInviteInExpLivePresence = require(GameInvite.Flags.FFlagGameInviteInExpLivePresence)

local v = { skipFetch = true }

local v2 = {
	[UserModel.PresenceType.ONLINE] = "Online",
	[UserModel.PresenceType.IN_GAME] = "InGame",
	[UserModel.PresenceType.IN_STUDIO] = "InStudio",
	[UserModel.PresenceType.OFFLINE] = "Offline"
}

local function GameInviteFriendRow(data)
	local friend = data.friend
	local id = friend.id
	local rowNumber = data.rowNumber
	local v3 = useLocalization({
		inStudio = "Common.Presence.Label.RobloxStudio",
		online = FFlagGameInviteInExpLivePresence and "Common.Presence.Label.Online" or nil
	})

	local text = friendMetadataLine.getContextText(friend, v3)
	local presence

	if FFlagGameInviteInExpLivePresence then
		presence = v2[friend.presence]
		local lastLocation = friend.lastLocation
		local v4 = useGetPresenceByUserId(id, v)

		if v4 ~= nil then
			presence = friendMetadataLine.getLivePresenceType(v4)
			lastLocation = v4.lastLocation
		end

		text = friendMetadataLine.getContextTextForPresence(presence, lastLocation, v3)
	end

	local contextualInfo = React.useMemo(function()
		if text == nil then
			return nil
		end

		return { text = text }
	end, { text })
	local trailingContent = React.useMemo(function()
		return React.createElement(GameInviteInviteButton, { userId = id, rowNumber = rowNumber })
	end, { id, rowNumber })

	local createRow = data.createRow

	if not FFlagGameInviteInExpLivePresence then
		presence = v2[friend.presence]
	end

	return createRow({
		contextualInfo = contextualInfo,
		presence = presence,
		trailingContent = trailingContent
	})
end

return GameInviteFriendRow
