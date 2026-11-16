local parent = script:FindFirstAncestor("MarkdownCore").Parent
local JestGlobals = require(parent.Dev.JestGlobals)
local beforeAll = JestGlobals.beforeAll
local expect = JestGlobals.expect
local jest = JestGlobals.jest

local function toWarnWith(_, callback, p)
	local pass = false
	local v = ""
	local mockImplementation = jest.spyOn(jest.globalEnv, "warn").mockImplementation(function(p2)
		print("WARN", p2)
		local success, result = pcall(function()
			expect(p2).toEqual(p)
		end)

		if success then
			pass = true
			v = result
		end
	end)

	local success, result = pcall(callback)

	if not success then
		mockImplementation:mockRestore()
		error(result)
	end

	local fn = pass and function()
		return `Expected never to warn with string containing "{p}" but got "{v}"`
	end or function()
		return `Expected to warn with string containing "{p}" but did not find a match`
	end

	mockImplementation:mockRestore()
	return { message = fn, pass = pass }
end

local function toWarn(_, callback)
	local count = 0
	local mockImplementation = jest.spyOn(jest.globalEnv, "warn").mockImplementation(function(p)
		print("WARN", p)
		count += 1
	end)

	local success, result = pcall(callback)

	if not success then
		mockImplementation:mockRestore()
		error(result)
	end

	local fn = count > 0 and function()
		return `Expected never to warn but got {count} warnings`
	end or function(): string
		return "Expected to warn but never did"
	end

	mockImplementation:mockRestore()
	return {
		message = fn,
		pass = count > 0
	}
end

beforeAll(function()
	expect.extend({ toWarnWith = toWarnWith, toWarn = toWarn })
end)
