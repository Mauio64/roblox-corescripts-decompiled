local function equalObjects(...) -- line: 2
	local v2 = select(1, ...)

	for i = 2, select("#", ...) do
		if v2 ~= select(i, ...) then
			return false
		end
	end

	return true
end

return equalObjects
