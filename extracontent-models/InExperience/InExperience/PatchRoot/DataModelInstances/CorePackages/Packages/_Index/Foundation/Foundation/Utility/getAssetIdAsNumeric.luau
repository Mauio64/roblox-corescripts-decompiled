local function getAssetIdAsNumeric(value)
	if typeof(value) == "number" then
		return value
	end

	return tonumber(value:match("(%d+)$")) or -1
end

return getAssetIdAsNumeric
