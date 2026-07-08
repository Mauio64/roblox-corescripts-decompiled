local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)

require(script.Parent.ReactInternalTypes)

local console = require(ParentParent.Shared).console
local lib = require(script.Parent["ReactFiberSchedulerPriorities.roblox"])
local v5 = require(ParentParent.SafeFlags).createGetFFlag("ReactInlineMergeLanes")()
local invariant = require(ParentParent.Shared).invariant
local ImmediatePriority = lib.ImmediatePriority
local UserBlockingPriority = lib.UserBlockingPriority
local NormalPriority = lib.NormalPriority
local LowPriority = lib.LowPriority
local IdlePriority = lib.IdlePriority
local NoPriority = lib.NoPriority
local t1 = {
	SyncLanePriority = 15,
	SyncBatchedLanePriority = 14,
	InputDiscreteLanePriority = 12,
	InputContinuousLanePriority = 10,
	DefaultLanePriority = 8,
	TransitionPriority = 6,
	NoLanePriority = 0,
	NoLanes = 0,
	NoLane = 0,
	SyncLane = 1,
	SyncBatchedLane = 2,
	InputDiscreteHydrationLane = 4,
	DefaultHydrationLane = 256,
	DefaultLanes = 3584,
	RetryLanes = 62914560,
	SomeRetryLane = 33554432,
	SelectiveHydrationLane = 67108864,
	IdleHydrationLane = 134217728,
	OffscreenLane = 1073741824,
	NoTimestamp = -1
}
local NoLanePriority = t1.NoLanePriority

function t1.getCurrentUpdateLanePriority() -- line: 147
	-- upvalues: NoLanePriority (ref)
	return NoLanePriority
end
function t1.setCurrentUpdateLanePriority(p1) -- line: 151
	-- upvalues: NoLanePriority (ref)
	NoLanePriority = p1
end

local DefaultLanePriority = t1.DefaultLanePriority

local function getHighestPriorityLanes(p2) -- line: 159
	-- upvalues: DefaultLanePriority (ref), ReactGlobals (copy), console (copy)
	if bit32.band(1, p2) ~= 0 then
		DefaultLanePriority = 15

		return 1
	end

	if bit32.band(2, p2) ~= 0 then
		DefaultLanePriority = 14

		return 2
	end

	if bit32.band(4, p2) ~= 0 then
		DefaultLanePriority = 13

		return 4
	end

	local v26 = bit32.band(24, p2)

	if v26 ~= 0 then
		DefaultLanePriority = 12

		return v26
	end

	if bit32.band(p2, 32) ~= 0 then
		DefaultLanePriority = 11

		return 32
	end

	local v27 = bit32.band(192, p2)

	if v27 ~= 0 then
		DefaultLanePriority = 10

		return v27
	end

	if bit32.band(p2, 256) ~= 0 then
		DefaultLanePriority = 9

		return 256
	end

	local v28 = bit32.band(3584, p2)

	if v28 ~= 0 then
		DefaultLanePriority = 8

		return v28
	end

	if bit32.band(p2, 4096) ~= 0 then
		DefaultLanePriority = 7

		return 4096
	end

	local v29 = bit32.band(4186112, p2)

	if v29 ~= 0 then
		DefaultLanePriority = 6

		return v29
	end

	local v30 = bit32.band(62914560, p2)

	if v30 ~= 0 then
		DefaultLanePriority = 5

		return v30
	end

	if bit32.band(p2, 67108864) ~= 0 then
		DefaultLanePriority = 4

		return 67108864
	end

	if bit32.band(p2, 134217728) ~= 0 then
		DefaultLanePriority = 3

		return 134217728
	end

	local v31 = bit32.band(805306368, p2)

	if v31 ~= 0 then
		DefaultLanePriority = 2

		return v31
	end

	if bit32.band(1073741824, p2) ~= 0 then
		DefaultLanePriority = 1

		return 1073741824
	end

	if ReactGlobals.__DEV__ then
		console.error("Should have found matching lanes. This is a bug in React.")
	end

	DefaultLanePriority = 8

	return p2
end

