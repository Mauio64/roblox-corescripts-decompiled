local function getScoreValue(p)
	if typeof(p) ~= "boolean" then
		return p
	end

	return if p then 1 else 0
end

return getScoreValue
