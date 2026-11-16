local module = require("@luauforge/bundled/dMx")

local function getBodiesInTryOns(tryOnItems)
	local bodiesInTryOns = {}

	for k, item in tryOnItems do
		if
			item.itemType == module.ItemType.Bundle
			and module.BundleTypeIdStringToNameForBackend[item.itemSubType] == "Body"
		then
			table.insert(bodiesInTryOns, k)
		end
	end

	return bodiesInTryOns
end

local function selectTryOnBodyIds(p2)
	local outfitTryOn = p2.AvatarExperience.AvatarScene.OutfitTryOn

	if outfitTryOn and outfitTryOn.TryOnItems then
		return getBodiesInTryOns(outfitTryOn.TryOnItems)
	end

	return {}
end

return selectTryOnBodyIds
