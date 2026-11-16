local function equalObjects(...): boolean
	local v = select(1, ...)

	for i = 2, select("#", ...) do
		if v ~= select(i, ...) then
			return false
		end
	end

	return true
end

return equalObjects
