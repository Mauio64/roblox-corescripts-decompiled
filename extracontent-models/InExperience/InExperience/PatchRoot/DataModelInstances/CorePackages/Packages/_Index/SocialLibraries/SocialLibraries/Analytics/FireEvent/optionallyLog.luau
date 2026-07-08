require(script.Parent.Types)

return function(p1, p2: ((...any) -> ...any)) -- line: 4
	return function(s1: string) -- line: 5
		-- upvalues: p1 (copy), p2 (copy)
		if p1 then
			p1:info(p2(s1))
		end

		return s1
	end
end
