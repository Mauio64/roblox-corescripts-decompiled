local CorePackages = game:GetService("CorePackages")
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local MAKEUP_TYPE_TO_ASSET_TYPE_ID = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Constants.MAKEUP_TYPE_TO_ASSET_TYPE_ID
local v4 = memoize(function(p1) -- line: 12
	-- upvalues: MAKEUP_TYPE_TO_ASSET_TYPE_ID (copy)
	local t1 = {}
	local t2 = {}

	for _, v9 in p1 do
		local v10 = MAKEUP_TYPE_TO_ASSET_TYPE_ID[v9.MakeupType]

		t2[tostring(v9.AssetId)] = v9.Order
		table.insert(t1, {
			id = tostring(v9.AssetId),
			typeId = v10
		})
	end

	table.sort(t1, function(p2, p3) -- line: 28
		-- upvalues: t2 (copy)
		return t2[p2.id] > t2[p3.id]
	end)

	return t1
end)

return function(p4) -- line: 42
	-- upvalues: v4 (copy)
	local CurrentCharacter = p4.AvatarExperience.AvatarScene.Character.CurrentCharacter

	if not CurrentCharacter then
		return {}
	end

	local t3 = {}

	for _, child in CurrentCharacter.Humanoid.HumanoidDescription:GetChildren() do
		if child:IsA("MakeupDescription") then
			table.insert(t3, child)
		end
	end

	return v4(t3)
end
