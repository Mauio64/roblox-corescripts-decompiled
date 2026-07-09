local ParentParent = script.Parent.Parent
local jest = require(ParentParent.JestGlobals).jest

return {
	new = function(t1: {[any]: any}, s1: string) -- line: 13
		-- upvalues: jest (copy)
		local t2 = {}

		for v6, v7 in (t1.new()) do
			if type(v7) == "function" then
				t2[v6] = jest.fn()
			else
				t2[v6] = v7
			end
		end

		setmetatable(t2, {
			__tostring = function() -- line: 27
				-- upvalues: s1 (copy)
				return string.format("Service(%s)", s1)
			end
		})

		return {
			mockService = t2
		}
	end
}
