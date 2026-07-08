local function parseXmlAttributes(s1: string) -- line: 1
	local v3 = s1:gmatch("%s*([A-Za-z0-9_-]+)=\"([^\"]*)\"%s*")
	local v4 = s1:gmatch("%s*([A-Za-z0-9_-]+)='([^']*)'%s*")
	local t1 = {}

	for v6, v7 in v3 do
		t1[v6] = v7 or ""
	end

	for v8, v9 in v4 do
		t1[v8] = v9 or ""
	end

	return t1
end

return parseXmlAttributes
