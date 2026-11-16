local function parseXmlAttributes(value: string)
	local v = value:gmatch("%s*([A-Za-z0-9_-]+)=\"([^\"]*)\"%s*")
	local v2 = value:gmatch("%s*([A-Za-z0-9_-]+)='([^']*)'%s*")

	local xmlAttributes = {}

	for k, v3 in v do
		xmlAttributes[k] = v3 or ""
	end

	for k, v3 in v2 do
		xmlAttributes[k] = v3 or ""
	end

	return xmlAttributes
end

return parseXmlAttributes
