local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local Object = require(ParentParent.LuauPolyfill).Object
local __DEV__ = ReactGlobals.__DEV__
local __YOLO__ = ReactGlobals.__YOLO__
local console = require(ParentParent.Shared).console

require(script.Parent.ReactInternalTypes)

local ReactFiberLane = require(script.Parent.ReactFiberLane)
local NoLane = ReactFiberLane.NoLane
local NoLanes = ReactFiberLane.NoLanes
local isSubsetOfLanes = ReactFiberLane.isSubsetOfLanes
local mergeLanes = ReactFiberLane.mergeLanes
local lib = nil

local function enterDisallowedContextReadInDEV() -- line: 115
	-- upvalues: lib (ref)
	if not lib then
		lib = require(script.Parent["ReactFiberNewContext.new"])
	end

	lib.enterDisallowedContextReadInDEV()
end
local function exitDisallowedContextReadInDEV() -- line: 121
	-- upvalues: lib (ref)
	if not lib then
		lib = require(script.Parent["ReactFiberNewContext.new"])
	end

	lib.exitDisallowedContextReadInDEV()
end

local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local Callback = ReactFiberFlags.Callback
local ShouldCapture = ReactFiberFlags.ShouldCapture
local DidCapture = ReactFiberFlags.DidCapture
local debugRenderPhaseSideEffectsForStrictMode = require(ParentParent.Shared).ReactFeatureFlags.debugRenderPhaseSideEffectsForStrictMode
local StrictMode = require(script.Parent.ReactTypeOfMode).StrictMode
local markSkippedUpdateLanes = require(script.Parent.ReactFiberWorkInProgress).markSkippedUpdateLanes
local describeError = require(ParentParent.Shared).describeError
local ConsolePatchingDev = require(ParentParent.Shared).ConsolePatchingDev
local disableLogs = ConsolePatchingDev.disableLogs
local reenableLogs = ConsolePatchingDev.reenableLogs
local t1 = {
	UpdateState = 0,
	ReplaceState = 1,
	ForceUpdate = 2,
	CaptureUpdate = 3
}
local u27 = false
local u28 = nil
local u29 = nil

if __DEV__ then
	u28 = false
	u29 = nil

	function t1.resetCurrentlyProcessingQueue() -- line: 181
		-- upvalues: u29 (ref)
		u29 = nil
	end
end

local t2 = table.create(210)
local n1 = 210

for i = 1, 210 do
	t2[i] = {
		eventTime = -1,
		lane = -1,
		tag = -1,
		payload = nil,
		callback = nil,
		next = nil
	}
end

function t1.initializeUpdateQueue(p1) -- line: 202
	p1.updateQueue = {
		firstBaseUpdate = nil,
		lastBaseUpdate = nil,
		effects = nil,
		baseState = p1.memoizedState,
		shared = {
			pending = nil
		}
	}
end
function t1.cloneUpdateQueue(p2, p3) -- line: 216
	local updateQueue = p3.updateQueue
	local updateQueue2 = p2.updateQueue

	if updateQueue == updateQueue2 then
		p3.updateQueue = table.clone(updateQueue2)
	end
end
function t1.createUpdate(n2: number, p4, p5, p6: ((...any) -> ...any)?) -- line: 230
	-- upvalues: n1 (ref), t2 (copy)
	if n1 > 0 then
		local v44 = t2[n1]

		t2[n1] = nil
		n1 -= 1
		v44.eventTime = n2
		v44.lane = p4
		v44.tag = 0
		v44.payload = p5
		v44.callback = p6

		return v44
	end

	return {
		tag = 0,
		next = nil,
		eventTime = n2,
		lane = p4,
		payload = p5,
		callback = p6
	}
end
function t1.enqueueUpdate(p7, p8) -- line: 280
	-- upvalues: __DEV__ (copy), u29 (ref), u28 (ref), console (copy)
	local updateQueue = p7.updateQueue

	if updateQueue == nil then
		return
	end

	local shared = updateQueue.shared
	local pending = shared.pending

	if pending == nil then
		p8.next = p8
	else
		p8.next = pending.next
		pending.next = p8
	end

	shared.pending = p8

	if __DEV__ and shared == u29 and not u28 then
		console.error("An update (setState, replaceState, or forceUpdate) was scheduled from inside an update function. Update functions should be pure, with zero side-effects. Consider using componentDidUpdate or a callback.")
		u28 = true
	end
