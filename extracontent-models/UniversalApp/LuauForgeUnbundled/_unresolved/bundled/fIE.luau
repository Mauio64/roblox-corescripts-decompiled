local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

return {
	mergeExperienceJoinData = function(p2, p3)
		if p3 then
			return (Cryo.Dictionary.join(p2, {
				experienceJoinData = {
					eventId = p3.experienceEventId,
					launchData = p3.launchData
				}
			}))
		end

		return p2
	end
}
