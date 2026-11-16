local parent = script.Parent.Parent

return function(p, p2)
	if not (p2 and p.PremiumPriceInRobux ~= nil) then
		return p.PriceInRobux or 0
	end

	return p.PremiumPriceInRobux
end
