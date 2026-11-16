local function tryGetPathFromData(p2, list, value)
	if p2 == nil or list == nil then
		return false, nil
	end

	for i = value or 1, #list do
		local item = list[i]

		if p2 == nil then
			return false, nil
		end

		p2 = p2[item]
	end

	return p2 ~= nil, p2
end

return tryGetPathFromData
