local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local AddNewAssetNotification = require(Modules.AvatarExperience.Common.Actions.AddNewAssetNotification)
local RemoveNewAssetNotification = require(Modules.AvatarExperience.Common.Actions.RemoveNewAssetNotification)
local AddNewOutfitNotification = require(Modules.AvatarExperience.Common.Actions.AddNewOutfitNotification)
local RemoveNewOutfitNotification = require(Modules.AvatarExperience.Common.Actions.RemoveNewOutfitNotification)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)

return Rodux.createReducer({}, {
	[AddNewAssetNotification.name] = function(p1, p2) -- line: 28
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			[p2.assetTypeId] = true
		})
	end,
	[RemoveNewAssetNotification.name] = function(p3, p4) -- line: 34
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			[p4.assetTypeId] = false
		})
	end,
	[AddNewOutfitNotification.name] = function(t1: {[any]: any}, p5) -- line: 40
		-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy), Cryo (copy), Constants (copy)
		if GetFFlagAXEnableSlotBasedEditor() then
			return Cryo.Dictionary.join(t1, {
				[p5.outfitType] = true
			})
		end

		if p5.outfitType == Constants.OutfitTypes.DynamicHead then
			return Cryo.Dictionary.join(t1, {
				[Constants.NewDHOutfitNotificationKey] = true
			})
		end

		return Cryo.Dictionary.join(t1, {
			[Constants.NewOutfitNotificationKey] = true
		})
	end,
	[RemoveNewOutfitNotification.name] = function(p6, p7) -- line: 57
		-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy), Cryo (copy), Constants (copy)
		if GetFFlagAXEnableSlotBasedEditor() then
			return Cryo.Dictionary.join(p6, {
				[p7.outfitType] = false
			})
		end

		if p7.outfitType == Constants.OutfitTypes.DynamicHead then
			return Cryo.Dictionary.join(p6, {
				[Constants.NewDHOutfitNotificationKey] = false
			})
		end

		return Cryo.Dictionary.join(p6, {
			[Constants.NewOutfitNotificationKey] = false
		})
	end
})
