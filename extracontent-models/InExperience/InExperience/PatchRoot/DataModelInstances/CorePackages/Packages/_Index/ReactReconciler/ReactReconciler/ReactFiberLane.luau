local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
require(script.Parent.ReactInternalTypes)

local Shared = require(parent.Shared)
local console = Shared.console

local ReactFiberSchedulerPrioritiesroblox = require(script.Parent["ReactFiberSchedulerPriorities.roblox"])

local SafeFlags = require(parent.SafeFlags)
local v = SafeFlags.createGetFFlag("ReactInlineMergeLanes")()

local Shared2 = require(parent.Shared)
local invariant = Shared2.invariant

local ImmediatePriority = ReactFiberSchedulerPrioritiesroblox.ImmediatePriority
local UserBlockingPriority = ReactFiberSchedulerPrioritiesroblox.UserBlockingPriority
local NormalPriority = ReactFiberSchedulerPrioritiesroblox.NormalPriority
local LowPriority = ReactFiberSchedulerPrioritiesroblox.LowPriority
local IdlePriority = ReactFiberSchedulerPrioritiesroblox.IdlePriority
local NoPriority = ReactFiberSchedulerPrioritiesroblox.NoPriority

local ReactFiberLane = {}
ReactFiberLane.SyncLanePriority = 15
ReactFiberLane.SyncBatchedLanePriority = 14
ReactFiberLane.InputDiscreteLanePriority = 12
ReactFiberLane.InputContinuousLanePriority = 10
ReactFiberLane.DefaultLanePriority = 8
ReactFiberLane.TransitionPriority = 6
ReactFiberLane.NoLanePriority = 0
ReactFiberLane.NoLanes = 0
ReactFiberLane.NoLane = 0
ReactFiberLane.SyncLane = 1
ReactFiberLane.SyncBatchedLane = 2
ReactFiberLane.InputDiscreteHydrationLane = 4
ReactFiberLane.DefaultHydrationLane = 256
ReactFiberLane.DefaultLanes = 3584
ReactFiberLane.RetryLanes = 62914560
ReactFiberLane.SomeRetryLane = 33554432
ReactFiberLane.SelectiveHydrationLane = 67108864
ReactFiberLane.IdleHydrationLane = 134217728
ReactFiberLane.OffscreenLane = 1073741824
ReactFiberLane.NoTimestamp = -1
local v2 = ReactFiberLane.NoLanePriority

function ReactFiberLane.getCurrentUpdateLanePriority()
	return v2
end

function ReactFiberLane.setCurrentUpdateLanePriority(p)
	v2 = p
end

local v3 = ReactFiberLane.DefaultLanePriority

local function getHighestPriorityLanes(p)
	if bit32.band(1, p) ~= 0 then
		v3 = 15
		return 1
	end

	if bit32.band(2, p) ~= 0 then
		v3 = 14
		return 2
	end

	if bit32.band(4, p) ~= 0 then
		v3 = 13
		return 4
	end

	local v4 = bit32.band(24, p)

	if v4 ~= 0 then
		v3 = 12
		return v4
	end

	if bit32.band(p, 32) ~= 0 then
		v3 = 11
		return 32
	end

	local v5 = bit32.band(192, p)

	if v5 ~= 0 then
		v3 = 10
		return v5
	end

	if bit32.band(p, 256) ~= 0 then
		v3 = 9
		return 256
	end

	local v6 = bit32.band(3584, p)

	if v6 ~= 0 then
		v3 = 8
		return v6
	end

	if bit32.band(p, 4096) ~= 0 then
		v3 = 7
		return 4096
	end

	local v7 = bit32.band(4186112, p)

	if v7 ~= 0 then
		v3 = 6
		return v7
	end

	local v8 = bit32.band(62914560, p)

	if v8 ~= 0 then
		v3 = 5
		return v8
	end

	if bit32.band(p, 67108864) ~= 0 then
		v3 = 4
		return 67108864
	end

	if bit32.band(p, 134217728) ~= 0 then
		v3 = 3
		return 134217728
	end

	local v9 = bit32.band(805306368, p)

	if v9 ~= 0 then
		v3 = 2
		return v9
	end

	if bit32.band(1073741824, p) ~= 0 then
		v3 = 1
		return 1073741824
	end

	if ReactGlobals.__DEV__ then
		console.error("Should have found matching lanes. This is a bug in React.")
	end

	v3 = 8
	return p
end

function ReactFiberLane.schedulerPriorityToLanePriority(p): number
	if p == ImmediatePriority then
		return 15
	end

	if p == UserBlockingPriority then
		return 10
	end

	if p == NormalPriority or p == LowPriority then
		return 8
	end

	return if p == IdlePriority then 2 else 0
end

