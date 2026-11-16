local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dMx")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize

local set = {
	[module.AssetTypeIdStrings.TShirt] = true,
	[module.AssetTypeIdStrings.Pants] = true,
	[module.AssetTypeIdStrings.Shirt] = true
}

local v5 = memoize(function(items): boolean
	for k, item in items do
		if not Cryo.isEmpty(item) and set[k] then
			return true
		end
	end

	return false
end)

return function(p2)
	local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets

	if equippedAssets then
		return v5(equippedAssets)
	end

	return false
end
