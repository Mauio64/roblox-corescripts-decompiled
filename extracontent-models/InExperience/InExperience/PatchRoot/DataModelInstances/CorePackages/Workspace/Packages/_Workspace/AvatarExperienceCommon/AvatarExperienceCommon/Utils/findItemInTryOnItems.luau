local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local Dash = require(parent.Dash)

local getTryOnItemReducerKey = require(script.Parent.getTryOnItemReducerKey)

local function findItemInTryOnItems(p, p2, p3: string?)
	if p3 then
		return p[getTryOnItemReducerKey(tostring(p2), p3)]
	end

	return Dash.find(p, function(p4): boolean
		return tostring(p4.itemId) == tostring(p2)
	end)
end

return findItemInTryOnItems
