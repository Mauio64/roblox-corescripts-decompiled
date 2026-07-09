local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local SetExperienceNotificationsEnabledCount = require(Modules.LuaApp.Actions.Games.SetExperienceNotificationsEnabledCount)
local SetExperienceNotificationsEnabledLimit = require(Modules.LuaApp.Actions.Games.SetExperienceNotificationsEnabledLimit)

return function(t1: {[any]: any}?, p1) -- line: 15
	-- upvalues: SetExperienceNotificationsEnabledCount (copy), Cryo (copy), SetExperienceNotificationsEnabledLimit (copy)
	local v8 = t1 or {
		count = 0,
		limit = 0
	}

	assert(v8, "")

	if p1.type == SetExperienceNotificationsEnabledCount.name then
		return (Cryo.Dictionary.join(v8, {
			count = p1.count
		}))
	end

	if p1.type == SetExperienceNotificationsEnabledLimit.name then
		v8 = Cryo.Dictionary.join(v8, {
			limit = p1.limit
		})
	end

	return v8
end
