local Parent = script:FindFirstAncestor("HttpRequest").Parent
local Cryo = require(Parent.Cryo)

return function(p1, p2, p3) -- line: 4
	-- upvalues: Cryo (copy)
	return {
		Start = function(_, p5) -- line: 6
			-- upvalues: p3 (copy), Cryo (copy), p1 (copy), p2 (copy)
			local t1 = {}

			if type(p3.mockResponse) == "function" then
				t1 = p3.mockResponse()
			elseif p3.mockResponse then
				t1 = p3.mockResponse
			end

			local v9 = Cryo.Dictionary.join({
				Url = p1,
				Method = p2
			}, t1)

			p5(p3.success, v9)
		end,
		Cancel = function() -- line: 21
			-- upvalues: p3 (copy)
			if p3.cancel then
				p3.cancel()
			end
		end
	}
end
