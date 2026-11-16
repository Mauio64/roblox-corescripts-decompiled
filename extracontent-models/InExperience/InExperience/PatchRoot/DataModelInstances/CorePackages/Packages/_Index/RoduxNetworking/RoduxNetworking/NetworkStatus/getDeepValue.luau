return function(p, value)
	for _, v in ipairs(value:split(".")) do
		if not p[v] then
			return nil
		end

		p = p[v]
	end

	return p
end
