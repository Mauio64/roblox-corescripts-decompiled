local function separateNumberAndName(s1: string) -- line: 1
	local v3 = s1:match("^%d+")

	if v3 then
		local v4 = string.sub(s1, #v3 + 1)

		return tonumber(v3), v4
	end

	return nil, s1
end

return function(p1, p2) -- line: 11
	local name = p1.name
	local v8 = name:match("^%d+")
	local num

	if v8 then
		name = string.sub(name, #v8 + 1)
		num = tonumber(v8)
	else
		num = nil
	end

	local name2 = p2.name
	local v11 = name2:match("^%d+")
	local num2

	if v11 then
		name2 = string.sub(name2, #v11 + 1)
		num2 = tonumber(v11)
	else
		num2 = nil
	end

	if num ~= nil and num2 == nil then
		return true
	end

	if num == nil and num2 ~= nil then
		return false
	end

	if num ~= nil and num2 ~= nil and name == name2 then
		return num < num2
	end

	return name < name2
end
