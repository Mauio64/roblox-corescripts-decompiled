return function(list): boolean
	if typeof(list) ~= "table" then
		return false
	end

	if next(list) == nil then
		return true
	end

	if #list == 0 then
		return false
	end

	local count = 0
	local total = 0

	for k in pairs(list) do
		if typeof(k) ~= "number" or (k % 1 ~= 0 or k < 1) then
			return false
		end

		count += 1
		total += k
	end

	return total == count * (count + 1) / 2
end
