local function equalObjects(...) -- line: 2
	for i = 1, select("#", ...) - 1 do
		if select(i, ...) ~= select(i + 1, ...) then
			return false
		end
	end

	return true
end

return equalObjects
