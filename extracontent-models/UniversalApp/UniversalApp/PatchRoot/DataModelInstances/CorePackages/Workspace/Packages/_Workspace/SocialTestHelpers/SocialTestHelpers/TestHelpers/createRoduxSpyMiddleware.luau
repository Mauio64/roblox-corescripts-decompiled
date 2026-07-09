local function createRoduxSpyMiddleware(p1) -- line: 1
	return function(p2) -- line: 2
		-- upvalues: p1 (copy)
		return function(p3) -- line: 3
			-- upvalues: p1 (copy), p2 (copy)
			p1(p3)

			return p2(p3)
		end
	end
end

return createRoduxSpyMiddleware
