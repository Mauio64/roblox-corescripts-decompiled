local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local getUserDisplayName = require(AppChat.SocialLibraries).User.getUserDisplayName
local getThumbnailsForUserIds = require(script.Parent.getThumbnailsForUserIds)
local RoduxPresence = require(AppChat.Http.RoduxPresence)
local userPresenceUtils = require(script.Parent.userPresenceUtils)

return function(p1, p2, t1: {[any]: any}?) -- line: 15
	-- upvalues: RoduxPresence (copy), userPresenceUtils (copy), Cryo (copy), getUserDisplayName (copy), getThumbnailsForUserIds (copy)
	local v11 = RoduxPresence.Selectors.getUserPresenceByUserId(p1, p2.id)
	local v12 = userPresenceUtils.getUserDisplayPresence(v11, p2.id == p1.LocalUserId)

	return Cryo.Dictionary.join(p2, {
		isLocalUser = p1.LocalUserId == p2.id,
		displayName = if not t1 then getUserDisplayName(p1, p2) else t1.names.combinedName,
		presenceText = v12.text,
		presenceImage = v12.image,
		thumbnail = getThumbnailsForUserIds({ p2.id })[1]
	})
end
