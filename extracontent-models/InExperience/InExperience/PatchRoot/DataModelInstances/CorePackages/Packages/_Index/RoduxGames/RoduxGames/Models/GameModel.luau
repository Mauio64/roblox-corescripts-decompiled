local parent = script:FindFirstAncestor("RoduxGames").Parent
local t = require(parent.t)
local CreatorModel = require(script.Parent.CreatorModel)

local GameModel = {}

function GameModel.new(p)
	assert(GameModel.isValid(p))

	GameModel.__index = GameModel

	setmetatable(p, GameModel)

	return p
end

function GameModel.mock(options)
	local v = options or {}

	return (GameModel.new({
		experienceId = v.experienceId or "experienceId",
		name = v.name or "name",
		description = v.description or "description",
		price = v.price or 666,
		rootPlaceId = v.rootPlaceId or "rootPlaceId",
		creator = CreatorModel.mock(v.creator),
		maxPlayers = v.maxPlayers or 6,
		playing = v.playing or 1000
	}))
end

function GameModel.format(data)
	return (GameModel.new({
		experienceId = tostring(data.id),
		name = data.name,
		description = data.description or "",
		price = data.price or 0,
		rootPlaceId = tostring(data.rootPlaceId),
		creator = CreatorModel.format(data.creator),
		maxPlayers = data.maxPlayers,
		playing = data.playing
	}))
end

GameModel.isValid = t.strictInterface({
	experienceId = t.string,
	name = t.string,
	description = t.string,
	price = t.number,
	rootPlaceId = t.string,
	creator = CreatorModel.isValid,
	maxPlayers = t.number,
	playing = t.number
})

return GameModel