end
function t1.enqueueCapturedUpdate(p9, p10) -- line: 312
	local updateQueue = p9.updateQueue
	local alternate = p9.alternate

	if alternate ~= nil then
		local updateQueue3 = alternate.updateQueue

		if updateQueue == updateQueue3 then
			local v55 = nil
			local v56 = nil
			local firstBaseUpdate = updateQueue.firstBaseUpdate

			if firstBaseUpdate ~= nil then
				repeat
					local t3 = {
						next = nil,
						eventTime = firstBaseUpdate.eventTime,
						lane = firstBaseUpdate.lane,
						tag = firstBaseUpdate.tag,
						payload = firstBaseUpdate.payload,
						callback = firstBaseUpdate.callback
					}

					if v56 == nil then
						v56 = t3
						v55 = t3
					else
						v56.next = t3
						v56 = t3
					end

					firstBaseUpdate = firstBaseUpdate.next
				until firstBaseUpdate == nil

				if v56 == nil then
					v55 = p10
				else
					v56.next = p10
				end
			else
				v55 = p10
			end

			p9.updateQueue = {
				baseState = updateQueue3.baseState,
				firstBaseUpdate = v55,
				lastBaseUpdate = p10,
				shared = updateQueue3.shared,
				effects = updateQueue3.effects
			}

			return
		end
	end

	local lastBaseUpdate = updateQueue.lastBaseUpdate

	if lastBaseUpdate == nil then
		updateQueue.firstBaseUpdate = p10
	else
		lastBaseUpdate.next = p10
	end

	updateQueue.lastBaseUpdate = p10
end

local function getStateFromUpdate(p11, _, p13, p14, p15, _) -- line: 393
	-- upvalues: __DEV__ (copy), lib (ref), debugRenderPhaseSideEffectsForStrictMode (copy), StrictMode (copy), disableLogs (copy), __YOLO__ (copy), describeError (copy), reenableLogs (copy), ShouldCapture (copy), DidCapture (copy), Object (copy), u27 (ref)
	local tag = p13.tag

	if tag == 1 then
		local payload = p13.payload

		if type(payload) == "function" then
			if __DEV__ then
				if not lib then
					lib = require(script.Parent["ReactFiberNewContext.new"])
				end

				lib.enterDisallowedContextReadInDEV()
			end

			local v68 = payload(p14, p15)

			if __DEV__ then
				if debugRenderPhaseSideEffectsForStrictMode and bit32.band(p11.mode, StrictMode) ~= 0 then
					disableLogs()

					local result = nil
					local ok

					if not __YOLO__ then
						ok, result = xpcall(payload, describeError, p14, p15)
					else
						ok = true
						payload(p14, p15)
					end

					reenableLogs()

					if not ok then
						error(result)
					end
				end

				if not lib then
					lib = require(script.Parent["ReactFiberNewContext.new"])
				end

				lib.exitDisallowedContextReadInDEV()
			end

			return v68
		end

		return payload
	end

	if tag == 3 or tag == 0 then
		if tag == 3 then
			p11.flags = bit32.bor(bit32.band(p11.flags, (bit32.bnot(ShouldCapture))), DidCapture)
		end

		local payload = p13.payload
		local v72

		if type(payload) == "function" then
			if __DEV__ then
				if not lib then
					lib = require(script.Parent["ReactFiberNewContext.new"])
				end

				lib.enterDisallowedContextReadInDEV()
			end

			v72 = payload(p14, p15)

			if __DEV__ then
				if debugRenderPhaseSideEffectsForStrictMode and bit32.band(p11.mode, StrictMode) ~= 0 then
					disableLogs()

					local result = nil
					local ok

					if not __YOLO__ then
						ok, result = xpcall(payload, describeError, p14, p15)
					else
						ok = true
						payload(p14, p15)
					end

					reenableLogs()

					if not ok then
						error(result)
					end
				end

				if not lib then
					lib = require(script.Parent["ReactFiberNewContext.new"])
				end

				lib.exitDisallowedContextReadInDEV()
			end
		else
			v72 = payload
		end

		if v72 == nil then
			return p14
		end

		return Object.assign({}, p14, v72)
	end

	if tag == 2 then
		u27 = true

		return p14
	end

	return p14
end

t1.getStateFromUpdate = getStateFromUpdate

