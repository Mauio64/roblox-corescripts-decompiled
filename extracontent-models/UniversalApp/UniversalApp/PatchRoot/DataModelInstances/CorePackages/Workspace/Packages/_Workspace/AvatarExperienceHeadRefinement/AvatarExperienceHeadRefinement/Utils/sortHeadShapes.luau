local AvatarExperienceHeadRefinement = script:FindFirstAncestor("AvatarExperienceHeadRefinement")
local HeadShape = require(AvatarExperienceHeadRefinement.Enums.HeadShape)
local AvatarExperienceHeadRefinementParent = AvatarExperienceHeadRefinement.Parent
local FFlagDynamicHeadsMigration = require(AvatarExperienceHeadRefinementParent.AvatarExperienceFlags).FFlagDynamicHeadsMigration
local t1 = {}

for v6, v7 in {
	HeadShape.Default,
	HeadShape.WomanHead,
	HeadShape.ManHead,
	HeadShape.Blockhead,
	HeadShape.Cheeks,
	HeadShape.Chiseled,
	HeadShape.Narrow,
	HeadShape.Paragon,
	HeadShape.Roundy,
	HeadShape.StrongJaw,
	HeadShape.Trim
} do
	t1[v7] = v6
end

local function sortHeadShapes(p1, p2: ((...any) -> ...any)) -- line: 31
	-- upvalues: FFlagDynamicHeadsMigration (copy), t1 (copy)
	if not FFlagDynamicHeadsMigration then
		local v11 = table.clone(p1)

		table.sort(v11, function(p3, p4) -- line: 35
			-- upvalues: p2 (copy), t1 (copy)
			local v15 = p2(p3)
			local v16 = p2(p4)

			return t1[v15] < t1[v16]
		end)

		return v11
	end

	local v12 = table.clone(p1)

	table.sort(v12, function(p5, p6) -- line: 45
		-- upvalues: p2 (copy), t1 (copy)
		local v19 = p2(p5)
		local v20 = p2(p6)
		local v21 = t1[v19]
		local v22 = t1[v20]

		if v21 == nil and v22 == nil then
			return v19 < v20
		end

		if v21 == nil then
			return false
		end

		if v22 == nil then
			return true
		end

		return v21 < v22
	end)

	return v12
end

return sortHeadShapes
