return function(items)
	local count = 0

	for _ in pairs(items) do
		count += 1
	end

	return count
end
