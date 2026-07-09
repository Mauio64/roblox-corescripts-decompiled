local SocialTab = script:FindFirstAncestor("SocialTab")
local SocialTabParent = SocialTab.Parent
local dependencies = require(SocialTab.dependencies)
local User = require(SocialTab.User)
local SocialLibraries = dependencies.SocialLibraries
local llama = dependencies.llama
local getDeepValue = SocialLibraries.Dictionary.getDeepValue
local GetFFlagFixUserInfoWidgetPlusBadge = require(SocialTabParent.SharedFlags).GetFFlagFixUserInfoWidgetPlusBadge

return function(p1, p2) -- line: 12
	-- upvalues: getDeepValue (copy), User (copy), GetFFlagFixUserInfoWidgetPlusBadge (copy), llama (copy)
	local v11 = getDeepValue(p1, "SocialTab.ShowContactImporterParams") or {}
	local v12 = User.mapToUsers(p1, p2)(p1.LocalUserId)

	if GetFFlagFixUserInfoWidgetPlusBadge() then
		local v13 = if not p1.Users then nil else p1.Users[p1.LocalUserId]

		if v12 and v13 then
			v12 = llama.Dictionary.join(v12, {
				isRobloxSubscriber = v13.hasRobloxSubscription == true
			})
		end
	end

	return {
		unreadConversationCount = p1.SocialTab.UnreadConversationCount or 0,
		numberOfNotifications = p1.NotificationBadgeCounts.TopBarNotificationIcon,
		localUser = v12,
		localUserId = p1.LocalUserId or nil,
		isPhoneVerified = v11.isPhoneVerified,
		isDiscoverabilityUnset = v11.isDiscoverabilityUnset
	}
end
