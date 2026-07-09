local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local GrantAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.GrantAsset)
local RevokeAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.RevokeAsset)
local GrantOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.GrantOutfit)
local RevokeOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.RevokeOutfit)
local t1 = {
	grantedAssetsByType = {},
	grantedOutfitsByType = {}
}

return Rodux.createReducer(t1, {
	[GrantAsset.name] = function(t2: {[any]: any}, p1) -- line: 38
		-- upvalues: Cryo (copy)
		local v12 = t2.grantedAssetsByType[tostring(p1.assetTypeId)] or {}
		local v13 = Cryo.Dictionary.join(t2.grantedAssetsByType, {
			[tostring(p1.assetTypeId)] = Cryo.List.join({ (tostring(p1.assetId)) }, v12)
		})

		return Cryo.Dictionary.join(t2, {
			grantedAssetsByType = v13
		})
	end,
	[RevokeAsset.name] = function(t3: {[any]: any}, p2) -- line: 48
		-- upvalues: Cryo (copy)
		local v16 = t3.grantedAssetsByType[tostring(p2.assetTypeId)] or {}
		local v17 = Cryo.Dictionary.join(t3.grantedAssetsByType, {
			[tostring(p2.assetTypeId)] = Cryo.List.removeValue(v16, (tostring(p2.assetId)))
		})

		return Cryo.Dictionary.join(t3, {
			grantedAssetsByType = v17
		})
	end,
	[GrantOutfit.name] = function(t4: {[any]: any}, p3) -- line: 58
		-- upvalues: Cryo (copy)
		local v20 = t4.grantedOutfitsByType[p3.outfitType] or {}
		local v21 = Cryo.Dictionary.join(t4.grantedOutfitsByType, {
			[tostring(p3.outfitType)] = Cryo.List.join({ (tostring(p3.outfitId)) }, v20)
		})

		return Cryo.Dictionary.join(t4, {
			grantedOutfitsByType = v21
		})
	end,
	[RevokeOutfit.name] = function(t5: {[any]: any}, p4) -- line: 68
		-- upvalues: Cryo (copy)
		local t6 = {}

		for v25, v26 in t5.grantedOutfitsByType do
			t6[v25] = Cryo.List.removeValue(v26, (tostring(p4.outfitId)))
		end

		return Cryo.Dictionary.join(t5, {
			grantedOutfitsByType = t6
		})
	end
})
