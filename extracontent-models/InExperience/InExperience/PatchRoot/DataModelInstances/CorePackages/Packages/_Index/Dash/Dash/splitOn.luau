local insert = table.insert

local function splitOn(s1: string, s2: string) -- line: 10
	-- upvalues: insert (copy)
	local t1 = {}
	local t2 = {}
	local n1 = 1

	if not s2 then
		for i = 1, #s1 do
			insert(t1, s1:sub(i, i))
		end

		return t1
	end

	local start, stop = s1:find(s2, n1)

	while start do
		insert(t2, s1:sub(start, stop))
		insert(t1, s1:sub(n1, start - 1))
		n1 = stop + 1
		start, stop = s1:find(s2, n1)
	end

	insert(t1, s1:sub(n1))

	return t1, t2
end

return splitOn
