local function getThumbSizeVectorFromParamString(value)
	local v5 = string.split(value, "&")

	if #v5 ~= 2 then
		return nil
	end

	local v6 = string.match(v5[1], "%d[%d.]*")
	local v7 = string.match(v5[2], "%d[%d.]*")

	if v6 and v7 then
		return Vector2.new(tonumber(v6), (tonumber(v7)))
	end

	return nil
end

return getThumbSizeVectorFromParamString