function ReactFiberLane.lanePriorityToSchedulerPriority(p)
	if p == 15 or p == 14 then
		return ImmediatePriority
	end

	if p == 13 or p == 12 or p == 11 or p == 10 then
		return UserBlockingPriority
	end

	if p == 9 or p == 8 or p == 7 or p == 6 or p == 4 or p == 5 then
		return NormalPriority
	end

	if p == 3 or p == 2 or p == 1 then
		return IdlePriority
	end

	if p == 0 then
		return NoPriority
	end

	invariant(false, "Invalid update priority: %s. This is a bug in React.", p)

	error("unreachable")
end

local pickArbitraryLaneIndex
local getLowestPriorityLane

function ReactFiberLane.getNextLanes(data, p)
	local pendingLanes = data.pendingLanes

	if pendingLanes == 0 then
		v3 = 0
		return 0
	end

	local v4 = 0
	local v5 = 0

	local expiredLanes = data.expiredLanes
	local suspendedLanes = data.suspendedLanes
	local pingedLanes = data.pingedLanes

	if expiredLanes == 0 then
		local v6 = bit32.band(pendingLanes, 134217727)

		if v6 == 0 then
			local v7 = bit32.band(pendingLanes, (bit32.bnot(suspendedLanes)))

			if v7 == 0 then
				if pingedLanes ~= 0 then
					v4 = getHighestPriorityLanes(pingedLanes)
					v5 = v3
				end
			else
				v4 = getHighestPriorityLanes(v7)
				v5 = v3
			end
		else
			local v7 = bit32.band(v6, (bit32.bnot(suspendedLanes)))

			if v7 == 0 then
				local v8 = bit32.band(v6, pingedLanes)

				if v8 ~= 0 then
					v4 = getHighestPriorityLanes(v8)
					v5 = v3
				end
			else
				v4 = getHighestPriorityLanes(v7)
				v5 = v3
			end
		end
	else
		v3 = 15
		v4 = expiredLanes
		v5 = 15
	end

	if v4 == 0 then
		return 0
	end

	local v6 = bit32.band(pendingLanes, bit32.lshift(getLowestPriorityLane(v4), 1) - 1)

	if p ~= 0 and p ~= v6 and bit32.band(p, suspendedLanes) == 0 then
		getHighestPriorityLanes(p)

		if v5 <= v3 then
			return p
		end

		v3 = v5
	end

	local entangledLanes = data.entangledLanes

	if entangledLanes == 0 then
		return v6
	end

	local entanglements = data.entanglements
	local v7 = bit32.band(v6, entangledLanes)

	while v7 > 0 do
		local v8 = pickArbitraryLaneIndex(v7)
		local v9 = bit32.lshift(1, v8)

		v6 = bit32.bor(v6, entanglements[v8])

		v7 = bit32.band(v7, (bit32.bnot(v9)))
	end

	return v6
end

function ReactFiberLane.getMostRecentEventTime(p, p2)
	local eventTimes = p.eventTimes
	local mostRecentEventTime = -1

	while p2 > 0 do
		local v4 = pickArbitraryLaneIndex(p2)
		local v5 = bit32.lshift(1, v4)

		local eventTime = eventTimes[v4]

		if mostRecentEventTime < eventTime then
			mostRecentEventTime = eventTime
		end

		p2 = bit32.band(p2, (bit32.bnot(v5)))
	end

	return mostRecentEventTime
end

local function computeExpirationTime(p, p2: number) -- 1 equivalent call inferred from this helper
	getHighestPriorityLanes(p)
	local v4 = v3

	if v4 >= 10 then
		return p2 + 250
	end

	if v4 >= 6 then
		return p2 + 5000
	end

	return -1
end

ReactFiberLane.computeExpirationTime = computeExpirationTime

function ReactFiberLane:markStarvedLanesAsExpired(p: number)
	local pendingLanes = self.pendingLanes
	local suspendedLanes = self.suspendedLanes
	local pingedLanes = self.pingedLanes
	local expirationTimes = self.expirationTimes

	while pendingLanes > 0 do
		local v4 = pickArbitraryLaneIndex(pendingLanes)
		local v5 = bit32.lshift(1, v4)

		local expirationTime = expirationTimes[v4]

		if expirationTime == -1 then
			if bit32.band(v5, suspendedLanes) == 0 or bit32.band(v5, pingedLanes) ~= 0 then
				expirationTimes[v4] = computeExpirationTime(v5, p) -- inferred equivalent call
			end
		elseif expirationTime <= p then
			self.expiredLanes = bit32.bor(self.expiredLanes, v5)
		end

		pendingLanes = bit32.band(pendingLanes, (bit32.bnot(v5)))
	end
end

function ReactFiberLane.getHighestPriorityPendingLanes(p)
	return getHighestPriorityLanes(p.pendingLanes)
