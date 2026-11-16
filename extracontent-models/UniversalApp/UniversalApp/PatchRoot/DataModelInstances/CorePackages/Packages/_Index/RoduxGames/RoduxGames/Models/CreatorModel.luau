local RoduxGames = script:FindFirstAncestor("RoduxGames")
local parent = RoduxGames.Parent

local t = require(parent.t)
local Enums = require(RoduxGames.Enums)
local CreatorType = Enums.CreatorType

local CreatorModel = {}

function CreatorModel.new(p)
	assert(CreatorModel.isValid(p))

	CreatorModel.__index = CreatorModel

	setmetatable(p, CreatorModel)

	return p
end

function CreatorModel.mock(options)
	local v = options or {}

	return (CreatorModel.new({
		creatorId = v.creatorId or "creatorId",
		creatorName = v.creatorName or "creatorName",
		creatorType = v.creatorType or CreatorType.User
	}))
end

function CreatorModel.format(data)
	return (CreatorModel.new({
		creatorId = tostring(data.id),
		creatorName = data.name,
		creatorType = CreatorType.fromRawValue(data.type)
	}))
end

CreatorModel.isValid = t.strictInterface({
	creatorId = t.string,
	creatorName = t.string,
	creatorType = t.userdata
})

return CreatorModel
