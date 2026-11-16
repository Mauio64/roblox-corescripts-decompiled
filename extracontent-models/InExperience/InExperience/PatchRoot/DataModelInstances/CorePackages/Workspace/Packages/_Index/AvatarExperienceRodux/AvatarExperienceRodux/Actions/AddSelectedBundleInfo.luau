local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(bundleId, bundleInfo)
	return { bundleId = bundleId, bundleInfo = bundleInfo }
end)
