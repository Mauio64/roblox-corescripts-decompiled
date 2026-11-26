local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local getUserDisplayName = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").User.getUserDisplayName

local getThumbnailsForUserIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Users/getThumbnailsForUserIds")
local RoduxPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxPresence")
local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")

local userPresenceUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Users/userPresenceUtils")

return function(p2, p3, p4)
	local v5

	if not FFlagAppChatPresenceStoreMigration then
		local userPresenceByUserId = RoduxPresence.Selectors.getUserPresenceByUserId(p2, p3.id)
		v5 = userPresenceUtils.getUserDisplayPresence(userPresenceByUserId, p3.id == p2.LocalUserId)
	end

	local join = Cryo.Dictionary.join
	local v6 = {
		isLocalUser = p2.LocalUserId == p3.id,
		displayName = 0,
		presenceText = 0,
		presenceImage = 0,
		thumbnail = 0
	}
	local v7 = if p4 then p4.names.combinedName else getUserDisplayName(p2, p3)
	v6.displayName = v7
	local v8 = if not FFlagAppChatPresenceStoreMigration then v5.text else nil
	v6.presenceText = v8
	local v9 = if not FFlagAppChatPresenceStoreMigration then v5.image else nil
	v6.presenceImage = v9
	v6.thumbnail = getThumbnailsForUserIds({ p3.id })[1]
	return join(p3, v6)
end
