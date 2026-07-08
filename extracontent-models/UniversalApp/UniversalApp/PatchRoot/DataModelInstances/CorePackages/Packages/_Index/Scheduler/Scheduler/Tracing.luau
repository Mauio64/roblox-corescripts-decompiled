local ParentParent = script.Parent.Parent
local Set = require(ParentParent.LuauPolyfill).Set
local t1 = {}
local enableSchedulerTracing = require(ParentParent.Shared).ReactFeatureFlags.enableSchedulerTracing
local n1 = 0
local n2 = 0
local t2 = nil
local t3 = nil

if enableSchedulerTracing then
	t2 = {
		current = Set.new()
	}
	t3 = {
		current = nil
	}
end

t1.__interactionsRef = t2
t1.__subscriberRef = t3

function t1.unstable_clear(p1: ((...any) -> ...any)) -- line: 92
	-- upvalues: enableSchedulerTracing (copy), t2 (ref), Set (copy)
	if not enableSchedulerTracing then
		return p1()
	end

	local current = t2.current

	t2.current = Set.new()

	local ok, result = pcall(p1)

	t2.current = current

	if not ok then
		error(result)
	end

	return result
end
function t1.unstable_getCurrent() -- line: 112
	-- upvalues: enableSchedulerTracing (copy), t2 (ref)
	if not enableSchedulerTracing then
		return nil
	end

	return t2.current
end
function t1.unstable_getThreadID() -- line: 120
	-- upvalues: n2 (ref)
	n2 += 1

	return n2
end
function t1.unstable_trace(s1: string, n3: number, p2: ((...any) -> ...any), n4: number?) -- line: 125
	-- upvalues: enableSchedulerTracing (copy), n1 (ref), t2 (ref), Set (copy), t3 (ref)
	local v17 = n4 == nil and 0 or n4

	if not enableSchedulerTracing then
		return p2()
	end

	local t4 = {
		__count = 1,
		id = n1,
		name = s1,
		timestamp = n3
	}

	n1 += 1

	local current = t2.current
	local v20 = Set.new(current)

	v20:add(t4)
	t2.current = v20

	local current2 = t3.current
	local u22 = nil
	local ok, result = pcall(function() -- line: 159
		-- upvalues: current2 (copy), t4 (copy)
		if current2 ~= nil then
			current2.onInteractionTraced(t4)
		end
	end)
	local ok2, result2 = pcall(function() -- line: 166
		-- upvalues: current2 (copy), v20 (copy), v17 (copy)
		if current2 ~= nil then
			current2.onWorkStarted(v20, v17)
		end
	end)
	local ok3, result3 = pcall(function() -- line: 174
		-- upvalues: u22 (ref), p2 (copy)
		u22 = p2()
	end)

	t2.current = current

	local ok4, result4 = pcall(function() -- line: 180
		-- upvalues: current2 (copy), v20 (copy), v17 (copy)
		if current2 ~= nil then
			current2.onWorkStopped(v20, v17)
		end
	end)

	t4.__count = t4.__count - 1

	if current2 ~= nil and t4.__count == 0 then
		current2.onInteractionScheduledWorkCompleted(t4)
	end

	if not ok4 then
		error(result4)
	end

	if not ok3 then
		error(result3)
	end

	if not ok2 then
		error(result2)
	end

	if not ok then
		error(result)
	end

	return u22
end
function t1.unstable_wrap(p3: ((...any) -> ...any), n5: number) -- line: 213
	-- upvalues: enableSchedulerTracing (copy), t2 (ref), t3 (ref)
	if n5 == nil then
		n5 = 0
	end

	if not enableSchedulerTracing then
		return p3
	end

	local current = t2.current
	local current3 = t3.current

	if current3 ~= nil then
		current3.onWorkScheduled(current, n5)
	end

	for _, v37 in current do
		v37.__count = v37.__count + 1
	end

	local u38 = false

	local function _wrapped(_, ...) -- line: 241
		-- upvalues: t2 (ref), current (copy), current3 (ref), t3 (ref), n5 (ref), p3 (copy), u38 (ref)
		local current4 = t2.current

		t2.current = current
		current3 = t3.current

		local ok, result = pcall(function(...) -- line: 248
			-- upvalues: current3 (ref), current (copy), n5 (ref), p3 (copy), t2 (ref), current4 (copy)
			local u51 = nil
			local ok, result = pcall(function() -- line: 252
				-- upvalues: current3 (ref), current (copy), n5 (ref)
				if current3 ~= nil then
					current3.onWorkStarted(current, n5)
				end
			end)
			local ok5, result5 = pcall(function(...) -- line: 259
				-- upvalues: u51 (ref), p3 (copy)
				u51 = p3(...)
			end, ...)

			t2.current = current4

			if current3 ~= nil then
				current3.onWorkStopped(current, n5)
			end

			if not ok5 then
				error(result5)
			end

			if not ok then
				error(result)
			end

			return u51
		end, ...)

		if not u38 then
			u38 = true

			for _, v46 in current do
				v46.__count = v46.__count - 1

				if current3 ~= nil and v46.__count == 0 then
					current3.onInteractionScheduledWorkCompleted(v46)
				end
			end
		end

		if not ok then
			error(result)
		end

		return result
	end

	local t5 = {}

	setmetatable(t5, {
		__call = _wrapped
	})

	function t5.cancel() -- line: 306
		-- upvalues: current3 (ref), t3 (ref), current (copy), n5 (ref)
		current3 = t3.current

		local ok, result = pcall(function() -- line: 309
			-- upvalues: current3 (ref), current (copy), n5 (ref)
			if current3 ~= nil then
				current3.onWorkCanceled(current, n5)
			end
		end)

		for _, v50 in current do
			v50.__count = v50.__count - 1

			if current3 ~= nil and v50.__count == 0 then
				current3.onInteractionScheduledWorkCompleted(v50)
			end
		end

		if not ok then
			error(result)
		end
	end

	return t5
end

return t1
