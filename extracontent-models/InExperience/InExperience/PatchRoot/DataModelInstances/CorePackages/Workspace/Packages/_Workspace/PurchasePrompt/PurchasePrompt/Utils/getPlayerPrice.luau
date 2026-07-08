local _ = script.Parent.Parent

return function(t1: {[any]: any}, b1: boolean, n1: number?) -- line: 4
	if n1 and n1 > 0 then
		return n1
	end

	if b1 then
		if t1.premiumPrice ~= nil then
			return t1.premiumPrice
		end

		return t1.price
	end

	return t1.price
end
