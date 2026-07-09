require(script.Parent.Parent.Types)

return function(p1, p2: ((...any) -> ...any)) -- line: 3
	return function(p3) -- line: 4
		-- upvalues: p1 (copy), p2 (copy)
		if p1 then
			p1:info(p2(p3))
		end

		return p3
	end
end
