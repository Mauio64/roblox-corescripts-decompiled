local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)

local v6 = memoize(function(p1, p2, p3) -- line: 26
	-- upvalues: Constants (copy), Utils (copy)
	local v10 = false
	local v11 = false

	for v12, v13 in p3 do
		if v13.itemType ~= Constants.ItemType.Asset or v13.itemSubType ~= Constants.AssetTypeIdStrings.Head then
			if v13.itemType ~= Constants.ItemType.Bundle then
				continue
			end

			if v13.itemSubType == Constants.BundleTypeIdStrings.DynamicHead then
				v11 = true

				continue
			end

			if v13.itemSubType ~= Constants.BundleTypeIdStrings.BodyParts then
				continue
			end

			local v14 = Utils.getBundleInfo(p1, v12)
			local v15 = Utils.getOutfitInfoFromBundleIdNoState(v14, p2)

			if not v13.receivedBundleInfo or v15 == nil then
				return v10, v11, false
			end

			if not v15 or not v15.containsDynamicHead then
				v10 = true
			else
				v11 = true
			end

			continue
		end

		v10 = true
	end

	return v10, v11, true
end)

return function(p4) -- line: 59
	-- upvalues: v6 (copy)
	local BundleInfos = p4.AvatarExperience.Common.BundleInfos
	local OutfitInfos = p4.AvatarExperience.AvatarEditor.OutfitInfos
	local TryOnItems = p4.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	return v6(BundleInfos, OutfitInfos, TryOnItems)
end
