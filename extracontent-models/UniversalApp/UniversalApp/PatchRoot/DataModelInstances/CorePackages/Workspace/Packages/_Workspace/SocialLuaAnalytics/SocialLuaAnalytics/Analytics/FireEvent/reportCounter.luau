require(script.Parent.Parent.Types)

return function(t1: {[any]: any}) -- line: 3
	return function(p1) -- line: 4
		-- upvalues: t1 (copy)
		t1:reportCounter(p1.name, p1.count or 1)

		return p1
	end
end
