return function(p, p2): boolean
	if p == p2 then
		return p ~= 0 or 1 / p == 1 / p2
	end

	return p ~= p and p2 ~= p2
end