function t1.schedulerPriorityToLanePriority(p3) -- line: 234
	-- upvalues: ImmediatePriority (copy), UserBlockingPriority (copy), NormalPriority (copy), LowPriority (copy), IdlePriority (copy)
	if p3 == ImmediatePriority then
		return 15
	end

	if p3 == UserBlockingPriority then
		return 10
	end

	if p3 == NormalPriority or p3 == LowPriority then
		return 8
	end

	if p3 == IdlePriority then
		return 2
	end

	return 0
end
function t1.lanePriorityToSchedulerPriority(p4) -- line: 255
	-- upvalues: ImmediatePriority (copy), UserBlockingPriority (copy), NormalPriority (copy), IdlePriority (copy), NoPriority (copy), invariant (copy)
	if p4 == 15 or p4 == 14 then
		return ImmediatePriority
	end

	if p4 == 13 or p4 == 12 or p4 == 11 or p4 == 10 then
		return UserBlockingPriority
	end

	if p4 == 9 or p4 == 8 or p4 == 7 or p4 == 6 or p4 == 4 or p4 == 5 then
		return NormalPriority
	end

	if p4 == 3 or p4 == 2 or p4 == 1 then
		return IdlePriority
	end

	if p4 == 0 then
		return NoPriority
	end

	invariant(false, "Invalid update priority: %s. This is a bug in React.", p4)
	error("unreachable")
end

local pickArbitraryLaneIndex = nil
local getLowestPriorityLane = nil

function t1.getNextLanes(p5, p6) -- line: 299
	-- upvalues: DefaultLanePriority (ref), getHighestPriorityLanes (copy), getLowestPriorityLane (ref), pickArbitraryLaneIndex (ref)
	local pendingLanes = p5.pendingLanes

	if pendingLanes == 0 then
		DefaultLanePriority = 0

		return 0
	end

	local n1 = 0
	local n2 = 0
	local expiredLanes = p5.expiredLanes
	local suspendedLanes = p5.suspendedLanes
	local pingedLanes = p5.pingedLanes

	if expiredLanes ~= 0 then
		n1 = expiredLanes
		DefaultLanePriority = 15
		n2 = 15
	else
		local v42 = bit32.band(pendingLanes, 134217727)

		if v42 ~= 0 then
			local v43 = bit32.band(v42, (bit32.bnot(suspendedLanes)))

			if v43 ~= 0 then
				n1 = getHighestPriorityLanes(v43)
				n2 = DefaultLanePriority
			else
				local v44 = bit32.band(v42, pingedLanes)

				if v44 ~= 0 then
					n1 = getHighestPriorityLanes(v44)
					n2 = DefaultLanePriority
				end
			end
		else
			local v45 = bit32.band(pendingLanes, (bit32.bnot(suspendedLanes)))

			if v45 ~= 0 then
				n1 = getHighestPriorityLanes(v45)
				n2 = DefaultLanePriority
			elseif pingedLanes ~= 0 then
				n1 = getHighestPriorityLanes(pingedLanes)
				n2 = DefaultLanePriority
			end
		end
	end

	if n1 == 0 then
		return 0
	end

	local v46 = bit32.band(pendingLanes, bit32.lshift(getLowestPriorityLane(n1), 1) - 1)

	if p6 ~= 0 and p6 ~= v46 and bit32.band(p6, suspendedLanes) == 0 then
		getHighestPriorityLanes(p6)

		if n2 <= DefaultLanePriority then
			return p6
		end

		DefaultLanePriority = n2
	end

	local entangledLanes = p5.entangledLanes

	if entangledLanes ~= 0 then
		local entanglements = p5.entanglements
		local v49 = bit32.band(v46, entangledLanes)

		while v49 > 0 do
			local v50 = pickArbitraryLaneIndex(v49)
			local v51 = bit32.lshift(1, v50)

			v46 = bit32.bor(v46, entanglements[v50])
			v49 = bit32.band(v49, (bit32.bnot(v51)))
		end
	end

	return v46
end
function t1.getMostRecentEventTime(p7, p8) -- line: 418
	-- upvalues: pickArbitraryLaneIndex (ref)
	local eventTimes = p7.eventTimes
	local n3 = -1

	while p8 > 0 do
		local v56 = pickArbitraryLaneIndex(p8)
		local v57 = bit32.lshift(1, v56)
		local v58 = eventTimes[v56]

		if n3 < v58 then
			n3 = v58
		end

		p8 = bit32.band(p8, (bit32.bnot(v57)))
	end

	return n3
