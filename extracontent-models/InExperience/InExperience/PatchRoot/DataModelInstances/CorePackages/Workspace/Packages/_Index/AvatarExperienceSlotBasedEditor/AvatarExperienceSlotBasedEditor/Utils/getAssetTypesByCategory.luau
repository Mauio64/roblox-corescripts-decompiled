local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local Cryo = require(parent.Cryo)
local Categories = require(script.Parent.Parent.Enums.Categories)
require(script.Parent.Parent.Types)
local Constants = require(script.Parent.Parent.Constants)
local BodyAssetTypes = Constants.BodyAssetTypes

local function getAssetTypesByCategory(p, items)
	local assetTypes = p ~= Categories.Body and {} or Cryo.List.map(BodyAssetTypes, function(p2)
		return (tostring(p2.Value))
	end)
	local set = {}

	for _, item in items do
		assetTypes = Cryo.List.join(
			assetTypes or {},
			Cryo.List.map(Cryo.List.filter(item.assetTypes, function(p2): boolean
				if set[p2] then
					return false
				end

				set[p2] = true
				return true
			end), function(p2)
				return (tostring(p2.Value))
			end)
		)
	end

	if Cryo.List.find(assetTypes, (tostring(Enum.AssetType.RightShoeAccessory.Value))) then
		table.insert(assetTypes, (tostring(Enum.AssetType.LeftShoeAccessory.Value)))
	end

	return assetTypes
end

return getAssetTypesByCategory
