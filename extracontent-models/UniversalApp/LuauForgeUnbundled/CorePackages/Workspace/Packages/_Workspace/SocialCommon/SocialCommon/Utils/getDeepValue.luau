return function(p2, value)
	if not p2 then
		return nil
	end

	for i, v5 in ipairs(value:split(".")) do
		if p2[v5] == nil then
			return nil
		end

		p2 = p2[v5]
	end

	return p2
end