end

function ReactFiberLane.getLanesToRetrySynchronouslyOnError(p)
	local v4 = bit32.band(p.pendingLanes, 3221225471)

	if v4 ~= 0 then
		return v4
	end

	return if bit32.band(v4, 1073741824) == 0 then 0 else 1073741824
end

function ReactFiberLane.returnNextLanesPriority()
	return v3
end

function ReactFiberLane.includesNonIdleWork(p): boolean
	return bit32.band(p, 134217727) ~= 0
end

function ReactFiberLane.includesOnlyRetries(p): boolean
	return bit32.band(p, 62914560) == p
end

function ReactFiberLane.includesOnlyTransitions(p): boolean
	return bit32.band(p, 4186112) == p
end

local pickArbitraryLane
local function findUpdateLane(p, p2)
	if p ~= 0 then
		if p == 15 then
			return 1
		elseif p == 14 then
			return 2
		end

		if p == 12 then
			local v4 = pickArbitraryLane((bit32.band(24, (bit32.bnot(p2)))))

			if v4 == 0 then
				return findUpdateLane(10, p2)
			end

			return v4
		elseif p == 10 then
			local v4 = pickArbitraryLane((bit32.band(192, (bit32.bnot(p2)))))

			if v4 == 0 then
				return findUpdateLane(8, p2)
			end

			return v4
		elseif p == 8 then
			local v4 = pickArbitraryLane((bit32.band(3584, (bit32.bnot(p2)))))

			if v4 == 0 then
				v4 = pickArbitraryLane((bit32.band(4186112, (bit32.bnot(p2)))))

				if v4 == 0 then
					return (pickArbitraryLane(3584))
				end
			end

			return v4
		elseif p ~= 6 and p ~= 5 and p == 2 then
			local v4 = pickArbitraryLane((bit32.band(805306368, (bit32.bnot(p2)))))

			if v4 == 0 then
				return (pickArbitraryLane(805306368))
			end

			return v4
		end
	end

	invariant(false, "Invalid update priority: %s. This is a bug in React.", p)

	error("unreachable")
end
ReactFiberLane.findUpdateLane = findUpdateLane

function ReactFiberLane.findTransitionLane(p, p2)
	local transitionLane = pickArbitraryLane((bit32.band(4186112, (bit32.bnot(p2)))))

	if transitionLane == 0 then
		transitionLane = pickArbitraryLane((bit32.band(4186112, (bit32.bnot(p)))))

		if transitionLane == 0 then
			transitionLane = pickArbitraryLane(4186112)
		end
	end

	return transitionLane
end

function ReactFiberLane.findRetryLane(p)
	local retryLane = pickArbitraryLane((bit32.band(62914560, (bit32.bnot(p)))))

	if retryLane == 0 then
		retryLane = pickArbitraryLane(62914560)
	end

	return retryLane
end

local function getHighestPriorityLane(p) -- 1 equivalent call inferred from this helper
	return (bit32.band(p, -p))
end

getLowestPriorityLane = function(p)
	local v4 = 31 - bit32.countlz(p)

	if v4 < 0 then
		return 0
	end

	return (bit32.lshift(1, v4))
end

local function getEqualOrHigherPriorityLanes(p)
	return bit32.lshift(getLowestPriorityLane(p), 1) - 1
end

pickArbitraryLane = function(p)
	return getHighestPriorityLane(p) -- inferred equivalent call
end

ReactFiberLane.pickArbitraryLane = pickArbitraryLane

pickArbitraryLaneIndex = function(p)
	return 31 - bit32.countlz(p)
end

function ReactFiberLane.includesSomeLane(p, p2): boolean
	return bit32.band(p, p2) ~= 0
end

function ReactFiberLane.isSubsetOfLanes(p, p2): boolean
	return bit32.band(p, p2) == p2
end

local function mergeLanes(p, p2)
	return (bit32.bor(p, p2))
end

if v then
	mergeLanes = bit32.bor
end

ReactFiberLane.mergeLanes = mergeLanes

function ReactFiberLane.removeLanes(p, p2)
	return (bit32.band(p, (bit32.bnot(p2))))
end

function ReactFiberLane.laneToLanes(p)
	return p
end

function ReactFiberLane.higherPriorityLane(p, p2)
	if p == 0 or p2 == 0 then
		return if p == 0 then p2 else p
	else
		return if p < p2 then p else p2
	end
end

function ReactFiberLane.higherLanePriority(p, p2)
	return if p == 0 or not (p2 < p) then p2 else p
end

