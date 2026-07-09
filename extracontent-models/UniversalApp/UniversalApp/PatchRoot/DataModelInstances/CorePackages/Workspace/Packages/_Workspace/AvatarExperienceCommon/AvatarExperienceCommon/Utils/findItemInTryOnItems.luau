local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local Dash = require(Parent.Dash)
local getTryOnItemReducerKey = require(script.Parent.getTryOnItemReducerKey)

local function findItemInTryOnItems(t1: {[any]: any}, p1, s1: string?) -- line: 8
	-- upvalues: getTryOnItemReducerKey (copy), Dash (copy)
	if s1 then
		return t1[getTryOnItemReducerKey(tostring(p1), s1)]
	end

	return Dash.find(t1, function(p2) -- line: 19
		-- upvalues: p1 (copy)
		return tostring(p2.itemId) == tostring(p1)
	end)
end

return findItemInTryOnItems
