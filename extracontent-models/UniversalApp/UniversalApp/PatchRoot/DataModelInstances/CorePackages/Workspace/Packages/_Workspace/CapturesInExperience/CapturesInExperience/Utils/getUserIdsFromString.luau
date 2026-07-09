local function getUserIdsFromString(s1: string) -- line: 1
	local t1 = {}

	for _, v5 in (string.split(s1, ",")) do
		if tonumber(v5) then
			t1[v5] = true
		end
	end

	return t1
end

return getUserIdsFromString
