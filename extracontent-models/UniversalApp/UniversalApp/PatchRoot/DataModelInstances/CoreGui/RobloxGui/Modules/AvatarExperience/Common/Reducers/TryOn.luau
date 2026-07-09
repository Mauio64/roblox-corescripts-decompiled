local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local ClearAnimationPreview = require(Modules.AvatarExperience.Common.Actions.ClearAnimationPreview)
local SetAnimationPreview = require(Modules.AvatarExperience.Common.Actions.SetAnimationPreview)
local CharacterHistoryStateChangeButtonActivated = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).State.Actions.CharacterHistoryStateChangeButtonActivated
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local t1 = {
	AnimationPreview = nil,
	AnimationPreviewAssetTypeIdString = nil
}

return Rodux.createReducer(t1, {
	[ClearAnimationPreview.name] = function(p1, _) -- line: 31
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			AnimationPreview = Cryo.None,
			AnimationPreviewAssetTypeIdString = Cryo.None
		})
	end,
	[SetAnimationPreview.name] = function(p3, p4) -- line: 38
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			AnimationPreview = p4.assetId,
			AnimationPreviewAssetTypeIdString = p4.assetTypeIdString
		})
	end,
	[CharacterHistoryStateChangeButtonActivated.name] = function(p5, p6) -- line: 45
		-- upvalues: FFlagAXRootSlotBasedEditorFlag (copy)
		if FFlagAXRootSlotBasedEditorFlag and (p6.tryOn and p6.tryOn.TryOn) then
			return table.clone(p6.tryOn.TryOn)
		end

		return p5
	end
})
