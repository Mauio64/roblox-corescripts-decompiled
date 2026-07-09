local t1 = {
	new = function() -- line: 12
		return {}
	end
}

function t1.fromThumbnailData(p1, p2) -- line: 18
	-- upvalues: t1 (copy)
	local v4 = t1.new()

	v4.universeId = tostring(p1.targetId)
	v4.state = p1.state
	v4.url = p1.imageUrl
	v4.size = p2

	return v4
end
function t1.isCompleteThumbnailData(p3) -- line: 29
	return type(p3) == "table" and (type(p3.targetId) == "number" and (type(p3.state) == "string" and (type(p3.imageUrl) == "string" or p3.imageUrl == nil)))
end
function t1.checkStateIsFinal(p4) -- line: 36
	return p4 ~= "Pending"
end

return t1
