local function makeHttpServiceMock(p1, p2) -- line: 1
	return {
		RequestInternal = function(_) -- line: 3
			-- upvalues: p1 (copy), p2 (copy)
			return {
				Start = function(_, p5) -- line: 5
					-- upvalues: p1 (copy), p2 (copy)
					p5(p1, p2)
				end
			}
		end
	}
end

return makeHttpServiceMock
