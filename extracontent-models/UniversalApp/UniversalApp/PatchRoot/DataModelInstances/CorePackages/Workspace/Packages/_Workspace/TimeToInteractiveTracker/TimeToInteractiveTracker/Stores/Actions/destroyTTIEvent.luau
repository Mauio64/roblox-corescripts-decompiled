require(script.Parent.Parent.types)

return function(p1) -- line: 7
	return function(s1: string) -- line: 8
		-- upvalues: p1 (copy)
		p1(function(p2) -- line: 9
			-- upvalues: s1 (copy)
			if p2[s1] == nil then
				return p2
			end

			local v4 = table.clone(p2)

			v4[s1] = nil

			return v4
		end)
	end
end