end
function t1.computeExpirationTime(p9, n4: number) -- line: 438
	-- upvalues: getHighestPriorityLanes (copy), DefaultLanePriority (ref)
	getHighestPriorityLanes(p9)

	local v61 = DefaultLanePriority

	if v61 >= 10 then
		return n4 + 250
	end

	if v61 >= 6 then
		return n4 + 5000
	end

	return -1
end
function t1.markStarvedLanesAsExpired(p10, n5: number) -- line: 468
	-- upvalues: pickArbitraryLaneIndex (ref), getHighestPriorityLanes (copy), DefaultLanePriority (ref)
	local pendingLanes = p10.pendingLanes
	local suspendedLanes = p10.suspendedLanes
	local pingedLanes = p10.pingedLanes
	local expirationTimes = p10.expirationTimes

	while pendingLanes > 0 do
		local v68 = pickArbitraryLaneIndex(pendingLanes)
		local v69 = bit32.lshift(1, v68)
		local v70 = expirationTimes[v68]

		if v70 == -1 then
			if bit32.band(v69, suspendedLanes) == 0 or bit32.band(v69, pingedLanes) ~= 0 then
				getHighestPriorityLanes(v69)

				local v71 = DefaultLanePriority

				expirationTimes[v68] = if not (v71 >= 10) then not (v71 >= 6) and -1 or n5 + 5000 else n5 + 250
			end
		elseif v70 <= n5 then
			p10.expiredLanes = bit32.bor(p10.expiredLanes, v69)
		end

		pendingLanes = bit32.band(pendingLanes, (bit32.bnot(v69)))
	end
end
function t1.getHighestPriorityPendingLanes(p11) -- line: 510
	-- upvalues: getHighestPriorityLanes (copy)
	return (getHighestPriorityLanes(p11.pendingLanes))
end
function t1.getLanesToRetrySynchronouslyOnError(p12) -- line: 515
	local v74 = bit32.band(p12.pendingLanes, 3221225471)

	if v74 ~= 0 then
		return v74
	end

	if bit32.band(v74, 1073741824) ~= 0 then
		return 1073741824
	end

	return 0
end
function t1.returnNextLanesPriority() -- line: 528
	-- upvalues: DefaultLanePriority (ref)
	return DefaultLanePriority
end
function t1.includesNonIdleWork(p13) -- line: 533
	return bit32.band(p13, 134217727) ~= 0
end
function t1.includesOnlyRetries(p14) -- line: 538
	return p14 == bit32.band(p14, 62914560)
end
function t1.includesOnlyTransitions(p15) -- line: 543
	return p15 == bit32.band(p15, 4186112)
end

local pickArbitraryLane = nil

local function findUpdateLane(p16, p17) -- line: 553
	-- upvalues: pickArbitraryLane (ref), findUpdateLane (copy), invariant (copy)
	if p16 ~= 0 then
		if p16 == 15 then
			return 1
		end

		if p16 == 14 then
			return 2
		end

		if p16 == 12 then
			local v80 = pickArbitraryLane((bit32.band(24, (bit32.bnot(p17)))))

			if v80 == 0 then
				return findUpdateLane(10, p17)
			end

			return v80
		end

		if p16 == 10 then
			local v81 = pickArbitraryLane((bit32.band(192, (bit32.bnot(p17)))))

			if v81 == 0 then
				return findUpdateLane(8, p17)
			end

			return v81
		end

		if p16 == 8 then
			local v82 = pickArbitraryLane((bit32.band(3584, (bit32.bnot(p17)))))

			if v82 == 0 then
				v82 = pickArbitraryLane((bit32.band(4186112, (bit32.bnot(p17)))))

				if v82 == 0 then
					v82 = pickArbitraryLane(3584)
				end
			end

			return v82
		end

		if p16 ~= 6 and p16 ~= 5 and p16 == 2 then
			local v83 = pickArbitraryLane((bit32.band(805306368, (bit32.bnot(p17)))))

			if v83 == 0 then
				v83 = pickArbitraryLane(805306368)
			end

			return v83
		end
	end

	invariant(false, "Invalid update priority: %s. This is a bug in React.", p16)
	error("unreachable")
