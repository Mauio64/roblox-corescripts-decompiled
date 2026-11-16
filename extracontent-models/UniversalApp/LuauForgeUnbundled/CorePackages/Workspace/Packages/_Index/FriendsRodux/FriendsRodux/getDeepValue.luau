return function(p2, value)
	for i, v5 in ipairs(value:split(".")) do
		if not p2[v5] then
			return nil
		end

		p2 = p2[v5]
	end

	return p2
end
