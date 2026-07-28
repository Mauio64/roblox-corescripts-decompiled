local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local getUserDisplayName = require(AppChat.SocialLibraries).User.getUserDisplayName
local getThumbnailsForUserIds = require(script.Parent.getThumbnailsForUserIds)
local RoduxPresence = require(AppChat.Http.RoduxPresence)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local userPresenceUtils = require(script.Parent.userPresenceUtils)

return function(p1, p2, t1: {[any]: any}?) -- line: 16
	-- upvalues: FFlagAppChatPresenceStoreMigration (copy), RoduxPresence (copy), userPresenceUtils (copy), Cryo (copy), getUserDisplayName (copy), getThumbnailsForUserIds (copy)
	local v12 = nil

	if not FFlagAppChatPresenceStoreMigration then
		local v13 = RoduxPresence.Selectors.getUserPresenceByUserId(p1, p2.id)

		v12 = userPresenceUtils.getUserDisplayPresence(v13, p2.id == p1.LocalUserId)
	end

	return Cryo.Dictionary.join(p2, {
		isLocalUser = p1.LocalUserId == p2.id,
		displayName = if not t1 then getUserDisplayName(p1, p2) else t1.names.combinedName,
		presenceText = if not FFlagAppChatPresenceStoreMigration then v12.text else nil,
		presenceImage = if not FFlagAppChatPresenceStoreMigration then v12.image else nil,
		thumbnail = getThumbnailsForUserIds({ p2.id })[1]
	})
end
