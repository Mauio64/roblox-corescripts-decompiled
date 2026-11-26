local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Cryo")
local Categories = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/Categories")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Types")
local bodyAssetTypes = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Constants").BodyAssetTypes

local function getAssetTypesByCategory(p2, items)
	local assetTypes = p2 ~= Categories.Body and {} or Cryo.List.map(bodyAssetTypes, function(p3)
		return (tostring(p3.Value))
	end)
	local set = {}

	for k, item in items do
		assetTypes = Cryo.List.join(
			assetTypes or {},
			Cryo.List.map(Cryo.List.filter(item.assetTypes, function(p3): boolean
				if set[p3] then
					return false
				end

				set[p3] = true
				return true
			end), function(p3)
				return (tostring(p3.Value))
			end)
		)
	end

	if Cryo.List.find(assetTypes, (tostring(Enum.AssetType.RightShoeAccessory.Value))) then
		table.insert(assetTypes, (tostring(Enum.AssetType.LeftShoeAccessory.Value)))
	end

	return assetTypes
end

return getAssetTypesByCategory
