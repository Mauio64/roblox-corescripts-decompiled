local Parent = script:FindFirstAncestor("ExpChat").Parent
local beforeEach = require(Parent.Dev.JestGlobals3).beforeEach
local populateContext = require(script.Parent.Tests.populateContext)

beforeEach(function(p1) -- line: 7
	-- upvalues: populateContext (copy)
	populateContext(p1)
end)
