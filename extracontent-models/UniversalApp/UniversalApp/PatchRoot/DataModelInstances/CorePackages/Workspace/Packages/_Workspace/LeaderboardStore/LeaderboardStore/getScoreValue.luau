local function getScoreValue(p1) -- line: 1
	if typeof(p1) == "boolean" then
		if p1 then
			return 1
		end

		return 0
	end

	return p1
end

return getScoreValue
