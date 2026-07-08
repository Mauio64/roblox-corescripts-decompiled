local function createNextOrder() -- line: 2
	local n1 = 0

	return function() -- line: 5
		-- upvalues: n1 (ref)
		n1 += 1

		return n1
	end
end

return createNextOrder
