local LogService = game:GetService("LogService")
local Parent = script:FindFirstAncestor("JestConfigs").Parent
local JestGlobals = require(Parent.JestGlobals)
local jest = JestGlobals.jest
local beforeAll = JestGlobals.beforeAll
local afterAll = JestGlobals.afterAll
local expect = JestGlobals.expect
local u8 = false
local u9 = nil

beforeAll(function() -- line: 15
	-- upvalues: expect (copy), LogService (copy), u8 (ref), u9 (ref)
	expect.extend({
		toHaveNoErrors = function(_, p2, p3) -- line: 17
			if p2 then
				return {
					pass = false,
					message = function() -- line: 21
						-- upvalues: p3 (copy)
						return `Has hit an error message: { p3 }`
					end
				}
			end

			return {
				pass = true,
				message = function() -- line: 28
					return "Expected an error message"
				end
			}
		end
	})
	LogService.MessageOut:Connect(function(p4, p5) -- line: 36
		-- upvalues: u8 (ref), u9 (ref)
		if p5 == Enum.MessageType.MessageError then
			u8 = true
			u9 = p4
		end
	end)
end)
afterAll(function() -- line: 44
	-- upvalues: jest (copy), expect (copy), u8 (ref), u9 (ref)
	jest.useRealTimers()
	task.wait()
	expect(u8).toHaveNoErrors(u9)
end)
