local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ClearTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.ClearTryOns
local SetLastSavedTriedOnOutfit = require(Modules.AvatarExperience.Common.Actions.SetLastSavedTriedOnOutfit)

return function() -- line: 14
	-- upvalues: SetLastSavedTriedOnOutfit (copy), ClearTryOns (copy)
	return function(p1) -- line: 15
		-- upvalues: SetLastSavedTriedOnOutfit (copy), ClearTryOns (copy)
		local OutfitTryOn = p1:getState().AvatarExperience.AvatarScene.OutfitTryOn

		p1:dispatch(SetLastSavedTriedOnOutfit(OutfitTryOn))
		p1:dispatch(ClearTryOns())
	end
end
