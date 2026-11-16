require(script.Parent.Types)

return function(object)
	return function(p)
		object:reportCounter(p.name, p.count or 1)

		return p
	end
end
