local Thumbnail = {}

function Thumbnail.new()
	return {}
end

function Thumbnail.fromThumbnailData(data, size)
	local v = Thumbnail.new()

	v.universeId = tostring(data.targetId)
	v.state = data.state
	v.url = data.imageUrl
	v.size = size

	return v
end

function Thumbnail.isCompleteThumbnailData(data): boolean
	return type(data) == "table"
		and type(data.targetId) == "number"
		and type(data.state) == "string"
		and (type(data.imageUrl) == "string" or data.imageUrl == nil)
end

function Thumbnail.checkStateIsFinal(p): boolean
	return p ~= "Pending"
end

return Thumbnail
