local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Cryo")

local v5 = {}

return function(p2, p3)
	local join = Cryo.Dictionary.join
	local v8 = if p3 then p3.isInExperience else false
	return join(p2 or v5, { isInExperience = v8 })
end
