local function tryGetPathFromData(p, list, value: number?)
	if p == nil or list == nil then
		return false, nil
	end

	for i = value or 1, #list do
		local item = list[i]

		if p == nil then
			return false, nil
		end

		p = p[item]
	end

	return p ~= nil, p
end

return tryGetPathFromData
