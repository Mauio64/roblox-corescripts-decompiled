local Parent = script:FindFirstAncestor("AvatarExperienceHeadRefinement").Parent
local Dash = require(Parent.Dash)
local HeadShapeProperties = require(script.Parent.HeadShapeProperties)

if not require(Parent.AvatarExperienceFlags).FFlagDynamicHeadsMigration then
	return (Dash.keyBy(HeadShapeProperties, function(p1, _) -- line: 18
		return (tostring(p1.assetId))
	end))
end

return ((function() -- line: 21
	-- upvalues: HeadShapeProperties (copy)
	local t1 = {}

	for _, v8 in HeadShapeProperties do
		if type(v8) == "table" and v8.assetId then
			t1[tostring(v8.assetId)] = v8
		end
	end

	return t1
end)())
