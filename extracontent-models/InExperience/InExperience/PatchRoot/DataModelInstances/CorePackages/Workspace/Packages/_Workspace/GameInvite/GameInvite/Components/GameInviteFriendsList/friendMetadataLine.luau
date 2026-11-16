local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent

local DataHydration = require(parent.DataHydration)
require(parent.UserList)
local UserLib = require(parent.UserLib)
local UserModel = UserLib.Models.UserModel

local escapeRichText = require(GameInvite.utils.escapeRichText)

local PresenceType = DataHydration.Presence.PresenceEnums.PresenceType
local FriendMetadataLine = {}

function FriendMetadataLine.getContextText(p, p2)
	local lastLocation = p.lastLocation

	if p.presence == UserModel.PresenceType.IN_STUDIO then
		return p2.inStudio
	end

	if p.presence == UserModel.PresenceType.IN_GAME and lastLocation ~= nil and lastLocation ~= "" then
		return escapeRichText(lastLocation)
	end

	return nil
end

function FriendMetadataLine.getContextTextForPresence(p, p2: string?, p3)
	if p == PresenceType.InStudio then
		return p3.inStudio
	end

	if p == PresenceType.InGame and p2 ~= nil and p2 ~= "" then
		return escapeRichText(p2)
	end

	return if p == PresenceType.Online then p3.online else nil
end

function FriendMetadataLine.getLivePresenceType(p)
	if p.userPresenceType == PresenceType.InGame and p.universeId == "" then
		return PresenceType.Online
	end

	return p.userPresenceType
end

return FriendMetadataLine