function ReactFiberLane.createLaneMap(p)
	return {
		[0] = p,
		[1] = p,
		[2] = p,
		[3] = p,
		[4] = p,
		[5] = p,
		[6] = p,
		[7] = p,
		[8] = p,
		[9] = p,
		[10] = p,
		[11] = p,
		[12] = p,
		[13] = p,
		[14] = p,
		[15] = p,
		[16] = p,
		[17] = p,
		[18] = p,
		[19] = p,
		[20] = p,
		[21] = p,
		[22] = p,
		[23] = p,
		[24] = p,
		[25] = p,
		[26] = p,
		[27] = p,
		[28] = p,
		[29] = p,
		[30] = p,
		[31] = p
	}
end

function ReactFiberLane:markRootUpdated(p, p2: number)
	self.pendingLanes = bit32.bor(self.pendingLanes, p)

	local v4 = p - 1

	self.suspendedLanes = bit32.band(self.suspendedLanes, v4)
	self.pingedLanes = bit32.band(self.pingedLanes, v4)

	self.eventTimes[31 - bit32.countlz(p)] = p2
end

function ReactFiberLane:markRootSuspended(p)
	self.suspendedLanes = bit32.bor(self.suspendedLanes, p)
	self.pingedLanes = bit32.band(self.pingedLanes, (bit32.bnot(p)))

	local expirationTimes = self.expirationTimes

	while p > 0 do
		local v4 = pickArbitraryLaneIndex(p)
		local v5 = bit32.lshift(1, v4)

		expirationTimes[v4] = -1

		p = bit32.band(p, (bit32.bnot(v5)))
	end
end

function ReactFiberLane:markRootPinged(p, _: number)
	self.pingedLanes = bit32.bor(self.pingedLanes, (bit32.band(self.suspendedLanes, p)))
end

function ReactFiberLane:markRootExpired(p)
	self.expiredLanes = bit32.bor(self.expiredLanes, (bit32.band(p, self.pendingLanes)))
end

function ReactFiberLane:markDiscreteUpdatesExpired()
	self.expiredLanes = bit32.bor(self.expiredLanes, (bit32.band(24, self.pendingLanes)))
end

function ReactFiberLane.hasDiscreteLanes(p): boolean
	return bit32.band(p, 24) ~= 0
end

function ReactFiberLane:markRootMutableRead(p)
	self.mutableReadLanes = bit32.bor(self.mutableReadLanes, (bit32.band(p, self.pendingLanes)))
end

function ReactFiberLane:markRootFinished(pendingLanes)
	local v4 = bit32.band(self.pendingLanes, (bit32.bnot(pendingLanes)))

	self.pendingLanes = pendingLanes

	self.suspendedLanes = 0
	self.pingedLanes = 0

	self.expiredLanes = bit32.band(self.expiredLanes, pendingLanes)
	self.mutableReadLanes = bit32.band(self.mutableReadLanes, pendingLanes)

	self.entangledLanes = bit32.band(self.entangledLanes, pendingLanes)

	local entanglements = self.entanglements
	local eventTimes = self.eventTimes
	local expirationTimes = self.expirationTimes

	while v4 > 0 do
		local v5 = pickArbitraryLaneIndex(v4)
		local v6 = bit32.lshift(1, v5)

		entanglements[v5] = 0
		eventTimes[v5] = -1
		expirationTimes[v5] = -1

		v4 = bit32.band(v4, (bit32.bnot(v6)))
	end
end

function ReactFiberLane:markRootEntangled(p)
	self.entangledLanes = bit32.bor(self.entangledLanes, p)

	local entanglements = self.entanglements
	local v4 = p

	while v4 > 0 do
		local v5 = pickArbitraryLaneIndex(v4)
		local v6 = bit32.lshift(1, v5)

		entanglements[v5] = bit32.bor(entanglements[v5], p)

		v4 = bit32.band(v4, (bit32.bnot(v6)))
	end
end

function ReactFiberLane.getBumpedLaneForHydration(p, p2)
	getHighestPriorityLanes(p2)
	local v4 = v3

	local v5 = nil

	if v4 == 15 or v4 == 14 then
		v5 = 0
	elseif v4 == 13 or v4 == 12 then
		v5 = 4
	elseif v4 == 11 or v4 == 10 then
		v5 = 32
	elseif v4 == 9 or v4 == 8 then
		v5 = 256
	elseif v4 == 7 or v4 == 6 or v4 == 5 then
		v5 = 4096
	elseif v4 == 4 then
		v5 = 67108864
	elseif v4 == 3 or v4 == 2 then
		v5 = 134217728
	elseif v4 == 1 or v4 == 0 then
		v5 = 0
	else
		invariant(false, "Invalid lane: %s. This is a bug in React.", (tostring(v5)))
	end

	if bit32.band(v5, (bit32.bor(p.suspendedLanes, p2))) == 0 then
		return v5
	end

	return 0
end

return ReactFiberLane
