local function getThumbSizeVectorFromParamString(s1: string) -- line: 9
	local parts = string.split(s1, "&")

	if #parts == 2 then
		local match = string.match(parts[1], "%d[%d.]*")
		local match2 = string.match(parts[2], "%d[%d.]*")

		if match and match2 then
			return Vector2.new(tonumber(match), (tonumber(match2)))
		end
	end

	return nil
end

return getThumbSizeVectorFromParamString
