local _ = script.Parent.Parent

return function(p1, p2) -- line: 5
	if p2 then
		if p1.PremiumPriceInRobux ~= nil then
			return p1.PremiumPriceInRobux
		end

		return p1.PriceInRobux or 0
	end

	return p1.PriceInRobux or 0
end
