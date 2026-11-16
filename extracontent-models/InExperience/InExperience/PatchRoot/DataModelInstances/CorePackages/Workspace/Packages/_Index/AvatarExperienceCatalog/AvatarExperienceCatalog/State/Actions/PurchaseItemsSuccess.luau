local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local parent = AvatarExperienceCatalog.Parent
local Rodux = require(parent.Rodux)

require(AvatarExperienceCatalog.Stores.createAXShoppingCartStore)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMISSaveWearFix = AvatarExperienceFlags.FFlagAXMISSaveWearFix

return Rodux.makeActionCreator(script.Name, function(data)
	local v = {
		equippableAssets = data.equippableAssets,
		items = data.items,
		replaceAllEquippedAssets = data.replaceAllEquippedAssets,
		shouldClearEquippedMakeup = data.shouldClearEquippedMakeup,
		bodyColor3s = data.bodyColor3s,
		bodyScales = data.bodyScales,
		bodyPartColorRangeIds = data.bodyPartColorRangeIds,
		makeupAssetsOnHumanoid = 0
	}
	local makeupAssetsOnHumanoid

	if FFlagAXMISSaveWearFix then
		makeupAssetsOnHumanoid = data.makeupAssetsOnHumanoid
	end

	v.makeupAssetsOnHumanoid = makeupAssetsOnHumanoid
	return v
end)
