return function(p1, s1: string) -- line: 19
	for _, v in ipairs(s1:split(".")) do
		if not p1[v] then
			return nil
		end

		p1 = p1[v]
	end

	return p1
end
