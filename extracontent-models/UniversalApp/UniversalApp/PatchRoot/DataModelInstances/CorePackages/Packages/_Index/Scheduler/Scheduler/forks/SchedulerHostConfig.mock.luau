local t1 = {}
local n1 = 0
local u3 = nil
local u4 = nil
local n2 = -1
local u6 = nil
local n3 = -1
local u8 = false
local u9 = false
local u10 = false
local u11 = false
local ParentParent = script.Parent.Parent.Parent
local console = require(ParentParent.Shared).console
local disabledLog = require(ParentParent.Shared).ConsolePatchingDev.disabledLog

function t1.requestHostCallback(p1: ((...any) -> ...any)) -- line: 28
	-- upvalues: u3 (ref)
	u3 = p1
end
function t1.cancelHostCallback() -- line: 32
	-- upvalues: u3 (ref)
	u3 = nil
end
function t1.requestHostTimeout(p2: ((...any) -> ...any), n4: number) -- line: 36
	-- upvalues: u4 (ref), n2 (ref), n1 (ref)
	u4 = p2
	n2 = n1 + n4
end
function t1.cancelHostTimeout() -- line: 41
	-- upvalues: u4 (ref), n2 (ref)
	u4 = nil
	n2 = -1
end
function t1.shouldYieldToHost() -- line: 46
	-- upvalues: u6 (ref), n3 (ref), u11 (ref), u10 (ref), u8 (ref)
	local v18 = u6

	if n3 ~= -1 and (v18 ~= nil and #v18 >= n3) or u11 and u10 then
		u8 = true

		return true
	end

	return false
end
function t1.getCurrentTime() -- line: 65
	-- upvalues: n1 (ref)
	return n1
end
function t1.forceFrameRate() -- line: 69
end
function t1.reset() -- line: 73
	-- upvalues: u9 (ref), n1 (ref), u3 (ref), u4 (ref), n2 (ref), u6 (ref), n3 (ref), u8 (ref), u10 (ref)
	if u9 then
		error("Cannot reset while already flushing work.")
	end

	n1 = 0
	u3 = nil
	u4 = nil
	n2 = -1
	u6 = nil
	n3 = -1
	u8 = false
	u9 = false
	u10 = false
end
function t1.unstable_flushNumberOfYields(n5: number) -- line: 90
	-- upvalues: u9 (ref), u3 (ref), n3 (ref), n1 (ref), u8 (ref)
	if u9 then
		error("Already flushing work.")
	end

	if u3 ~= nil then
		local v20 = u3

		n3 = n5
		u9 = true

		local ok, result = pcall(function() -- line: 100
			-- upvalues: v20 (copy), n1 (ref), u8 (ref), u3 (ref)
			local v34

			repeat
				v34 = v20(true, n1)
			until not v34 or u8

			if not v34 then
				u3 = nil
			end
		end)

		n3 = -1
		u8 = false
		u9 = false

		if not ok then
			error(result)
		end
	end
end
function t1.unstable_flushUntilNextPaint() -- line: 121
	-- upvalues: u9 (ref), u3 (ref), u11 (ref), u10 (ref), n1 (ref), u8 (ref)
	if u9 then
		error("Already flushing work.")
	end

	if u3 ~= nil then
		local v23 = u3

		u11 = true
		u10 = false
		u9 = true

		local ok, result = pcall(function() -- line: 132
			-- upvalues: v23 (copy), n1 (ref), u8 (ref), u3 (ref)
			local v35

			repeat
				v35 = v23(true, n1)
			until not v35 or u8

			if not v35 then
				u3 = nil
			end
		end)

		u11 = false
		u8 = false
		u9 = false

		if not ok then
			error(result)
		end
	end
end
function t1.unstable_flushExpired() -- line: 154
	-- upvalues: u9 (ref), u3 (ref), n1 (ref)
	if u9 then
		error("Already flushing work.")
	end

	if u3 ~= nil then
		u9 = true

		local ok, result = pcall(function() -- line: 160
			-- upvalues: u3 (ref), n1 (ref)
			if not u3(false, n1) then
				u3 = nil
			end
		end)

		u9 = false

		if not ok then
			error(result)
		end
	end
end
function t1.unstable_flushAllWithoutAsserting() -- line: 178
	-- upvalues: u9 (ref), u3 (ref), n1 (ref)
	if u9 then
		error("Already flushing work.")
	end

	if u3 ~= nil then
		local v28 = u3

		u9 = true

		local ok, result = pcall(function() -- line: 186
			-- upvalues: v28 (copy), n1 (ref), u3 (ref)
			local v36

			repeat
				v36 = v28(true, n1)
			until not v36

			if not v36 then
				u3 = nil
			end
		end)

		u9 = false

		if not ok then
			error(result)
		end

		return true
	end

	return false
end
function t1.unstable_clearYields() -- line: 209
	-- upvalues: u6 (ref)
	if u6 == nil then
		return {}
	end

	local v31 = u6

	u6 = nil

	return v31
end
function t1.unstable_flushAll() -- line: 218
	-- upvalues: u6 (ref), t1 (copy)
	if u6 ~= nil then
		error("Log is not empty. Assert on the log of yielded values before flushing additional work.")
	end

	t1.unstable_flushAllWithoutAsserting()

	if u6 ~= nil then
		error("While flushing work, something yielded a value. Use an assertion helper to assert on the log of yielded values, e.g. expect(Scheduler).toFlushAndYield([...])")
	end
end
function t1.unstable_yieldValue(p3) -- line: 235
	-- upvalues: console (copy), disabledLog (copy), u6 (ref)
	if console.log == disabledLog then
		return
	end

	if u6 == nil then
		u6 = { p3 }

		return
	end

	table.insert(u6, p3)
end
function t1.unstable_advanceTime(n6: number) -- line: 252
	-- upvalues: console (copy), disabledLog (copy), n1 (ref), u4 (ref), n2 (ref)
	if console.log == disabledLog then
		return
	end

	n1 += n6

	if u4 ~= nil and n2 <= n1 then
		u4(n1)
		n2 = -1
		u4 = nil
	end
end
function t1.requestPaint() -- line: 271
	-- upvalues: u10 (ref)
	u10 = true
end

return t1
