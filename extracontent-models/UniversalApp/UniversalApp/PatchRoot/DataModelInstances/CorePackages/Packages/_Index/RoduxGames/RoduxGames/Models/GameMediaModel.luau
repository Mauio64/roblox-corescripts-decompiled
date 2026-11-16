local parent = script:FindFirstAncestor("RoduxGames").Parent

local t = require(parent.t)

local GameMediaModel = {}

function GameMediaModel.new(p)
	assert(GameMediaModel.isValid(p))

	GameMediaModel.__index = GameMediaModel

	setmetatable(p, GameMediaModel)

	return p
end

function GameMediaModel.mock(options)
	local v = options or {}

	return (GameMediaModel.new({
		assetTypeId = v.assetTypeId or 1,
		assetType = v.assetType or "Image",
		imageId = v.imageId or 1234567890,
		approved = v.approved or false
	}))
end

function GameMediaModel.format(data)
	local new = GameMediaModel.new
	local v = {
		assetTypeId = data.assetTypeId,
		assetType = data.assetType,
		imageId = data.imageId,
		videoHash = data.videoHash,
		videoTitle = data.videoTitle,
		approved = 0,
		altText = 0
	}
	local approved = if data.approved then data.approved else false
	v.approved = approved
	v.altText = data.altText
	return (new(v))
end

GameMediaModel.isValid = t.strictInterface({
	assetTypeId = t.optional(t.number),
	assetType = t.string,
	imageId = t.optional(t.number),
	videoHash = t.optional(t.string),
	videoTitle = t.optional(t.string),
	approved = t.boolean,
	altText = t.optional(t.string)
})

return GameMediaModel
