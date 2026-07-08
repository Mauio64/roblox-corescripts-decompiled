local RoduxGames = script:FindFirstAncestor("RoduxGames")
local RoduxGamesParent = RoduxGames.Parent
local t = require(RoduxGamesParent.t)
local CreatorType = require(RoduxGames.Enums).CreatorType
local t1 = {}

function t1.new(p1) -- line: 15
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function t1.mock(p2) -- line: 27
	-- upvalues: t1 (copy), CreatorType (copy)
	local v8 = p2 or {}

	return (t1.new({
		creatorId = v8.creatorId or "creatorId",
		creatorName = v8.creatorName or "creatorName",
		creatorType = v8.creatorType or CreatorType.User
	}))
end
function t1.format(p3) -- line: 39
	-- upvalues: t1 (copy), CreatorType (copy)
	return (t1.new({
		creatorId = tostring(p3.id),
		creatorName = p3.name,
		creatorType = CreatorType.fromRawValue(p3.type)
	}))
end

t1.isValid = t.strictInterface({
	creatorId = t.string,
	creatorName = t.string,
	creatorType = t.userdata
})

return t1
