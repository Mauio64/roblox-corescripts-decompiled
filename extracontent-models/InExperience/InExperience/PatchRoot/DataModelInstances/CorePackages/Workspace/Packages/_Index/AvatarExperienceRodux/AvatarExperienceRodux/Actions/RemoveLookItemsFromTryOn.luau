local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(lookId: string, assetIds, bundleIds)
	return { lookId = lookId, assetIds = assetIds, bundleIds = bundleIds }
end)
