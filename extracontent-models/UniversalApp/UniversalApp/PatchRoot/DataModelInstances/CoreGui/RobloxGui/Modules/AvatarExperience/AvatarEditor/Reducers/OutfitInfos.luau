local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local SetOutfitInfo = require(Modules.AvatarExperience.AvatarEditor.Actions.SetOutfitInfo)
local RevokeOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.RevokeOutfit)
local UpdateOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.UpdateOutfit)
local OutfitRenamed = require(Modules.AvatarExperience.AvatarEditor.Actions.OutfitRenamed)
local OutfitInformationReceived = require(Modules.AvatarExperience.Common.Actions.OutfitInformationReceived)

require(Modules.AvatarExperience.Common.Types)

local AXCombineGetOutfitDispatchesIXP = require(Modules.AvatarExperience.Experiments.AXCombineGetOutfitDispatchesIXP)

return Rodux.createReducer({}, {
	[SetOutfitInfo.name] = function(p1, p2) -- line: 20
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			[tostring(p2.outfit.outfitId)] = p2.outfit
		})
	end,
	[RevokeOutfit.name] = function(p3, p4) -- line: 23
		-- upvalues: Cryo (copy)
		local str = tostring(p4.outfitId)

		return Cryo.Dictionary.join(p3, {
			[str] = Cryo.None
		})
	end,
	[UpdateOutfit.name] = function(p5, p6) -- line: 27
		-- upvalues: Cryo (copy)
		local str = tostring(p6.outfitId)

		return Cryo.Dictionary.join(p5, {
			[str] = Cryo.None
		})
	end,
	[OutfitRenamed.name] = function(p7, p8) -- line: 33
		-- upvalues: Cryo (copy)
		local v21 = p7[p8.outfitId]

		if not v21 then
			return p7
		end

		return Cryo.Dictionary.join(p7, {
			[p8.outfitId] = Cryo.Dictionary.join(v21, {
				name = p8.name
			})
		})
	end,
	[OutfitInformationReceived.name] = if not AXCombineGetOutfitDispatchesIXP.isEnabled() then nil else function(p9, p10) -- line: 46
		local v24 = table.clone(p9)

		for v25, v26 in p10.outfits do
			v24[v25] = v26.outfitInfo
		end

		return v24
	end
})
