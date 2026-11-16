local function consumeEntrySource(p, p2)
	if not (p and p.getParam) then
		return "watch_tab"
	end

	local param = p.getParam("extraProps")

	if type(param) == "table" and type(param.source) == "string" then
		local formatted = `extraProps:{tostring(param)}:{param.source}`

		if not p2[formatted] then
			p2[formatted] = true
			return param.source
		end
	end

	local param2 = p.getParam("source")

	if type(param2) ~= "string" then
		return "watch_tab"
	end

	local v = p.state

	if type(v) == "table" and v.params ~= nil then
		v = v.params
	end

	local formatted = `params:{tostring(v)}:{param2}`

	if not p2[formatted] then
		p2[formatted] = true
		return param2
	end

	return "watch_tab"
end

return consumeEntrySource
