local function getThumbSizeVectorFromParamString(value: string)
	local v = string.split(value, "&")

	if #v ~= 2 then
		return nil
	end

	local v2 = string.match(v[1], "%d[%d.]*")
	local v3 = string.match(v[2], "%d[%d.]*")

	if v2 and v3 then
		return Vector2.new(tonumber(v2), (tonumber(v3)))
	end

	return nil
end

return getThumbSizeVectorFromParamString
