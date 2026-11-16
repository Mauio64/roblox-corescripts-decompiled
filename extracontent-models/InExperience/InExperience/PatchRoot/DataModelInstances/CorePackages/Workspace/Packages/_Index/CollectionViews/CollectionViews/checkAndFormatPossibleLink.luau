local function checkAndFormatPossibleLink(value: string?, value2: string?, value3: string?, value4: string?, value5: string?)
	if value == nil or value == "" or typeof(value) ~= "string" then
		return false, value
	end

	assert(value ~= nil, "Text can't be nil")
	assert(typeof(value) == "string", "Text must be a string")

	local v = value2 or "{linkStart}"
	local v2 = value3 or "{linkEnd}"
	local v3 = value4 or "<u><b>"
	local v4 = value5 or "</b></u>"
	local v5

	if string.find(value, v) == nil then
		v5 = false
	else
		v5 = string.find(value, v2) ~= nil
	end

	if v5 then
		return v5, (string.gsub(value, v, v3):gsub(v2, v4))
	end

	return v5, value
end

return checkAndFormatPossibleLink
