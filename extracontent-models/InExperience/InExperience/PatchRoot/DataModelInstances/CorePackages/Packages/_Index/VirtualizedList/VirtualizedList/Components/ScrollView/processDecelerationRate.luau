local function processDecelerationRate(p1) -- line: 16
	if p1 == "normal" then
		return 0.985
	end

	if p1 == "fast" then
		return 0.9
	end

	return p1
end

return processDecelerationRate
