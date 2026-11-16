return function(p, value: string)
	if not p then
		return nil
	end

	for _, v in ipairs(value:split(".")) do
		if p[v] == nil then
			return nil
		end

		p = p[v]
	end

	return p
end
