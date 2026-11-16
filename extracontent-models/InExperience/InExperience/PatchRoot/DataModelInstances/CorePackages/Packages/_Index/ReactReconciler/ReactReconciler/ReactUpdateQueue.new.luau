local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local __DEV__ = ReactGlobals.__DEV__
local __YOLO__ = ReactGlobals.__YOLO__

local Shared = require(parent.Shared)
local console = Shared.console

require(script.Parent.ReactInternalTypes)

local ReactFiberLane = require(script.Parent.ReactFiberLane)
local NoLane = ReactFiberLane.NoLane
local NoLanes = ReactFiberLane.NoLanes
local isSubsetOfLanes = ReactFiberLane.isSubsetOfLanes
local mergeLanes = ReactFiberLane.mergeLanes

local v = nil

local function enterDisallowedContextReadInDEV() -- 2 equivalent calls inferred from this helper
	if not v then
		local ReactFiberNewContextnew = require(script.Parent["ReactFiberNewContext.new"])
		v = ReactFiberNewContextnew
	end

	v.enterDisallowedContextReadInDEV()
end
local function exitDisallowedContextReadInDEV() -- 2 equivalent calls inferred from this helper
	if not v then
		local ReactFiberNewContextnew = require(script.Parent["ReactFiberNewContext.new"])
		v = ReactFiberNewContextnew
	end

	v.exitDisallowedContextReadInDEV()
end
local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local Callback = ReactFiberFlags.Callback
local ShouldCapture = ReactFiberFlags.ShouldCapture
local DidCapture = ReactFiberFlags.DidCapture

local Shared2 = require(parent.Shared)
local ReactFeatureFlags = Shared2.ReactFeatureFlags

local debugRenderPhaseSideEffectsForStrictMode = ReactFeatureFlags.debugRenderPhaseSideEffectsForStrictMode
local enableAllocationTrims = ReactFeatureFlags.enableAllocationTrims

local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)
local StrictMode = ReactTypeOfMode.StrictMode

local ReactFiberWorkInProgress = require(script.Parent.ReactFiberWorkInProgress)
local markSkippedUpdateLanes = ReactFiberWorkInProgress.markSkippedUpdateLanes

local Shared3 = require(parent.Shared)
local describeError = Shared3.describeError

local Shared4 = require(parent.Shared)
local ConsolePatchingDev = Shared4.ConsolePatchingDev
local disableLogs = ConsolePatchingDev.disableLogs
local reenableLogs = ConsolePatchingDev.reenableLogs

local New = {}
New.UpdateState = 0
New.ReplaceState = 1
New.ForceUpdate = 2
New.CaptureUpdate = 3
local v2 = false
local v3, Shared5

if __DEV__ then
	v3 = false
	Shared5 = nil
	function New.resetCurrentlyProcessingQueue()
		Shared5 = nil
	end
else
	Shared5 = nil
	v3 = nil
end

local v4 = table.create(210)
local v5 = 210

for i = 1, 210 do
	v4[i] = {
		eventTime = -1,
		lane = -1,
		tag = -1,
		payload = nil,
		callback = nil,
		next = nil
	}
end

function New:initializeUpdateQueue()
	self.updateQueue = {
		baseState = self.memoizedState,
		firstBaseUpdate = nil,
		lastBaseUpdate = nil,
		shared = { pending = nil },
		effects = nil
	}
end

function New.cloneUpdateQueue(p, p2)
	local updateQueue = p2.updateQueue
	local updateQueue2 = p.updateQueue

	if updateQueue == updateQueue2 then
		p2.updateQueue = table.clone(updateQueue2)
	end
end

function New.createUpdate(eventTime: number, lane, payload, callback)
	if not (v5 > 0) then
		return {
			eventTime = eventTime,
			lane = lane,
			tag = 0,
			payload = payload,
			callback = callback,
			next = nil
		}
	end

	local v6 = v4[v5]
	v4[v5] = nil
	v5 -= 1

	v6.eventTime = eventTime
	v6.lane = lane
	v6.tag = 0
	v6.payload = payload
	v6.callback = callback

	return v6
end

