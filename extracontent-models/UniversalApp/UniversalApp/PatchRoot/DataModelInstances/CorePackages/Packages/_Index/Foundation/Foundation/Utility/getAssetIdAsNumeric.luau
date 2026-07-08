local function getAssetIdAsNumeric(p1) -- line: 3
	if typeof(p1) == "number" then
		return p1
	end

	local num = tonumber(p1:match("(%d+)$"))

	if num then
		return num
	end

	return -1
end

return getAssetIdAsNumeric
