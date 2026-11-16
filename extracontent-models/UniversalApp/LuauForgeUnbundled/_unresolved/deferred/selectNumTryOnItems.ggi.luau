local CorePackages = game:GetService("CorePackages")

require("@luauforge/bundled/dHK")

local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local tutils = require(CorePackages.Packages.tutils)

local v5 = memoize(function(p2)
	return tutils.fieldCount(p2)
end)

local function selectNumTryOnItems(p2)
	return v5(p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems)
end

return selectNumTryOnItems
