local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local tutils = require(CorePackages.Packages.tutils)
local v5 = memoize(function(p1) -- line: 9
	-- upvalues: tutils (copy)
	return tutils.fieldCount(p1)
end)

local function selectNumTryOnItems(p2) -- line: 13
	-- upvalues: v5 (copy)
	local TryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	return v5(TryOnItems)
end

return selectNumTryOnItems
