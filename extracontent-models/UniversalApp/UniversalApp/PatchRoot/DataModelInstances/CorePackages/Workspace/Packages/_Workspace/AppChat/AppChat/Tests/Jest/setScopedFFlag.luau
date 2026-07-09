local Parent = script:FindFirstAncestor("AppChat").Parent
local JestGlobals = require(Parent.Dev.JestGlobals)
local afterAll = JestGlobals.afterAll
local beforeAll = JestGlobals.beforeAll

return function(p1, p2) -- line: 7
	-- upvalues: beforeAll (copy), afterAll (copy)
	local u7 = nil

	beforeAll(function() -- line: 9
		-- upvalues: u7 (ref), p1 (copy), p2 (copy)
		u7 = game:SetFastFlagForTesting(p1, p2)
	end)
	afterAll(function() -- line: 12
		-- upvalues: p1 (copy), u7 (ref)
		game:SetFastFlagForTesting(p1, u7)
	end)
end
