local LogService = game:GetService("LogService")
local Parent = script:FindFirstAncestor("ExperienceLoadingScript").Parent
local JestGlobals = require(Parent.Dev.JestGlobals)
local beforeAll = JestGlobals.beforeAll
local afterAll = JestGlobals.afterAll
local expect = JestGlobals.expect
local u7 = false

beforeAll(function() -- line: 13
	-- upvalues: LogService (copy), u7 (ref)
	LogService.MessageOut:Connect(function(_, p2) -- line: 14
		-- upvalues: u7 (ref)
		if p2 == Enum.MessageType.MessageError then
			u7 = true
		end
	end)
end)
afterAll(function() -- line: 21
	-- upvalues: expect (copy), u7 (ref)
	task.wait(0.2)
	expect(u7).toBe(false)
end)
