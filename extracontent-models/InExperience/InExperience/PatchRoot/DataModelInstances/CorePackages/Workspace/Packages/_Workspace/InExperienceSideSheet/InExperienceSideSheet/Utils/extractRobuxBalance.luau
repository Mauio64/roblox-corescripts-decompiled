local function extractRobuxBalance(p)
	if typeof(p) == "table" then
		local robux = p.robux or p.Robux

		if typeof(robux) == "number" then
			return robux
		end
	end

	return nil
end

return extractRobuxBalance