end

t1.findUpdateLane = findUpdateLane

function t1.findTransitionLane(p18, p19) -- line: 612
	-- upvalues: pickArbitraryLane (ref)
	local v86 = pickArbitraryLane((bit32.band(4186112, (bit32.bnot(p19)))))

	if v86 == 0 then
		v86 = pickArbitraryLane((bit32.band(4186112, (bit32.bnot(p18)))))

		if v86 == 0 then
			v86 = pickArbitraryLane(4186112)
		end
	end

	return v86
end
function t1.findRetryLane(p20) -- line: 632
	-- upvalues: pickArbitraryLane (ref)
	local v88 = pickArbitraryLane((bit32.band(62914560, (bit32.bnot(p20)))))

	if v88 == 0 then
		v88 = pickArbitraryLane(62914560)
	end

	return v88
end

local function getHighestPriorityLane(p21) -- line: 644
	return (bit32.band(p21, -p21))
end

function getLowestPriorityLane(p22) -- line: 648
	local v91 = 31 - bit32.countlz(p22)

	if v91 < 0 then
		return 0
	end

	return (bit32.lshift(1, v91))
end

local function getEqualOrHigherPriorityLanes(p23) -- line: 658
	-- upvalues: getLowestPriorityLane (ref)
	return bit32.lshift(getLowestPriorityLane(p23), 1) - 1
end

function pickArbitraryLane(p24) -- line: 662
	return (bit32.band(p24, -p24))
end

t1.pickArbitraryLane = pickArbitraryLane

function pickArbitraryLaneIndex(p25) -- line: 671
	return 31 - bit32.countlz(p25)
end
function t1.includesSomeLane(p26, p27) -- line: 680
	return bit32.band(p26, p27) ~= 0
end
function t1.isSubsetOfLanes(p28, p29) -- line: 685
	return p29 == bit32.band(p28, p29)
end

local function mergeLanes(p30, p31) -- line: 690
	return (bit32.bor(p30, p31))
end

t1.mergeLanes = if not v5 then mergeLanes else bit32.bor

function t1.removeLanes(p32, p33) -- line: 698
	return (bit32.band(p32, (bit32.bnot(p33))))
end
function t1.laneToLanes(p34) -- line: 705
	return p34
end
function t1.higherPriorityLane(p35, p36) -- line: 710
	if p35 ~= 0 and p36 ~= 0 then
		if p35 < p36 then
			return p35
		end

		return p36
	end

	if p35 ~= 0 then
		return p35
	end

	return p36
end
function t1.higherLanePriority(p37, p38) -- line: 726
	if p37 ~= 0 and p38 < p37 then
		return p37
	end

	return p38
end
function t1.createLaneMap(p39) -- line: 737
	return {
		[0] = p39,
		[1] = p39,
		[2] = p39,
		[3] = p39,
		[4] = p39,
		[5] = p39,
		[6] = p39,
		[7] = p39,
		[8] = p39,
		[9] = p39,
		[10] = p39,
		[11] = p39,
		[12] = p39,
		[13] = p39,
		[14] = p39,
		[15] = p39,
		[16] = p39,
		[17] = p39,
		[18] = p39,
		[19] = p39,
		[20] = p39,
		[21] = p39,
		[22] = p39,
		[23] = p39,
		[24] = p39,
		[25] = p39,
		[26] = p39,
		[27] = p39,
		[28] = p39,
		[29] = p39,
		[30] = p39,
		[31] = p39
	}
end
function t1.markRootUpdated(p40, p41, n6: number) -- line: 781
	p40.pendingLanes = bit32.bor(p40.pendingLanes, p41)

	local v112 = p41 - 1

	p40.suspendedLanes = bit32.band(p40.suspendedLanes, v112)
	p40.pingedLanes = bit32.band(p40.pingedLanes, v112)
	p40.eventTimes[31 - bit32.countlz(p41)] = n6
