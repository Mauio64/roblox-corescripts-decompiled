local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetAvatarScales = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarScales)
local ReceivedAvatarData = require(Modules.AvatarExperience.AvatarEditor.Actions.ReceivedAvatarData)

require(Modules.AvatarExperience.Common.Types)

local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local PurchaseItemsSuccess = AvatarExperienceCatalog.State.Actions.PurchaseItemsSuccess
local CharacterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local t1 = {
	height = 1,
	width = 1,
	depth = 1,
	head = 1,
	bodyType = 0,
	proportion = 0
}

return Rodux.createReducer(t1, {
	[SetAvatarScales.name] = function(t2: {[any]: any}, p1) -- line: 45
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t2, p1.scales)
	end,
	[ReceivedAvatarData.name] = function(t3: {[any]: any}, p2) -- line: 48
		if not p2.avatarData then
			return t3
		end

		return p2.avatarData.scales
	end,
	[CharacterHistoryStateChangeButtonActivated.name] = function(p3, p4) -- line: 55
		-- upvalues: FFlagAXRootSlotBasedEditorFlag (copy)
		if FFlagAXRootSlotBasedEditorFlag and (p4.equipped and p4.equipped.AvatarScales) then
			return table.clone(p4.equipped.AvatarScales)
		end

		return p3
	end,
	[PurchaseItemsSuccess.name] = if not FFlagAXMISEnableMultiShopping then nil else function(p5, p6) -- line: 67
		-- upvalues: t1 (copy), Cryo (copy)
		local v23 = p5 or t1

		if p6.bodyScales then
			return (Cryo.Dictionary.join(v23, p6.bodyScales))
		end

		return v23
	end
})
