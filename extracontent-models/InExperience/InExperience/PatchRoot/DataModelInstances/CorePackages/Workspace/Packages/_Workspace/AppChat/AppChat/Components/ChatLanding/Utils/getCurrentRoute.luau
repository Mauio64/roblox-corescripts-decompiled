return function(p)
	while p and p.index and p.routes do
		p = p.routes[p.index]
	end

	return p
end