end
function t1.markRootSuspended(p42, p43) -- line: 810
	-- upvalues: pickArbitraryLaneIndex (ref)
	p42.suspendedLanes = bit32.bor(p42.suspendedLanes, p43)
	p42.pingedLanes = bit32.band(p42.pingedLanes, (bit32.bnot(p43)))

	local expirationTimes = p42.expirationTimes

	while p43 > 0 do
		local v116 = pickArbitraryLaneIndex(p43)
		local v117 = bit32.lshift(1, v116)

		expirationTimes[v116] = -1
		p43 = bit32.band(p43, (bit32.bnot(v117)))
	end
end
function t1.markRootPinged(p44, p45, _: number) -- line: 828
	p44.pingedLanes = bit32.bor(p44.pingedLanes, (bit32.band(p44.suspendedLanes, p45)))
end
function t1.markRootExpired(p46, p47) -- line: 834
	p46.expiredLanes = bit32.bor(p46.expiredLanes, (bit32.band(p47, p46.pendingLanes)))
end
function t1.markDiscreteUpdatesExpired(p48) -- line: 840
	p48.expiredLanes = bit32.bor(p48.expiredLanes, (bit32.band(24, p48.pendingLanes)))
end
function t1.hasDiscreteLanes(p49) -- line: 846
	return bit32.band(p49, 24) ~= 0
end
function t1.markRootMutableRead(p50, p51) -- line: 851
	p50.mutableReadLanes = bit32.bor(p50.mutableReadLanes, (bit32.band(p51, p50.pendingLanes)))
end
function t1.markRootFinished(p52, p53) -- line: 857
	-- upvalues: pickArbitraryLaneIndex (ref)
	local v129 = bit32.band(p52.pendingLanes, (bit32.bnot(p53)))

	p52.pendingLanes = p53
	p52.suspendedLanes = 0
	p52.pingedLanes = 0
	p52.expiredLanes = bit32.band(p52.expiredLanes, p53)
	p52.mutableReadLanes = bit32.band(p52.mutableReadLanes, p53)
	p52.entangledLanes = bit32.band(p52.entangledLanes, p53)

	local entanglements = p52.entanglements
	local eventTimes = p52.eventTimes
	local expirationTimes = p52.expirationTimes

	while v129 > 0 do
		local v133 = pickArbitraryLaneIndex(v129)
		local v134 = bit32.lshift(1, v133)

		entanglements[v133] = 0
		eventTimes[v133] = -1
		expirationTimes[v133] = -1
		v129 = bit32.band(v129, (bit32.bnot(v134)))
	end
end
function t1.markRootEntangled(p54, p55) -- line: 890
	-- upvalues: pickArbitraryLaneIndex (ref)
	p54.entangledLanes = bit32.bor(p54.entangledLanes, p55)

	local entanglements = p54.entanglements
	local v138 = p55

	while v138 > 0 do
		local v139 = pickArbitraryLaneIndex(v138)
		local v140 = bit32.lshift(1, v139)

		entanglements[v139] = bit32.bor(entanglements[v139], p55)
		v138 = bit32.band(v138, (bit32.bnot(v140)))
	end
end
function t1.getBumpedLaneForHydration(p56, p57) -- line: 906
	-- upvalues: getHighestPriorityLanes (copy), DefaultLanePriority (ref), invariant (copy)
	getHighestPriorityLanes(p57)

	local v143 = DefaultLanePriority
	local n8 = nil

	if v143 == 15 or v143 == 14 then
		n8 = 0
	elseif v143 == 13 or v143 == 12 then
		n8 = 4
	elseif v143 == 11 or v143 == 10 then
		n8 = 32
	elseif v143 == 9 or v143 == 8 then
		n8 = 256
	elseif v143 == 7 or v143 == 6 then
		n8 = 4096
	elseif v143 == 5 then
		n8 = 4096
	elseif v143 == 4 then
		n8 = 67108864
	elseif v143 == 3 or v143 == 2 then
		n8 = 134217728
	elseif v143 == 1 or v143 == 0 then
		n8 = 0
	else
		invariant(false, "Invalid lane: %s. This is a bug in React.", (tostring(n8)))
	end

	if bit32.band(n8, (bit32.bor(p56.suspendedLanes, p57))) ~= 0 then
		return 0
	end

	return n8
end

return t1
