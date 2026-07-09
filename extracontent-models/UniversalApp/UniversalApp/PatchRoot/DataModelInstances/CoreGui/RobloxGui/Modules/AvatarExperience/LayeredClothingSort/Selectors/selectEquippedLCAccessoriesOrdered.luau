local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local Constants = require(Modules.AvatarExperience.Common.Constants)
local v6 = memoize(function(p1) -- line: 12
	-- upvalues: Constants (copy)
	local t1 = {}
	local t2 = {}

	for _, v11 in p1 do
		local v12 = Constants.AccessoryTypeEnumToAssetTypeId[v11.AccessoryType]

		if not Constants.LCIgnoredForSorting[v12] and v11.IsLayered then
			t2[tostring(v11.AssetId)] = v11.Order or Constants.LayeredClothingOrder[v12]
			table.insert(t1, {
				id = tostring(v11.AssetId),
				typeId = v12
			})
		end
	end

	table.sort(t1, function(p2, p3) -- line: 29
		-- upvalues: t2 (copy)
		return t2[p2.id] > t2[p3.id]
	end)

	return t1
end)

return function(p4) -- line: 43
	-- upvalues: v6 (copy)
	local CurrentCharacter = p4.AvatarExperience.AvatarScene.Character.CurrentCharacter

	if not CurrentCharacter then
		return {}
	end

	local Accessories = CurrentCharacter.Humanoid.HumanoidDescription:GetAccessories(false)

	return v6(Accessories)
end
