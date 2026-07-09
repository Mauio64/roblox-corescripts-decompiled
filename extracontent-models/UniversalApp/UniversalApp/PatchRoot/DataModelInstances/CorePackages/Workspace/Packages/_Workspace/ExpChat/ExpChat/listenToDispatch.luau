return function(p1) -- line: 1
	return function(p2) -- line: 2
		-- upvalues: p1 (copy)
		p1.Event:Connect(p2)
	end
end