function t1.processUpdateQueue(p17, p18, p19, p20) -- line: 502
	-- upvalues: u27 (ref), __DEV__ (copy), u29 (ref), NoLanes (copy), isSubsetOfLanes (copy), mergeLanes (copy), NoLane (copy), getStateFromUpdate (copy), Callback (copy), markSkippedUpdateLanes (copy)
	local updateQueue = p17.updateQueue

	u27 = false

	if __DEV__ then
		u29 = updateQueue.shared
	end

	local firstBaseUpdate = updateQueue.firstBaseUpdate
	local lastBaseUpdate = updateQueue.lastBaseUpdate
	local pending = updateQueue.shared.pending

	if pending ~= nil then
		updateQueue.shared.pending = nil

		local next = pending.next

		pending.next = nil

		if lastBaseUpdate == nil then
			firstBaseUpdate = next
		else
			lastBaseUpdate.next = next
		end

		local alternate = p17.alternate

		if alternate ~= nil then
			local updateQueue4 = alternate.updateQueue
			local lastBaseUpdate2 = updateQueue4.lastBaseUpdate

			if lastBaseUpdate2 ~= pending then
				if lastBaseUpdate2 == nil then
					updateQueue4.firstBaseUpdate = next
				else
					lastBaseUpdate2.next = next
				end

				updateQueue4.lastBaseUpdate = pending
			end
		end
	end

	if firstBaseUpdate ~= nil then
		local baseState = updateQueue.baseState
		local v88 = NoLanes
		local v89 = nil
		local v90 = nil
		local v91 = nil

		while true do
			repeat
				local lane = firstBaseUpdate.lane
				local eventTime = firstBaseUpdate.eventTime

				if not isSubsetOfLanes(p20, lane) then
					local t4 = {
						next = nil,
						eventTime = eventTime,
						lane = lane,
						tag = firstBaseUpdate.tag,
						payload = firstBaseUpdate.payload,
						callback = firstBaseUpdate.callback
					}

					if v91 == nil then
						v90 = t4
						v91 = t4
						v89 = baseState
					else
						v91.next = t4
						v91 = t4
					end

					v88 = mergeLanes(v88, lane)
				else
					if v91 ~= nil then
						local t5 = {
							next = nil,
							eventTime = eventTime,
							lane = NoLane,
							tag = firstBaseUpdate.tag,
							payload = firstBaseUpdate.payload,
							callback = firstBaseUpdate.callback
						}

						v91.next = t5
						v91 = t5
					end

					baseState = getStateFromUpdate(p17, updateQueue, firstBaseUpdate, baseState, p18, p19)

					if firstBaseUpdate.callback ~= nil and firstBaseUpdate.lane ~= NoLane then
						p17.flags = bit32.bor(p17.flags, Callback)

						local effects = updateQueue.effects

						if effects == nil then
							updateQueue.effects = { firstBaseUpdate }
						else
							table.insert(effects, firstBaseUpdate)
						end
					end
				end

				firstBaseUpdate = firstBaseUpdate.next
			until firstBaseUpdate == nil

			local pending2 = updateQueue.shared.pending

			if pending2 == nil then
				break
			end

			firstBaseUpdate = pending2.next
			pending2.next = nil
			updateQueue.lastBaseUpdate = pending2
			updateQueue.shared.pending = nil
		end

		if v91 == nil then
			v89 = baseState
		end

		updateQueue.baseState = v89
		updateQueue.firstBaseUpdate = v90
		updateQueue.lastBaseUpdate = v91
		markSkippedUpdateLanes(v88)
		p17.lanes = v88
		p17.memoizedState = baseState
	end

	if __DEV__ then
		u29 = nil
	end
end

local function callCallback(p21, p22) -- line: 694
	if type(p21) ~= "function" then
		error(string.format("Invalid argument passed as callback. Expected a function. Instead received: %s", (tostring(p21))))
	end

	p21(p22)
end

function t1.resetHasForceUpdateBeforeProcessing() -- line: 709
	-- upvalues: u27 (ref)
	u27 = false
end
function t1.checkHasForceUpdateAfterProcessing() -- line: 713
	-- upvalues: u27 (ref)
	return u27
end
function t1.commitUpdateQueue(_, p24, p25) -- line: 717
	-- upvalues: t2 (copy), n1 (ref)
	local effects = p24.effects

	p24.effects = nil

	if effects ~= nil then
		for _, v105 in effects do
			local callback = v105.callback

			if callback ~= nil then
				if type(callback) ~= "function" then
					error(string.format("Invalid argument passed as callback. Expected a function. Instead received: %s", (tostring(callback))))
				end

				callback(p25)
			end

			table.clear(v105)
			table.insert(t2, v105)
			n1 += 1
		end
	end
end

return t1
