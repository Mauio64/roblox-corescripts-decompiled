local t1 = {}
local ParentParent = script.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object
local Tracing = require(script.Parent.Tracing)
local enableSchedulerTracing = require(ParentParent.Shared).ReactFeatureFlags.enableSchedulerTracing
local __subscriberRef = Tracing.__subscriberRef
local t2 = {}

if enableSchedulerTracing then
	t2 = {}
end

function t1.unstable_subscribe(p1) -- line: 30
	-- upvalues: enableSchedulerTracing (copy), t2 (ref), Object (copy), __subscriberRef (copy)
	if enableSchedulerTracing then
		t2[p1] = true

		if #Object.keys(t2) == 1 then
			__subscriberRef.current = {
				onInteractionScheduledWorkCompleted = onInteractionScheduledWorkCompleted,
				onInteractionTraced = onInteractionTraced,
				onWorkCanceled = onWorkCanceled,
				onWorkScheduled = onWorkScheduled,
				onWorkStarted = onWorkStarted,
				onWorkStopped = onWorkStopped
			}
		end
	end
end
function t1.unstable_unsubscribe(p2) -- line: 47
	-- upvalues: enableSchedulerTracing (copy), t2 (ref), Object (copy), __subscriberRef (copy)
	if enableSchedulerTracing then
		t2[p2] = nil

		if #Object.keys(t2) == 0 then
			__subscriberRef.current = nil
		end
	end
end
function onInteractionTraced(p3) -- line: 57
	-- upvalues: t2 (ref)
	local v11 = false
	local v12 = nil

	for v13, _ in t2 do
		local ok, result = pcall(v13.onInteractionTraced, p3)

		if not ok and not v11 then
			v11 = true
			v12 = result
		end
	end

	if v11 then
		error(v12)
	end
end
function onInteractionScheduledWorkCompleted(p4) -- line: 79
	-- upvalues: t2 (ref)
	local v18 = false
	local v19 = nil

	for v20, _ in t2 do
		local ok, result = pcall(v20.onInteractionScheduledWorkCompleted, p4)

		if not ok and not v18 then
			v18 = true
			v19 = result
		end
	end

	if v18 then
		error(v19)
	end
end
function onWorkScheduled(t3: {[any]: any}, n1: number) -- line: 102
	-- upvalues: t2 (ref)
	local v26 = false
	local v27 = nil

	for v28, _ in t2 do
		local ok, result = pcall(v28.onWorkScheduled, t3, n1)

		if not ok and not v26 then
			v26 = true
			v27 = result
		end
	end

	if v26 then
		error(v27)
	end
end
function onWorkStarted(t4: {[any]: any}, n2: number) -- line: 124
	-- upvalues: t2 (ref)
	local v34 = false
	local v35 = nil

	for v36, _ in t2 do
		local ok, result = pcall(v36.onWorkStarted, t4, n2)

		if not ok and not v34 then
			v34 = true
			v35 = result
		end
	end

	if v34 then
		error(v35)
	end
end
function onWorkStopped(t5: {[any]: any}, n3: number) -- line: 146
	-- upvalues: t2 (ref)
	local v42 = false
	local v43 = nil

	for v44, _ in t2 do
		local ok, result = pcall(v44.onWorkStopped, t5, n3)

		if not ok and not v42 then
			v42 = true
			v43 = result
		end
	end

	if v42 then
		error(v43)
	end
end
function onWorkCanceled(t6: {[any]: any}, n4: number) -- line: 168
	-- upvalues: t2 (ref)
	local v50 = false
	local v51 = nil

	for v52, _ in t2 do
		local ok, result = pcall(v52.onWorkCanceled, t6, n4)

		if not ok and not v50 then
			v50 = true
			v51 = result
		end
	end

	if v50 then
		error(v51)
	end
end

return t1
