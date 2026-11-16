local Mock = {}

local total = 0
local v = nil
local v2 = nil
local v3 = -1
local v4 = nil
local v5 = -1
local v6 = false
local flag = false
local v7 = false
local v8 = false
local parent = script.Parent.Parent.Parent
local Shared = require(parent.Shared)
local console = Shared.console
local Shared2 = require(parent.Shared)
local disabledLog = Shared2.ConsolePatchingDev.disabledLog

function Mock.requestHostCallback(callback)
	v = callback
end

function Mock.cancelHostCallback()
	v = nil
end

function Mock.requestHostTimeout(callback, p: number)
	v2 = callback
	v3 = total + p
end

function Mock.cancelHostTimeout()
	v2 = nil
	v3 = -1
end

function Mock.shouldYieldToHost(): boolean
	local v9 = v4

	if v5 == -1 or v9 == nil then
		if v8 and v7 then
			v6 = true
			return true
		end

		return false
	else
		local v10 = #v9

		if v5 <= v10 then
			v6 = true
			return true
		end

		if v8 and v7 then
			v6 = true
			return true
		end

		return false
	end
end

function Mock.getCurrentTime()
	return total
end

function Mock.forceFrameRate() end

function Mock.reset()
	if flag then
		error("Cannot reset while already flushing work.")
	end

	total = 0
	v = nil
	v2 = nil
	v3 = -1
	v4 = nil
	v5 = -1
	v6 = false
	flag = false
	v7 = false
end

function Mock.unstable_flushNumberOfYields(p: number)
	if flag then
		error("Already flushing work.")
	end

	if v ~= nil then
		local v9 = v
		v5 = p
		flag = true

		local success, result = pcall(function()
			local v10

			repeat
				v10 = v9(true, total)
			until not v10 or v6

			if not v10 then
				v = nil
			end
		end)

		v5 = -1
		v6 = false
		flag = false

		if not success then
			error(result)
		end
	end
end

function Mock.unstable_flushUntilNextPaint()
	if flag then
		error("Already flushing work.")
	end

	if v ~= nil then
		local v9 = v
		v8 = true
		v7 = false
		flag = true

		local success, result = pcall(function()
			local v10

			repeat
				v10 = v9(true, total)
			until not v10 or v6

			if not v10 then
				v = nil
			end
		end)

		v8 = false
		v6 = false
		flag = false

		if not success then
			error(result)
		end
	end
end

function Mock.unstable_flushExpired()
	if flag then
		error("Already flushing work.")
	end

	if v ~= nil then
		flag = true
		local success, result = pcall(function()
			if not v(false, total) then
				v = nil
			end
		end)

		flag = false

		if not success then
			error(result)
		end
	end
end

function Mock.unstable_flushAllWithoutAsserting(): boolean
	if flag then
		error("Already flushing work.")
	end

	if v == nil then
		return false
	end

	local v9 = v
	flag = true
	local success, result = pcall(function()
		local v10

		repeat
			v10 = v9(true, total)
		until not v10

		if not v10 then
			v = nil
		end
	end)

	flag = false

	if not success then
		error(result)
	end

	return true
end

function Mock.unstable_clearYields()
	if v4 == nil then
		return {}
	end

	local v9 = v4
	v4 = nil
	return v9
end

function Mock.unstable_flushAll()
	if v4 ~= nil then
		error("Log is not empty. Assert on the log of yielded values before flushing additional work.")
	end

	Mock.unstable_flushAllWithoutAsserting()

	if v4 ~= nil then
		error("While flushing work, something yielded a value. Use an assertion helper to assert on the log of yielded values, e.g. expect(Scheduler).toFlushAndYield([...])")
	end
end

function Mock.unstable_yieldValue(p)
	if console.log == disabledLog then
		return
	end

	if v4 == nil then
		v4 = { p }
	else
		table.insert(v4, p)
	end
end

function Mock.unstable_advanceTime(p: number)
	if console.log == disabledLog then
		return
	end

	total += p

	if v2 ~= nil and v3 <= total then
		v2(total)
		v3 = -1
		v2 = nil
	end
end

function Mock.requestPaint()
	v7 = true
end

return Mock
