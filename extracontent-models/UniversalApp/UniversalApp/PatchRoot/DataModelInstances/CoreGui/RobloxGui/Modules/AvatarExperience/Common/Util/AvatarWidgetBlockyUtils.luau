local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(Modules.AvatarExperience.Common.Types)

local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local Utils = require(Modules.AvatarExperience.Common.Utils)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local FFlagAXMISEnableMultiShopping = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShopping
local t5 = {
	buildEquippedBodyStateMap = function(p1) -- line: 36
		-- upvalues: Constants (copy)
		local t1 = {}

		for _, v12 in p1.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
			if v12.itemType == Constants.ItemType.Bundle and v12.bundleInfo and v12.itemId == tostring(Constants.BlockyBundleId) then
				for _, v14 in v12.bundleInfo do
					if Constants.AssetTypeIdToCategory[v14.assetType] == Constants.AssetCategories.Body then
						t1[v14.assetType] = v12.selectedInTryOnManager
					end
				end
			end
		end

		return t1
	end,
	shouldUnequipBodyBeforeTryOn = function(p2) -- line: 63
		-- upvalues: FFlagAXMISEnableMultiShopping (copy), Constants (copy)
		if FFlagAXMISEnableMultiShopping then
			return p2.AvatarExperience.AvatarScene.OutfitTryOn.ShouldTryOnWithoutEquippedItems == true
		end

		local LookId = p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId
		local LookType = p2.AvatarExperience.AvatarScene.OutfitTryOn.LookType

		return LookId ~= nil and LookType == Constants.LookType.Avatar
	end,
	buildEquippedAssetMapByHumanoidDescriptionProp = function(p3) -- line: 79
		-- upvalues: Constants (copy)
		local EquippedAssets = p3.AvatarExperience.AvatarEditor.Character.EquippedAssets
		local t2 = {}

		if EquippedAssets then
			for v21, v22 in EquippedAssets do
				local v23 = Constants.AssetTypeIdStringToHumanoidDescriptionProp[v21]

				if v23 then
					if not t2[v23] then
						t2[v23] = {}
					end

					table.insert(t2[v23], v22)
				end
			end
		end

		return t2
	end,
	processBlockyBundleParts = function(t3: {[any]: any}) -- line: 100
		-- upvalues: Constants (copy)
		local t4 = {
			[Constants.AssetTypeIdStrings.Torso] = true,
			[Constants.AssetTypeIdStrings.RightArm] = true,
			[Constants.AssetTypeIdStrings.LeftArm] = true,
			[Constants.AssetTypeIdStrings.LeftLeg] = true,
			[Constants.AssetTypeIdStrings.RightLeg] = true,
			[Constants.AssetTypeIdStrings.DynamicHead] = true,
			[Constants.AssetTypeIdStrings.Head] = true
		}
		local n1 = 7

		for _, v28 in t3 do
			for _, v30 in v28.assetsInBundle do
				if v30.isIncluded then
					if tostring(v30.assetType) == Constants.AssetTypeIdStrings.DynamicHead or tostring(v30.assetType) == Constants.AssetTypeIdStrings.Head then
						t4[Constants.AssetTypeIdStrings.DynamicHead] = nil
						t4[Constants.AssetTypeIdStrings.Head] = nil
						n1 -= 2
					else
						t4[tostring(v30.assetType)] = nil
						n1 -= 1
					end
				end
			end
		end

		if t4[Constants.AssetTypeIdStrings.DynamicHead] and t4[Constants.AssetTypeIdStrings.Head] then
			t4[Constants.AssetTypeIdStrings.Head] = nil

			local _ = n1 - 1
		end

		return t4
	end
}

function t5.buildBlockyLookDetailItem(t6: {[any]: any}, p4: ((...any) -> ...any)) -- line: 153
	-- upvalues: WidgetConstants (copy), Constants (copy), t5 (copy)
	local t7 = {
		bundleType = 1,
		description = "",
		productId = 0,
		isPurchasable = false,
		priceInRobux = 0,
		quantityOwned = 1,
		tryOnItemOrder = 0,
		itemType = WidgetConstants.ContentType.Bundle,
		itemRestrictions = {},
		assetsInBundle = {},
		name = p4("Feature.Avatar.Label.DefaultBody"),
		id = tostring(Constants.BlockyBundleId)
	}
	local n2 = 1

	for v36, _ in (t5.processBlockyBundleParts(t6)) do
		table.insert(t7.assetsInBundle, {
			isIncluded = true,
			id = n2,
			assetType = tonumber(v36) or 0
		})
		n2 += 1
	end

	if #t7.assetsInBundle == 0 then
		return nil
	end

	return t7
end
function t5.adjustTryOnItemOrderForBlockyBundle(t8: {[any]: any}, t9: {[any]: any}, t10: {[any]: any}) -- line: 203
	-- upvalues: Utils (copy), Constants (copy)
	local n3 = 0

	for v42, v43 in t10 do
		if not Utils.isItemSelectable(v43) then
			n3 = v42
		end
	end

	local v44 = n3 + 1

	for _, v46 in t8 do
		if v46.tryOnItemOrder and v44 <= v46.tryOnItemOrder then
			v46.tryOnItemOrder = v46.tryOnItemOrder + 1
		end
	end

	for _, v48 in t9 do
		if v48.id == tostring(Constants.BlockyBundleId) then
			v48.tryOnItemOrder = v44
		elseif v48.tryOnItemOrder and v44 <= v48.tryOnItemOrder then
			v48.tryOnItemOrder = v48.tryOnItemOrder + 1
		end
	end
end

return t5
