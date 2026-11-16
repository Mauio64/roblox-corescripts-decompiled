local function normalizeDescriptionUrl(value)
	local v5, v6 = string.match(value, "^(%a+)://(.*)$")

	local v7, v8 = string.match(v6 or value, "^([%w%.%-]*)(.*)$")

	return `{string.lower(v5 or "https")}://{string.lower(v7 or "")}{v8 or ""}`
end

return normalizeDescriptionUrl
