return function(p1, s1: string) -- line: 17
	if not p1 then
		return nil
	end

	for _, v in ipairs(s1:split(".")) do
		if p1[v] == nil then
			return nil
		end

		p1 = p1[v]
	end

	return p1
end
