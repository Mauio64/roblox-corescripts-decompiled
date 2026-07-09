local function createMockPromise(b1: boolean, p1) -- line: 6
	return {
		await = function() -- line: 8
			-- upvalues: b1 (copy), p1 (copy)
			return b1, p1
		end,
		andThen = function(p2, p3) -- line: 11
			-- upvalues: b1 (copy), p1 (copy)
			if b1 then
				p3(p1)
			end

			return p2
		end,
		catch = function(p4, p5) -- line: 17
			-- upvalues: b1 (copy), p1 (copy)
			if not b1 then
				p5(p1)
			end

			return p4
		end
	}
end

return createMockPromise
