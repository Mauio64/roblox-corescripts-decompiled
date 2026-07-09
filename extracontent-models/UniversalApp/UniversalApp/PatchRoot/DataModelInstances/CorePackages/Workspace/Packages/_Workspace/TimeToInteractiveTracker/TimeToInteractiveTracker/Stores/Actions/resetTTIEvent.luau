require(script.Parent.Parent.types)

return function(p1) -- line: 7
	return function(s1: string) -- line: 8
		-- upvalues: p1 (copy)
		p1(function(p2) -- line: 9
			-- upvalues: s1 (copy)
			local v4 = p2[s1]

			if v4 == nil then
				return p2
			end

			local v5 = table.clone(p2)

			v5[s1] = {
				startTime = nil,
				endTime = nil,
				deltaMs = nil,
				sent = nil,
				metadata = table.clone(v4.metadata)
			}

			return v5
		end)
	end
end
