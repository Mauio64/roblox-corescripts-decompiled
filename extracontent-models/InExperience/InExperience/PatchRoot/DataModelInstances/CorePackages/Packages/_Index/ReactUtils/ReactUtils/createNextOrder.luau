local function createNextOrder()
	local count = 0

	return function()
		count += 1
		return count
	end
end

return createNextOrder
