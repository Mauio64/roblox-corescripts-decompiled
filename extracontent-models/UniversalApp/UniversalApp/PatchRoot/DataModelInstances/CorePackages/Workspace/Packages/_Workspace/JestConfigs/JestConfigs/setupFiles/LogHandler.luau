local LogService = game:GetService("LogService")
local Parent = script:FindFirstAncestor("JestConfigs").Parent
local JestGlobals = require(Parent.JestGlobals)
local jest = JestGlobals.jest
local beforeAll = JestGlobals.beforeAll
local afterAll = JestGlobals.afterAll
local expect = JestGlobals.expect
local u8 = false
local u9 = nil
local t1 = {
	"Script has run for over .* seconds and may timeout",
	"Child element received a \"key\" prop .* in addition to a key in the \"children\" table"
}

local function isIgnoredWarning(s1: string) -- line: 22
	-- upvalues: t1 (copy)
	for _, v14 in t1 do
		if string.find(s1, v14) then
			return true
		end
	end

	return false
end

beforeAll(function() -- line: 31
	-- upvalues: expect (copy), LogService (copy), t1 (copy), u8 (ref), u9 (ref)
	expect.extend({
		toHaveNoOutput = function(_, p2, p3) -- line: 33
			if p2 then
				return {
					pass = false,
					message = function() -- line: 37
						-- upvalues: p3 (copy)
						return `Has hit an error or warning message: { p3 }`
					end
				}
			end

			return {
				pass = true,
				message = function() -- line: 44
					return "Expected an error or warning message"
				end
			}
		end
	})
	LogService.MessageOut:Connect(function(p4, p5) -- line: 52
		-- upvalues: t1 (copy), u8 (ref), u9 (ref)
		if p5 == Enum.MessageType.MessageError or p5 == Enum.MessageType.MessageWarning then
			if p5 == Enum.MessageType.MessageWarning then
				local g23 = nil
				local v22 = nil

				for _, v21 in t1 do
					if string.find(p4, v21) then
						v22 = true
						g23 = true
					end

					if g23 then
						break
					end
				end

				if not g23 then
					v22 = false
				end

				g23 = false

				if v22 then
					return
				end
			end

			u8 = true
			u9 = p4
		end
	end)
end)
afterAll(function() -- line: 63
	-- upvalues: jest (copy), expect (copy), u8 (ref), u9 (ref)
	jest.useRealTimers()
	task.wait()
	expect(u8).toHaveNoOutput(u9)
end)
