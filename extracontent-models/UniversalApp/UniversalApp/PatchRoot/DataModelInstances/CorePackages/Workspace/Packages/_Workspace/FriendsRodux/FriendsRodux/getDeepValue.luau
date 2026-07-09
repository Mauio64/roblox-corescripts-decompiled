return function(p1, p2) -- line: 19
	for _, v in ipairs(p2:split(".")) do
		if not p1[v] then
			return nil
		end

		p1 = p1[v]
	end

	return p1
end
