local function parseXmlAttributes(value)
	local v5 = value:gmatch("%s*([A-Za-z0-9_-]+)=\"([^\"]*)\"%s*")
	local v6 = value:gmatch("%s*([A-Za-z0-9_-]+)='([^']*)'%s*")

	local xmlAttributes = {}

	for k, v7 in v5 do
		xmlAttributes[k] = v7 or ""
	end

	for k, v7 in v6 do
		xmlAttributes[k] = v7 or ""
	end

	return xmlAttributes
end

return parseXmlAttributes
