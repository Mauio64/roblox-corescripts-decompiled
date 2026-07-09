local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local SetBodyPartRangeIds = require(Modules.AvatarExperience.AvatarEditor.Actions.SetBodyPartRangeIds)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local PurchaseItemsSuccess = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).State.Actions.PurchaseItemsSuccess
local CharacterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local t1 = {}

return Rodux.createReducer(t1, {
	[SetBodyPartRangeIds.name] = function(p1, p2) -- line: 31
		-- upvalues: Cryo (copy)
		return (Cryo.Dictionary.join(p1, p2.bodyPartRangeIds))
	end,
	[CharacterHistoryStateChangeButtonActivated.name] = function(p3, p4) -- line: 34
		-- upvalues: FFlagAXRootSlotBasedEditorFlag (copy)
		if FFlagAXRootSlotBasedEditorFlag and (p4.equipped and p4.equipped.BodyPartRangeIds) then
			return (table.clone(p4.equipped.BodyPartRangeIds))
		end

		return p3
	end,
	[PurchaseItemsSuccess.name] = if not FFlagAXMISEnableMultiShopping then nil else function(p5, p6) -- line: 43
		-- upvalues: t1 (copy), Cryo (copy)
		local v19 = p5 or t1

		if p6.bodyPartColorRangeIds then
			return (Cryo.Dictionary.join(v19, p6.bodyPartColorRangeIds))
		end

		return v19
	end
})
