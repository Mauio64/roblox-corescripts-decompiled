local function consumeEntrySource(p2, p3)
	if not (p2 and p2.getParam) then
		return "watch_tab"
	end

	local param = p2.getParam("extraProps")

	if type(param) == "table" and type(param.source) == "string" then
		local formatted = `extraProps:{tostring(param)}:{param.source}`

		if not p3[formatted] then
			p3[formatted] = true
			return param.source
		end
	end

	local param2 = p2.getParam("source")

	if type(param2) ~= "string" then
		return "watch_tab"
	end

	local v5 = p2.state

	if type(v5) == "table" and v5.params ~= nil then
		v5 = v5.params
	end

	local formatted = `params:{tostring(v5)}:{param2}`

	if not p3[formatted] then
		p3[formatted] = true
		return param2
	end

	return "watch_tab"
end

return consumeEntrySource
