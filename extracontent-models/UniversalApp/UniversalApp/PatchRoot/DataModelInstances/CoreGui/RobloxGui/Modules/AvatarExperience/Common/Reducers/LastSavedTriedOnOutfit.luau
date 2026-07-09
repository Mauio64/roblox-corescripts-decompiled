local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local Rodux = require(CorePackages.Packages.Rodux)
local Modules = CoreGui.RobloxGui.Modules

require(script.Parent.OutfitTryOn)

local SetLastSavedTriedOnOutfit = require(Modules.AvatarExperience.Common.Actions.SetLastSavedTriedOnOutfit)
local CharacterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag

return Rodux.createReducer({}, {
	[SetLastSavedTriedOnOutfit.name] = function(_: {[any]: any}, p1) -- line: 26
		return p1.savedOutfit
	end,
	[CharacterHistoryStateChangeButtonActivated.name] = function(t2: {[any]: any}, p2) -- line: 30
		-- upvalues: FFlagAXRootSlotBasedEditorFlag (copy)
		if FFlagAXRootSlotBasedEditorFlag and (p2.tryOn and p2.tryOn.LastSavedTriedOnOutfit) then
			return table.clone(p2.tryOn.LastSavedTriedOnOutfit)
		end

		return t2
	end
})
