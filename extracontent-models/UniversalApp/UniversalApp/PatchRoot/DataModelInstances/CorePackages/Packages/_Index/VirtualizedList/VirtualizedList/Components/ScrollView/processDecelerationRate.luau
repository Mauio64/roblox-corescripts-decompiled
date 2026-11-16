local function processDecelerationRate(p)
	if p == "normal" then
		return 0.985
	elseif p == "fast" then
		return 0.9
	end

	return p
end

return processDecelerationRate
