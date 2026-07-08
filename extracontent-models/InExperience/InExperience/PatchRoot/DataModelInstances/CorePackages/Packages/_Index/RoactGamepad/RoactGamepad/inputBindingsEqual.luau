local function inputBindingsEqual(p1, p2) -- line: 1
	if p1 == p2 then
		return true
	end

	for k, v in pairs(p1) do
		local v6 = p2[k]

		if v6 == nil then
			return false
		end

		if v.kind ~= v6.kind or v.keyCode ~= v6.keyCode or v.action ~= v6.action then
			return false
		end

		local meta = v.meta
		local meta2 = v6.meta

		if meta == meta2 then
			continue
		end

		if typeof(meta) ~= "table" or typeof(meta2) ~= "table" then
			return false
		end

		for k2, v2 in pairs(meta) do
			if v2 ~= meta2[k2] then
				return false
			end
		end

		for k3 in pairs(meta2) do
			if meta[k3] == nil then
				return false
			end
		end
	end

	for k in pairs(p2) do
		if p1[k] == nil then
			return false
		end
	end

	return true
end

return inputBindingsEqual
