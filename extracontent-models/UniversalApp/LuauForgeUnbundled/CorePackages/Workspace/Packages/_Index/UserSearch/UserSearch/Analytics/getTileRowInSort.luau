return function(p2, p3, p4)
	if p2 and p3 and p4 and p4 ~= 0 then
		return p3 + math.ceil(p2 / p4) - 1
	end

	return nil
end
