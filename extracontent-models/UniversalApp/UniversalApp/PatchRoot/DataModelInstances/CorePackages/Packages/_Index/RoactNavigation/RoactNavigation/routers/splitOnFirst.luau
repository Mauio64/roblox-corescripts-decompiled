local function TypeError(p1) -- line: 14
	return p1
end
local function splitOnFirst(p2, p3) -- line: 18
	if type(p2) ~= "string" or type(p3) ~= "string" then
		error("Expected the arguments to be of type `string`")
	end

	if p3 == "" then
		return { p2 }
	end

	local v6 = p2:find(p3, 1, true)

	if v6 == nil then
		return { p2 }
	end

	return {
		p2:sub(1, v6 - 1),
		p2:sub(v6 + p3:len())
	}
end

return splitOnFirst
