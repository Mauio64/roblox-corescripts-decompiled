local v5 = {}

function v5.new()
	return {}
end

function v5.fromThumbnailData(data, size)
	local v6 = v5.new()

	v6.universeId = tostring(data.targetId)
	v6.state = data.state
	v6.url = data.imageUrl
	v6.size = size

	return v6
end

function v5.isCompleteThumbnailData(data): boolean
	return type(data) == "table"
		and type(data.targetId) == "number"
		and type(data.state) == "string"
		and (type(data.imageUrl) == "string" or data.imageUrl == nil)
end

function v5.checkStateIsFinal(p2): boolean
	return p2 ~= "Pending"
end

return v5
