local parent = script.Parent.Parent

return function(p, flag: boolean, p2: number?)
	if p2 and p2 > 0 then
		return p2
	end

	if not (flag and p.premiumPrice ~= nil) then
		return p.price
	end

	return p.premiumPrice
end
