local function separateNumberAndName(value)
	local match = value:match("^%d+")

	if not match then
		return nil, value
	end

	local v5 = string.sub(value, #match + 1)
	return tonumber(match), v5
end

return function(p2, p3): boolean
	local name = p2.name
	local match = name:match("^%d+")
	local v5

	if match then
		name = string.sub(name, #match + 1)
		v5 = tonumber(match)
	end

	local name2 = p3.name
	local match2 = name2:match("^%d+")
	local v6

	if match2 then
		name2 = string.sub(name2, #match2 + 1)
		v6 = tonumber(match2)
	end

	if v5 ~= nil and v6 == nil then
		return true
	end

	if v5 == nil and v6 ~= nil then
		return false
	end

	if v5 == nil or v6 == nil or name ~= name2 then
		return name < name2
	end

	return v5 < v6
end
