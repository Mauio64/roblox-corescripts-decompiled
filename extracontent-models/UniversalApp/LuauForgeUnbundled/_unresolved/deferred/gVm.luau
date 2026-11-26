local module = require("@luauforge/bundled/dPN")
local module2 = require("@luauforge/bundled/fCH")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local inventoryItemAvailability = require("@luauforge/bundled/fCn").Enums.InventoryItemAvailability

return function(p2, onConfirm)
	return function(object)
		local state = object:getState()
		local equippedAssets = state.AvatarExperience.AvatarEditor.Character.EquippedAssets
		local assetInfos = state.AvatarExperience.Common.AssetInfos

		if not (equippedAssets and assetInfos) then
			return
		end

		local v5 = {}

		for k, equippedAsset in equippedAssets do
			for k2, v6 in equippedAsset do
				local assetInfo = assetInfos[k2]

				if
					v6.availabilityStatus == inventoryItemAvailability.Unavailable
					or v6.availabilityStatus == inventoryItemAvailability.Revoked
				then
					table.insert(v5, {
						categoryLoc = module.AssetTypeLocalized[assetInfo.assetType],
						assetTypeId = assetInfo.assetType,
						itemName = assetInfo.name,
						assetId = k2
					})
				end
			end
		end

		if #v5 > 0 then
			for k, v6 in v5 do
				object:dispatch(module2(v6.assetTypeId, v6.assetId))
			end

			if p2 then
				p2.navigate(avatarScreen.ItemsUnavailablePrompt, {
					messageType = "ItemsRemovedFromAvatar",
					items = v5,
					onConfirm = onConfirm
				})
			end
		end
	end
end
