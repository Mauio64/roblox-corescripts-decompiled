local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dMx")
require("@luauforge/bundled/dHK")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
require("@luauforge/bundled/dMc")

local v5 = memoize(function(p2): boolean
	local v6 = p2 and p2[module.AssetTypeIdStrings.DynamicHead]

	if not v6 or Cryo.isEmpty(v6) then
		return false
	end

	local v7 = p2 and p2[module.AssetTypeIdStrings.MoodAnimation]

	if v7 and next(v7) then
		return true
	end

	return false
end)

return function(p2)
	return v5(p2.AvatarExperience.AvatarEditor.Character.EquippedAssets)
end
