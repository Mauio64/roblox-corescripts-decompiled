return function(p2, p3)
	if not (p3 and p2.PremiumPriceInRobux ~= nil) then
		return p2.PriceInRobux or 0
	end

	return p2.PremiumPriceInRobux
end
