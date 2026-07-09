local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Rodux = require(CorePackages.Packages.Rodux)
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

local FFlagAXFixMakeupLookGrantOutfitHoisting = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixMakeupLookGrantOutfitHoisting

return Rodux.makeActionCreator(script.Name, function(n1: number, b1: boolean?, s1: string?) -- line: 18
	-- upvalues: FFlagAXFixMakeupLookGrantOutfitHoisting (copy)
	return {
		outfitId = tostring(n1),
		isEditable = b1,
		outfitType = if not FFlagAXFixMakeupLookGrantOutfitHoisting then nil else s1
	}
end)
