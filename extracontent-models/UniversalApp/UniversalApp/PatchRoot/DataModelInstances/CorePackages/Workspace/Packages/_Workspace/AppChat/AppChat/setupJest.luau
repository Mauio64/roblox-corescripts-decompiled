local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local JestGlobals = require(AppChatParent.Dev.JestGlobals)
local afterAll = JestGlobals.afterAll
local beforeAll = JestGlobals.beforeAll
local expect = JestGlobals.expect
local CollisionMatchers2D = require(AppChatParent.Dev.CollisionMatchers2D)
local GlobalMocks = require(AppChat.Tests.GlobalMocks)

beforeAll(function() -- line: 11
	-- upvalues: expect (copy), CollisionMatchers2D (copy), GlobalMocks (copy)
	expect.extend(CollisionMatchers2D.Jest)
	GlobalMocks.setup()
end)
afterAll(function() -- line: 16
	-- upvalues: GlobalMocks (copy)
	GlobalMocks.teardown()
end)
