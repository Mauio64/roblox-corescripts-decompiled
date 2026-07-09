local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local SetNotificationCount = require(Modules.LuaApp.Actions.SetNotificationCount)
local SetFriendRequestsCount = require(Modules.LuaApp.Actions.SetFriendRequestsCount)
local SetUnreadMessageCount = require(Modules.LuaApp.Actions.SetUnreadMessageCount)
local SetEmailNotificationCount = require(Modules.LuaApp.Actions.SetEmailNotificationCount)
local SetPasswordNotificationCount = require(Modules.LuaApp.Actions.SetPasswordNotificationCount)
local SetTencentNoticeBadgeCount = require(Modules.Luobu.Actions.SetTencentNoticeBadgeCount)
local DecrementUnreadTencentNoticeCount = require(Modules.Luobu.Actions.DecrementUnreadTencentNoticeCount)

return function(p1, p2) -- line: 16
	-- upvalues: SetNotificationCount (copy), SetFriendRequestsCount (copy), Cryo (copy), SetUnreadMessageCount (copy), SetEmailNotificationCount (copy), SetPasswordNotificationCount (copy), SetTencentNoticeBadgeCount (copy), DecrementUnreadTencentNoticeCount (copy)
	local v13 = p1 or {
		TopBarNotificationIcon = 0,
		MorePageMessages = 0,
		MorePageFriends = 0,
		MorePageEmailSettings = 0,
		MorePagePasswordSettings = 0,
		MorePageSettings = 0,
		MorePageTencentUnreadNotice = 0
	}

	if p2.type == SetNotificationCount.name then
		v13.TopBarNotificationIcon = p2.notificationCount

		return v13
	end

	if p2.type == SetFriendRequestsCount.name then
		return Cryo.Dictionary.join(v13, {
			MorePageFriends = p2.count
		})
	end

	if p2.type == SetUnreadMessageCount.name then
		return Cryo.Dictionary.join(v13, {
			MorePageMessages = p2.count
		})
	end

	if p2.type == SetEmailNotificationCount.name then
		return Cryo.Dictionary.join(v13, {
			MorePageEmailSettings = p2.count,
			MorePageSettings = p2.count + v13.MorePagePasswordSettings
		})
	end

	if p2.type == SetPasswordNotificationCount.name then
		return Cryo.Dictionary.join(v13, {
			MorePagePasswordSettings = p2.count,
			MorePageSettings = p2.count + v13.MorePageEmailSettings
		})
	end

	if p2.type == SetTencentNoticeBadgeCount.name then
		return Cryo.Dictionary.join(v13, {
			MorePageTencentUnreadNotice = p2.count
		})
	end

	if p2.type == DecrementUnreadTencentNoticeCount.name then
		local v14 = v13.MorePageTencentUnreadNotice - 1

		return Cryo.Dictionary.join(v13, {
			MorePageTencentUnreadNotice = v14 > 0 and v14 or 0
		})
	end

	return v13
end
