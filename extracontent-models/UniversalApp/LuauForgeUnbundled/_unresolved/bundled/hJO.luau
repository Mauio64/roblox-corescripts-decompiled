local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/fBe")
local module2 = require("@luauforge/bundled/fAY")
local module3 = require("@luauforge/bundled/fBb")
local module4 = require("@luauforge/bundled/fAS")
local module5 = require("@luauforge/bundled/fAV")
local module6 = require("@luauforge/bundled/hJP")
local module7 = require("@luauforge/bundled/fAB")

return function(p2, data)
	local v5 = p2 or {
		TopBarNotificationIcon = 0,
		MorePageMessages = 0,
		MorePageFriends = 0,
		MorePageEmailSettings = 0,
		MorePagePasswordSettings = 0,
		MorePageSettings = 0,
		MorePageTencentUnreadNotice = 0
	}

	if data.type == module.name then
		v5.TopBarNotificationIcon = data.notificationCount
		return v5
	end

	if data.type == module2.name then
		return Cryo.Dictionary.join(v5, { MorePageFriends = data.count })
	end

	if data.type == module3.name then
		return Cryo.Dictionary.join(v5, { MorePageMessages = data.count })
	end

	if data.type == module4.name then
		return Cryo.Dictionary.join(v5, {
			MorePageEmailSettings = data.count,
			MorePageSettings = data.count + v5.MorePagePasswordSettings
		})
	end

	if data.type == module5.name then
		return Cryo.Dictionary.join(v5, {
			MorePagePasswordSettings = data.count,
			MorePageSettings = data.count + v5.MorePageEmailSettings
		})
	end

	if data.type == module6.name then
		return Cryo.Dictionary.join(v5, { MorePageTencentUnreadNotice = data.count })
	end

	if data.type ~= module7.name then
		return v5
	end

	local v6 = v5.MorePageTencentUnreadNotice - 1
	return Cryo.Dictionary.join(v5, {
		MorePageTencentUnreadNotice = v6 > 0 and v6 or 0
	})
end
