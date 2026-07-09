local Parent = script:FindFirstAncestor("AppChat").Parent

require(Parent.React)

local jest = require(Parent.Dev.JestGlobals).jest

return function(p1: ((...any) -> ...any)?) -- line: 8
	-- upvalues: jest (copy)
	local v4 = p1 or function(_) -- line: 9
		return nil
	end
	local v5, v6 = jest.fn(v4)

	return {
		component = v6,
		renderSpy = v5
	}
end
