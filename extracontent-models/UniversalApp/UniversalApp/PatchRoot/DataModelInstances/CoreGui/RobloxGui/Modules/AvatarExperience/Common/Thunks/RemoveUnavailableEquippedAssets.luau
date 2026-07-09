local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Thunks.ToggleEquipAsset)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local InventoryItemAvailability = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Enums.InventoryItemAvailability

return function(p1, p2) -- line: 31
	-- upvalues: InventoryItemAvailability (copy), Constants (copy), ToggleEquipAsset (copy), AvatarScreen (copy)
	return function(p3) -- line: 32
		-- upvalues: InventoryItemAvailability (copy), Constants (copy), ToggleEquipAsset (copy), p1 (copy), AvatarScreen (copy), p2 (copy)
		local v10 = p3:getState()
		local EquippedAssets = v10.AvatarExperience.AvatarEditor.Character.EquippedAssets
		local AssetInfos = v10.AvatarExperience.Common.AssetInfos

		if not EquippedAssets or not AssetInfos then
			return
		end

		local t1 = {}

		for _, v15 in EquippedAssets do
			for v16, v17 in v15 do
				local v18 = AssetInfos[v16]

				if v17.availabilityStatus == InventoryItemAvailability.Unavailable or v17.availabilityStatus == InventoryItemAvailability.Revoked then
					table.insert(t1, {
						categoryLoc = Constants.AssetTypeLocalized[v18.assetType],
						assetTypeId = v18.assetType,
						itemName = v18.name,
						assetId = v16
					})
				end
			end
		end

		if #t1 > 0 then
			for _, v20 in t1 do
				p3:dispatch(ToggleEquipAsset(v20.assetTypeId, v20.assetId))
			end

			if p1 then
				p1.navigate(AvatarScreen.ItemsUnavailablePrompt, {
					messageType = "ItemsRemovedFromAvatar",
					items = t1,
					onConfirm = p2
				})
			end
		end
	end
end
