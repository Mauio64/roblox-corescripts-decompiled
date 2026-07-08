local ParentParent = script.Parent.Parent
local getComponentName = require(ParentParent.Shared).getComponentName
local ReactWorkTags = require(script.Parent.ReactWorkTags)

require(script.Parent.ReactInternalTypes)

local ok, result = pcall(function() -- line: 29
	return game:DefineFastInt("ReactMicroprofilerLevel5", 0)
end)

if not ok then
	result = 0
end

function noop(...) -- line: 43
end

local u6 = false
local u7 = nil
local n1 = 0

if result >= 5 then
	game:GetService("RunService").Heartbeat:Connect(function() -- line: 52
		-- upvalues: n1 (ref)
		n1 = 0
	end)
end

local v9 = if not (result >= 5) then {
	profilebegin = noop,
	profileend = noop
} else {
	profilebegin = function(...) -- line: 59
		-- upvalues: n1 (ref)
		debug.profilebegin(...)
		n1 += 1
	end,
	profileend = function() -- line: 63
		-- upvalues: n1 (ref)
		if n1 > 0 then
			debug.profileend()
			n1 -= 1
		end
	end
}

function startTimerSampling(p1: ((...any) -> ...any)) -- line: 75
	-- upvalues: u6 (ref), u7 (ref)
	if u6 then
		warn("RobloxReactProfiling Timer Sampling already running.")
	end

	u6 = true
	u7 = p1
end
function endTimerSampling() -- line: 83
	-- upvalues: u6 (ref), u7 (ref)
	u6 = false
	u7 = nil
end
function getFirstStringKey(t1: {[any]: any}) -- line: 88
	for v12, _ in t1 do
		if type(v12) == "string" then
			return v12
		end
	end

	return nil
end
function startTimer(t2: {[any]: any}) -- line: 97
	-- upvalues: u6 (ref)
	if u6 then
		t2.startTime = os.clock()
	end
end
function endTimer(t3: {[any]: any}) -- line: 102
	-- upvalues: u6 (ref), u7 (ref)
	if u6 then
		t3.endTime = os.clock()

		if u7 then
			u7(t3)
		end
	end
end
function profileRootBeforeUnitOfWork(p2) -- line: 111
	-- upvalues: v9 (copy)
	local current = p2.current
	local v18 = nil

	if current then
		if current.memoizedProps then
			v18 = getFirstStringKey(current.memoizedProps)
		end

		if v18 == nil and current.stateNode and current.stateNode.containerInfo then
			v18 = current.stateNode.containerInfo.Name
		end
	end

	if v18 == "Folder" and current.child then
		local child = current.child
		local v20 = nil

		if child.memoizedProps then
			v20 = getFirstStringKey(child.memoizedProps)
		end

		if v20 == nil and child.stateNode and child.stateNode.containerInfo then
			v20 = child.stateNode.containerInfo.Name
		end

		if v20 ~= nil then
			v18 = v20
		end
	end

	if v18 ~= nil then
		local t4 = {
			startTime = 0,
			endTime = 0,
			id = v18
		}

		startTimer(t4)
		v9.profilebegin(v18)

		return t4
	end

	return nil
end
function profileRootAfterYielding(t5: {[any]: any}?) -- line: 165
	-- upvalues: v9 (copy)
	if t5 then
		endTimer(t5)
		v9.profileend()
	end
end
function profileUnitOfWorkBefore(p3) -- line: 172
	-- upvalues: getComponentName (copy), ReactWorkTags (copy), v9 (copy)
	local v24 = getComponentName(p3.type)

	if p3.key then
		v24 = tostring(p3.key) .. "=" .. (v24 or "?")
	end

	local v25 = nil

	if p3.stateNode and (p3.tag == ReactWorkTags.HostComponent or p3.tag == ReactWorkTags.HostText) then
		local LayerCollector = p3.stateNode:FindFirstAncestorWhichIsA("LayerCollector")

		if LayerCollector then
			v25 = "[" .. LayerCollector:GetFullName() .. "] "
		end
	end

	if v25 then
		v24 = v25 .. " : " .. (v24 or "?")
	end

	if v24 ~= nil then
		v9.profilebegin(v24)

		return true
	end

	return false
end
function profileUnitOfWorkAfter(b1: boolean) -- line: 205
	-- upvalues: v9 (copy)
	if b1 then
		v9.profileend()
	end
end
function profileCommitBefore() -- line: 211
	-- upvalues: v9 (copy)
	v9.profilebegin("Commit")
end
function profileCommitAfter() -- line: 214
	-- upvalues: v9 (copy)
	v9.profileend()
end

return {
	startTimerSampling = startTimerSampling,
	endTimerSampling = endTimerSampling,
	profileRootBeforeUnitOfWork = if not (result >= 1) then noop else profileRootBeforeUnitOfWork,
	profileRootAfterYielding = if not (result >= 1) then noop else profileRootAfterYielding,
	profileUnitOfWorkBefore = if not (result >= 10) then noop else profileUnitOfWorkBefore,
	profileUnitOfWorkAfter = if not (result >= 10) then noop else profileUnitOfWorkAfter,
	profileCommitBefore = if not (result >= 5) then noop else profileCommitBefore,
	profileCommitAfter = if not (result >= 5) then noop else profileCommitAfter
}
