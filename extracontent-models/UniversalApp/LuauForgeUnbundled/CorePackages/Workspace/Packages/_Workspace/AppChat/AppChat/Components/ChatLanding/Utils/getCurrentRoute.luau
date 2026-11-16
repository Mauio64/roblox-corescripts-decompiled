return function(p2)
	while p2 and p2.index and p2.routes do
		p2 = p2.routes[p2.index]
	end

	return p2
end
