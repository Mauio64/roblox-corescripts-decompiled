local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

return {
	mergeExperienceJoinData = function(t1: {[any]: any}, t2: {[any]: any}?) -- line: 4
		-- upvalues: Cryo (copy)
		if t2 then
			return (Cryo.Dictionary.join(t1, {
				experienceJoinData = {
					eventId = t2.experienceEventId,
					launchData = t2.launchData
				}
			}))
		end

		return t1
	end
}
