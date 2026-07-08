local function verifySummaryFormat(p1, p2) -- line: 1
	if p1 == nil or typeof(p1) ~= "table" then
		return false
	end

	local t1 = {}

	for _, v6 in p2 do
		t1[v6] = true
	end

	for _, v8 in p2 do
		if p1[v8] == nil or typeof(p1[v8]) ~= "number" then
			return false
		end
	end

	for v9, _ in p1 do
		if not t1[v9] then
			return false
		end
	end

	return true
end

return verifySummaryFormat
