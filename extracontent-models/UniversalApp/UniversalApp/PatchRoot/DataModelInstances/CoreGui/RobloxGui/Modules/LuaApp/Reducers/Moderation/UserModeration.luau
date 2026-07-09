local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LuaApp = CoreGui.RobloxGui.Modules.LuaApp
local SetModerationStatus = require(LuaApp.Actions.Moderation.SetModerationStatus)
local SetModerationDetail = require(LuaApp.Actions.Moderation.SetModerationDetail)
local Cryo = require(CorePackages.Packages.Cryo)

return function(t1: {[any]: any}?, p1) -- line: 16
	-- upvalues: SetModerationStatus (copy), SetModerationDetail (copy), Cryo (copy)
	local v9 = t1 or {}

	assert(v9, "")

	if p1.type == SetModerationStatus.name then
		v9 = {
			userModerated = p1.userModerated
		}
	end

	if p1.type == SetModerationDetail.name then
		local v10 = v9 or {}
		local v11 = Cryo.Dictionary.join(v10, {
			moderationDetail = p1.moderationDetail
		})

		v9 = Cryo.Dictionary.join(v9, v11)
	end

	return v9
end
