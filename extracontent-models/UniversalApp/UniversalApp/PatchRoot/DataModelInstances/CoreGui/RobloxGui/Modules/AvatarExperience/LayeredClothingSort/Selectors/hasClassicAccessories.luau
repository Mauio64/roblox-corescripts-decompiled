local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local t1 = {
	[Constants.AssetTypeIdStrings.TShirt] = true,
	[Constants.AssetTypeIdStrings.Pants] = true,
	[Constants.AssetTypeIdStrings.Shirt] = true
}
local v8 = memoize(function(p1) -- line: 16
	-- upvalues: Cryo (copy), t1 (copy)
	for v10, v11 in p1 do
		if not Cryo.isEmpty(v11) and t1[v10] then
			return true
		end
	end

	return false
end)

return function(p2) -- line: 30
	-- upvalues: v8 (copy)
	local EquippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets

	if not EquippedAssets then
		return false
	end

	return v8(EquippedAssets)
end