function New.enqueueUpdate(p, p2)
	local updateQueue = p.updateQueue

	if updateQueue == nil then
		return
	end

	local Shared6 = updateQueue.shared
	local pending = Shared6.pending

	if pending == nil then
		p2.next = p2
	else
		p2.next = pending.next
		pending.next = p2
	end

	Shared6.pending = p2

	if __DEV__ and Shared5 == Shared6 and not v3 then
		console.error("An update (setState, replaceState, or forceUpdate) was scheduled from inside an update function. Update functions should be pure, with zero side-effects. Consider using componentDidUpdate or a callback.")

		v3 = true
	end
end

function New:enqueueCapturedUpdate(p)
	local updateQueue = self.updateQueue

	local alternate = self.alternate

	if alternate ~= nil then
		local updateQueue2 = alternate.updateQueue

		if updateQueue == updateQueue2 then
			local v6 = updateQueue.firstBaseUpdate
			local firstBaseUpdate

			if v6 == nil then
				firstBaseUpdate = p
			else
				local v7 = nil
				local nextNode

				while true do
					nextNode = {
						eventTime = v6.eventTime,
						lane = v6.lane,
						tag = v6.tag,
						payload = v6.payload,
						callback = v6.callback,
						next = nil
					}

					if v7 == nil then
						firstBaseUpdate = nextNode
					else
						v7.next = nextNode
					end

					v6 = v6.next

					if v6 == nil then
						break
					end

					v7 = nextNode
				end

				if nextNode == nil then
					firstBaseUpdate = p
				else
					nextNode.next = p
				end
			end

			self.updateQueue = {
				baseState = updateQueue2.baseState,
				firstBaseUpdate = firstBaseUpdate,
				lastBaseUpdate = p,
				shared = updateQueue2.shared,
				effects = updateQueue2.effects
			}
			return
		end
	end

	local lastBaseUpdate = updateQueue.lastBaseUpdate

	if lastBaseUpdate == nil then
		updateQueue.firstBaseUpdate = p
	else
		lastBaseUpdate.next = p
	end

	updateQueue.lastBaseUpdate = p
end

local function getStateFromUpdate(state, _, p, baseState, p2, _)
	local tag = p.tag

	if tag == 1 then
		local payload = p.payload

		if type(payload) ~= "function" then
			return payload
		end

		if __DEV__ then
			enterDisallowedContextReadInDEV() -- inferred equivalent call
		end

		local v6 = payload(baseState, p2)

		if not __DEV__ then
			return v6
		end

		if debugRenderPhaseSideEffectsForStrictMode and bit32.band(state.mode, StrictMode) ~= 0 then
			disableLogs()

			local result = nil
			local success

			if __YOLO__ then
				payload(baseState, p2)
				success = true
			else
				success, result = xpcall(payload, describeError, baseState, p2)
			end

			reenableLogs()

			if not success then
				error(result)
			end
		end

		exitDisallowedContextReadInDEV() -- inferred equivalent call
		return v6
	elseif tag == 3 or tag == 0 then
		if tag == 3 then
			state.flags = bit32.bor(bit32.band(state.flags, (bit32.bnot(ShouldCapture))), DidCapture)
		end

		local payload = p.payload
		local v6

		if type(payload) == "function" then
			if __DEV__ then
				enterDisallowedContextReadInDEV() -- inferred equivalent call
			end

			v6 = payload(baseState, p2)

			if __DEV__ then
				if debugRenderPhaseSideEffectsForStrictMode and bit32.band(state.mode, StrictMode) ~= 0 then
					disableLogs()

					local result = nil
					local success

					if __YOLO__ then
						payload(baseState, p2)
						success = true
					else
						success, result = xpcall(payload, describeError, baseState, p2)
					end

					reenableLogs()

					if not success then
						error(result)
					end
				end

				exitDisallowedContextReadInDEV() -- inferred equivalent call
			end
		else
			v6 = payload
		end

		if v6 == nil then
			return baseState
		end

		if not enableAllocationTrims then
			return Object.assign({}, baseState, v6)
		end

		local v7

		if type(baseState) == "table" and getmetatable(baseState) == nil then
			v7 = table.clone(baseState)
		else
			v7 = Object.assign({}, baseState)
		end

		return Object.assign(v7, v6)
	else
		if tag ~= 2 then
			return baseState
		end

		v2 = true
		return baseState
	end
