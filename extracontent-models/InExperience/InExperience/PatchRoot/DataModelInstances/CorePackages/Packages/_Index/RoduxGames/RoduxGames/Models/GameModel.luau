local Parent = script:FindFirstAncestor("RoduxGames").Parent
local t = require(Parent.t)
local CreatorModel = require(script.Parent.CreatorModel)
local t1 = {}

function t1.new(p1) -- line: 18
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function t1.mock(p2) -- line: 30
	-- upvalues: t1 (copy), CreatorModel (copy)
	local v7 = p2 or {}

	return (t1.new({
		experienceId = v7.experienceId or "experienceId",
		name = v7.name or "name",
		description = v7.description or "description",
		price = v7.price or 666,
		rootPlaceId = v7.rootPlaceId or "rootPlaceId",
		creator = CreatorModel.mock(v7.creator),
		maxPlayers = v7.maxPlayers or 6,
		playing = v7.playing or 1000
	}))
end
function t1.format(p3) -- line: 47
	-- upvalues: t1 (copy), CreatorModel (copy)
	return (t1.new({
		experienceId = tostring(p3.id),
		name = p3.name,
		description = p3.description or "",
		price = p3.price or 0,
		rootPlaceId = tostring(p3.rootPlaceId),
		creator = CreatorModel.format(p3.creator),
		maxPlayers = p3.maxPlayers,
		playing = p3.playing
	}))
end

t1.isValid = t.strictInterface({
	experienceId = t.string,
	name = t.string,
	description = t.string,
	price = t.number,
	rootPlaceId = t.string,
	creator = CreatorModel.isValid,
	maxPlayers = t.number,
	playing = t.number
})

return t1
