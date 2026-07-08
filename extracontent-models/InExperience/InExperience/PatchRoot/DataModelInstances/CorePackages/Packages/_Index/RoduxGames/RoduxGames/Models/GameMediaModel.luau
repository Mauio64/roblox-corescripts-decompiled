local Parent = script:FindFirstAncestor("RoduxGames").Parent
local t = require(Parent.t)
local t1 = {}

function t1.new(t2: {[any]: any}) -- line: 19
	-- upvalues: t1 (copy)
	assert(t1.isValid(t2))
	t1.__index = t1
	setmetatable(t2, t1)

	return t2
end
function t1.mock(p1) -- line: 31
	-- upvalues: t1 (copy)
	local v6 = p1 or {}

	return (t1.new({
		assetTypeId = v6.assetTypeId or 1,
		assetType = v6.assetType or "Image",
		imageId = v6.imageId or 1234567890,
		approved = v6.approved or false
	}))
end
function t1.format(t3: {[any]: any}) -- line: 44
	-- upvalues: t1 (copy)
	return (t1.new({
		assetTypeId = t3.assetTypeId,
		assetType = t3.assetType,
		imageId = t3.imageId,
		videoHash = t3.videoHash,
		videoTitle = t3.videoTitle,
		approved = not not t3.approved and t3.approved,
		altText = t3.altText
	}))
end

t1.isValid = t.strictInterface({
	assetTypeId = t.optional(t.number),
	assetType = t.string,
	imageId = t.optional(t.number),
	videoHash = t.optional(t.string),
	videoTitle = t.optional(t.string),
	approved = t.boolean,
	altText = t.optional(t.string)
})

return t1
