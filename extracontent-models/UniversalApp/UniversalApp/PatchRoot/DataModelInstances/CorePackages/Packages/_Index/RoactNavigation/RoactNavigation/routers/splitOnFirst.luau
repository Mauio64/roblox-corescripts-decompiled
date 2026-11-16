local function TypeError(p)
	return p
end

local function splitOnFirst(value, value2)
	if type(value) ~= "string" or type(value2) ~= "string" then
		error("Expected the arguments to be of type `string`")
	end

	if value2 == "" then
		return { value }
	end

	local v = value:find(value2, 1, true)

	if v == nil then
		return { value }
	end

	return { value:sub(1, v - 1), value:sub(v + value2:len()) }
end

return splitOnFirst
