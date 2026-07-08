local Parent = script:FindFirstAncestor("MarkdownCore").Parent
local JestGlobals = require(Parent.Dev.JestGlobals)
local beforeAll = JestGlobals.beforeAll
local expect = JestGlobals.expect
local jest = JestGlobals.jest

local function toWarnWith(_, p2, p3) -- line: 7
	-- upvalues: jest (copy), expect (copy)
	local u11 = false
	local s1 = ""
	local v13 = jest.spyOn(jest.globalEnv, "warn").mockImplementation(function(p4) -- line: 10
		-- upvalues: expect (copy), p3 (copy), u11 (ref), s1 (ref)
		print("WARN", p4)

		local ok, result = pcall(function() -- line: 12
			-- upvalues: expect (copy), p4 (copy), p3 (copy)
			expect(p4).toEqual(p3)
		end)

		if ok then
			u11 = true
			s1 = result
		end
	end)
	local ok, result = pcall(p2)

	if not ok then
		v13:mockRestore()
		error(result)
	end

	local v16 = not u11 and function() -- line: 33
		-- upvalues: p3 (copy)
		return `Expected to warn with string containing "{ p3 }" but did not find a match`
	end or function() -- line: 29
		-- upvalues: p3 (copy), s1 (ref)
		return `Expected never to warn with string containing "{ p3 }" but got "{ s1 }"`
	end

	v13:mockRestore()

	return {
		message = v16,
		pass = u11
	}
end
local function toWarn(_, p6) -- line: 44
	-- upvalues: jest (copy)
	local n1 = 0
	local v20 = jest.spyOn(jest.globalEnv, "warn").mockImplementation(function(p7) -- line: 46
		-- upvalues: n1 (ref)
		print("WARN", p7)
		n1 += 1
	end)
	local ok, result = pcall(p6)

	if not ok then
		v20:mockRestore()
		error(result)
	end

	local v23 = not (n1 > 0) and function() -- line: 63
		return "Expected to warn but never did"
	end or function() -- line: 59
		-- upvalues: n1 (ref)
		return `Expected never to warn but got { n1 } warnings`
	end

	v20:mockRestore()

	return {
		message = v23,
		pass = n1 > 0
	}
end

beforeAll(function() -- line: 75
	-- upvalues: expect (copy), toWarnWith (copy), toWarn (copy)
	expect.extend({
		toWarnWith = toWarnWith,
		toWarn = toWarn
	})
end)
