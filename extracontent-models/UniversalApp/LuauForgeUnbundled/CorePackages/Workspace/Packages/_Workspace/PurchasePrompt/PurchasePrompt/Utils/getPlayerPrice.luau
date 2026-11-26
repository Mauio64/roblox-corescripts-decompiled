return function(p2, p3, p4)
	if p4 and p4 > 0 then
		return p4
	end

	if not (p3 and p2.premiumPrice ~= nil) then
		return p2.price
	end

	return p2.premiumPrice
end
