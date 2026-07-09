local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local JestGlobals = require(Parent.Dev.JestGlobals)
local beforeAll = JestGlobals.beforeAll
local expect = JestGlobals.expect
local CollisionMatchers2D = require(Parent.Dev.CollisionMatchers2D)

beforeAll(function() -- line: 9
	-- upvalues: expect (copy), CollisionMatchers2D (copy)
	expect.extend(CollisionMatchers2D.Jest)
end)
