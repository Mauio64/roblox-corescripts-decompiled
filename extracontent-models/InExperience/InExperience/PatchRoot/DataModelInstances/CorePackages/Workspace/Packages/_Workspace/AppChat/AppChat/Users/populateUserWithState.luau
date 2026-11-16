local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local SocialLibraries = require(AppChat.SocialLibraries)

local getUserDisplayName = SocialLibraries.User.getUserDisplayName

local getThumbnailsForUserIds = require(script.Parent.getThumbnailsForUserIds)
local RoduxPresence = require(AppChat.Http.RoduxPresence)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)

local userPresenceUtils = require(script.Parent.userPresenceUtils)

return function(p, p2, p3)
	local v

	if not FFlagAppChatPresenceStoreMigration then
		local userPresenceByUserId = RoduxPresence.Selectors.getUserPresenceByUserId(p, p2.id)
		v = userPresenceUtils.getUserDisplayPresence(userPresenceByUserId, p2.id == p.LocalUserId)
	end

	local join = Cryo.Dictionary.join
	local v2 = {
		isLocalUser = p.LocalUserId == p2.id,
		displayName = 0,
		presenceText = 0,
		presenceImage = 0,
		thumbnail = 0
	}
	local displayName

	if p3 then
		displayName = p3.names.combinedName
	else
		displayName = getUserDisplayName(p, p2)
	end

	v2.displayName = displayName
	local presenceText

	if not FFlagAppChatPresenceStoreMigration then
		presenceText = v.text
	end

	v2.presenceText = presenceText
	local presenceImage

	if not FFlagAppChatPresenceStoreMigration then
		presenceImage = v.image
	end

	v2.presenceImage = presenceImage
	v2.thumbnail = getThumbnailsForUserIds({ p2.id })[1]
	return join(p2, v2)
end
