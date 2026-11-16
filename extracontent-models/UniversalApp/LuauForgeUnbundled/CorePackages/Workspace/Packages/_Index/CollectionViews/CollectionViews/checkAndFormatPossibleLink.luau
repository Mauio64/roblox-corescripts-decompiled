local function checkAndFormatPossibleLink(value, value2, value3, value4, value5)
	if value == nil or value == "" or typeof(value) ~= "string" then
		return false, value
	end

	assert(value ~= nil, "Text can't be nil")
	assert(typeof(value) == "string", "Text must be a string")

	local v5 = value2 or "{linkStart}"
	local v6 = value3 or "{linkEnd}"
	local v7 = value4 or "<u><b>"
	local v8 = value5 or "</b></u>"

	local v9 = not (string.find(value, v5) == nil) and string.find(value, v6) ~= nil

	if v9 then
		return v9, (string.gsub(value, v5, v7):gsub(v6, v8))
	end

	return v9, value
end

return checkAndFormatPossibleLink