end

New.getStateFromUpdate = getStateFromUpdate

function New:processUpdateQueue(p, p2, p3)
	local updateQueue = self.updateQueue

	v2 = false

	if __DEV__ then
		Shared5 = updateQueue.shared
	end

	local v6 = updateQueue.firstBaseUpdate
	local lastBaseUpdate = updateQueue.lastBaseUpdate

	local pending = updateQueue.shared.pending

	if pending ~= nil then
		updateQueue.shared.pending = nil

		local nextNode = pending.next
		pending.next = nil

		if lastBaseUpdate == nil then
			v6 = nextNode
		else
			lastBaseUpdate.next = nextNode
		end

		local alternate = self.alternate

		if alternate ~= nil then
			local updateQueue2 = alternate.updateQueue
			local lastBaseUpdate2 = updateQueue2.lastBaseUpdate

			if lastBaseUpdate2 ~= pending then
				if lastBaseUpdate2 == nil then
					updateQueue2.firstBaseUpdate = nextNode
				else
					lastBaseUpdate2.next = nextNode
				end

				updateQueue2.lastBaseUpdate = pending
			end
		end
	end

	if v6 ~= nil then
		local baseState = updateQueue.baseState

		local lanes = NoLanes
		local lastBaseUpdate2 = nil
		local baseState2 = nil
		local firstBaseUpdate = nil

		while true do
			local lane = v6.lane
			local eventTime = v6.eventTime

			if isSubsetOfLanes(p3, lane) then
				if lastBaseUpdate2 ~= nil then
					local nextNode = {
						eventTime = eventTime,
						lane = NoLane,
						tag = v6.tag,
						payload = v6.payload,
						callback = v6.callback,
						next = nil
					}

					lastBaseUpdate2.next = nextNode
					lastBaseUpdate2 = nextNode
				end

				baseState = getStateFromUpdate(self, updateQueue, v6, baseState, p, p2)

				if v6.callback ~= nil and v6.lane ~= NoLane then
					self.flags = bit32.bor(self.flags, Callback)
					local effects = updateQueue.effects

					if effects == nil then
						updateQueue.effects = { v6 }
					else
						table.insert(effects, v6)
					end
				end
			else
				local nextNode = {
					eventTime = eventTime,
					lane = lane,
					tag = v6.tag,
					payload = v6.payload,
					callback = v6.callback,
					next = nil
				}

				if lastBaseUpdate2 == nil then
					firstBaseUpdate = nextNode
					baseState2 = baseState
				else
					lastBaseUpdate2.next = nextNode
				end

				lanes = mergeLanes(lanes, lane)
				lastBaseUpdate2 = nextNode
			end

			v6 = v6.next

			if v6 ~= nil then
				continue
			end

			local pending2 = updateQueue.shared.pending

			if pending2 == nil then
				break
			end

			v6 = pending2.next

			pending2.next = nil

			updateQueue.lastBaseUpdate = pending2
			updateQueue.shared.pending = nil
		end

		if lastBaseUpdate2 == nil then
			baseState2 = baseState
		end

		updateQueue.baseState = baseState2
		updateQueue.firstBaseUpdate = firstBaseUpdate
		updateQueue.lastBaseUpdate = lastBaseUpdate2

		markSkippedUpdateLanes(lanes)
		self.lanes = lanes
		self.memoizedState = baseState
	end

	if __DEV__ then
		Shared5 = nil
	end
end

local function callCallback(callback, p) -- 1 equivalent call inferred from this helper
	if type(callback) ~= "function" then
		error(string.format(
			"Invalid argument passed as callback. Expected a function. Instead received: %s",
			(tostring(callback))
		))
	end

	callback(p)
end

function New.resetHasForceUpdateBeforeProcessing()
	v2 = false
end

function New.checkHasForceUpdateAfterProcessing()
	return v2
end

function New.commitUpdateQueue(_, p, p2)
	local effects = p.effects
	p.effects = nil

	if effects ~= nil then
		for _, list in effects do
			local callback = list.callback

			if callback ~= nil then
				callCallback(callback, p2) -- inferred equivalent call
			end

			table.clear(list)
			table.insert(v4, list)
			v5 += 1
		end
	end
end

return New
