local function checkAndFormatPossibleLink(s1: string?, s2: string?, s3: string?, s4: string?, s5: string?) -- line: 7
	if s1 == nil or (s1 == "" or typeof(s1) ~= "string") then
		return false, s1
	end

	assert(s1 ~= nil, "Text can't be nil")
	assert(typeof(s1) == "string", "Text must be a string")

	local v7 = s2 or "{linkStart}"
	local v8 = s3 or "{linkEnd}"
	local v9 = s4 or "<u><b>"
	local v10 = s5 or "</b></u>"
	local v11 = string.find(s1, v7) ~= nil and string.find(s1, v8) ~= nil

	if v11 then
		return v11, (string.gsub(s1, v7, v9):gsub(v8, v10))
	end

	return v11, s1
end

return checkAndFormatPossibleLink
