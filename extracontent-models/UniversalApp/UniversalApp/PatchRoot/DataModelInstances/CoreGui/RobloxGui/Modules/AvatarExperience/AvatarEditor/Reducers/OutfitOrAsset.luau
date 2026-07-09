local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

require(Modules.AvatarExperience.Common.Types)

local SetOutfitOrAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.SetOutfitOrAsset)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local OutfitInformationReceived = require(Modules.AvatarExperience.Common.Actions.OutfitInformationReceived)
local AXCombineGetOutfitDispatchesIXP = require(Modules.AvatarExperience.Experiments.AXCombineGetOutfitDispatchesIXP)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

return Rodux.createReducer({}, {
	[SetOutfitOrAsset.name] = function(t1: {[any]: any}, p1) -- line: 32
		-- upvalues: Cryo (copy)
		local v11 = t1 or {}
		local itemType = p1.itemType
		local t2 = {}

		for _, v15 in p1.ids do
			t2[v15] = itemType
		end

		return Cryo.Dictionary.join(v11, t2)
	end,
	[OutfitInformationReceived.name] = if not AXCombineGetOutfitDispatchesIXP.isEnabled() then nil else function(t3: {[any]: any}, p2) -- line: 46
		-- upvalues: Constants (copy)
		local v18 = table.clone(t3 or {})
		local Outfit = Constants.OutfitOrAsset.Outfit

		for v20, _ in p2.outfits do
			v18[v20] = Outfit
		end

		return v18
	end
})
