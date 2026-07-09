local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local SetBodyColor3s = require(Modules.AvatarExperience.AvatarEditor.Actions.SetBodyColor3s)
local ReceivedAvatarData = require(Modules.AvatarExperience.AvatarEditor.Actions.ReceivedAvatarData)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Cryo = require(CorePackages.Packages.Cryo)

require(Modules.AvatarExperience.Common.Types)

local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local CharacterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local PurchaseItemsSuccess = AvatarExperienceCatalog.State.Actions.PurchaseItemsSuccess
local t1 = {
	headColor3 = Constants.DefaultBodyColor3,
	leftArmColor3 = Constants.DefaultBodyColor3,
	leftLegColor3 = Constants.DefaultBodyColor3,
	rightArmColor3 = Constants.DefaultBodyColor3,
	rightLegColor3 = Constants.DefaultBodyColor3,
	torsoColor3 = Constants.DefaultBodyColor3
}

return Rodux.createReducer(t1, {
	[SetBodyColor3s.name] = function(p1, p2) -- line: 37
		-- upvalues: Cryo (copy)
		return (Cryo.Dictionary.join(p1, p2.bodyColor3s))
	end,
	[ReceivedAvatarData.name] = function(_, p4) -- line: 41
		return p4.avatarData.bodyColor3s
	end,
	[CharacterHistoryStateChangeButtonActivated.name] = function(p5, p6) -- line: 45
		-- upvalues: FFlagAXRootSlotBasedEditorFlag (copy)
		if FFlagAXRootSlotBasedEditorFlag and (p6.equipped and p6.equipped.BodyColor3s) then
			return table.clone(p6.equipped.BodyColor3s)
		end

		return p5
	end,
	[PurchaseItemsSuccess.name] = if not FFlagAXMISEnableMultiShopping then nil else function(p7, p8) -- line: 57
		-- upvalues: t1 (copy), Cryo (copy)
		local v24 = p7 or t1

		if p8.bodyColor3s then
			return (Cryo.Dictionary.join(v24, p8.bodyColor3s))
		end

		return v24
	end
})
