local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize

local MAKEUP_TYPE_TO_ASSET_TYPE_ID = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Constants.MAKEUP_TYPE_TO_ASSET_TYPE_ID

local v5 = memoize(function(items)
	local ordersByAssetId = {}
	local result = {}

	for k, item in items do
		local v6 = MAKEUP_TYPE_TO_ASSET_TYPE_ID[item.MakeupType]

		ordersByAssetId[tostring(item.AssetId)] = item.Order

		table.insert(result, { id = tostring(item.AssetId), typeId = v6 })
	end

	table.sort(result, function(a, b): boolean
		return ordersByAssetId[a.id] > ordersByAssetId[b.id]
	end)

	return result
end)

return function(p2)
	local currentCharacter = p2.AvatarExperience.AvatarScene.Character.CurrentCharacter

	if not currentCharacter then
		return {}
	end

	local makeupDescriptions = {}

	for i, makeupDescription in currentCharacter.Humanoid.HumanoidDescription:GetChildren() do
		if makeupDescription:IsA("MakeupDescription") then
			table.insert(makeupDescriptions, makeupDescription)
		end
	end

	return v5(makeupDescriptions)
end
