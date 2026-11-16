local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local module = require("@luauforge/bundled/dMx")

local v5 = memoize(function(items)
	local ordersByAssetId = {}
	local result = {}

	for k, item in items do
		local v6 = module.AccessoryTypeEnumToAssetTypeId[item.AccessoryType]

		if module.LCIgnoredForSorting[v6] or not item.IsLayered then
			continue
		end

		ordersByAssetId[tostring(item.AssetId)] = item.Order or module.LayeredClothingOrder[v6]

		table.insert(result, { id = tostring(item.AssetId), typeId = v6 })
	end

	table.sort(result, function(a, b): boolean
		return ordersByAssetId[a.id] > ordersByAssetId[b.id]
	end)

	return result
end)

return function(p2)
	local currentCharacter = p2.AvatarExperience.AvatarScene.Character.CurrentCharacter

	if currentCharacter then
		return v5((currentCharacter.Humanoid.HumanoidDescription:GetAccessories(false)))
	end

	return {}
end
