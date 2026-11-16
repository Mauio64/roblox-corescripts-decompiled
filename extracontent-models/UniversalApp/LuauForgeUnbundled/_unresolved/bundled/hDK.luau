return function(p2, p3, p4, p5)
	if not p2 then
		p2 = p3 == nil and p4 == nil and p5 == nil
	end

	return p2
end
