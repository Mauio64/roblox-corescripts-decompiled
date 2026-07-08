local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(ParentParent.Shared).console

local function unimplemented(s1: string) -- line: 18
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. s1)
	error("FIXME (roblox): " .. s1 .. " is unimplemented", 2)
end

require(script.Parent.ReactInternalTypes)

local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)

require(script.Parent["ReactFiberSuspenseComponent.new"])

local ReactWorkTags = require(script.Parent.ReactWorkTags)
local HostComponent = ReactWorkTags.HostComponent
local HostText = ReactWorkTags.HostText
local HostRoot = ReactWorkTags.HostRoot
local SuspenseComponent = ReactWorkTags.SuspenseComponent
local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local Placement = ReactFiberFlags.Placement
local Hydrating = ReactFiberFlags.Hydrating
local invariant = require(ParentParent.Shared).invariant
local createFiberFromDehydratedFragment = require(script.Parent["ReactFiber.new"]).createFiberFromDehydratedFragment
local supportsHydration = ReactFiberHostConfig.supportsHydration
local getNextHydratableSibling = ReactFiberHostConfig.getNextHydratableSibling
local getFirstHydratableChild = ReactFiberHostConfig.getFirstHydratableChild
local canHydrateInstance = ReactFiberHostConfig.canHydrateInstance
local canHydrateTextInstance = ReactFiberHostConfig.canHydrateTextInstance
local canHydrateSuspenseInstance = ReactFiberHostConfig.canHydrateSuspenseInstance
local hydrateInstance = ReactFiberHostConfig.hydrateInstance
local hydrateTextInstance = ReactFiberHostConfig.hydrateTextInstance
local hydrateSuspenseInstance = ReactFiberHostConfig.hydrateSuspenseInstance
local getNextHydratableInstanceAfterSuspenseInstance = ReactFiberHostConfig.getNextHydratableInstanceAfterSuspenseInstance
local didNotMatchHydratedContainerTextInstance = ReactFiberHostConfig.didNotMatchHydratedContainerTextInstance
local didNotMatchHydratedTextInstance = ReactFiberHostConfig.didNotMatchHydratedTextInstance
local shouldSetTextContent = ReactFiberHostConfig.shouldSetTextContent
local enableSuspenseServerRenderer = require(ParentParent.Shared).ReactFeatureFlags.enableSuspenseServerRenderer
local OffscreenLane = require(script.Parent.ReactFiberLane).OffscreenLane
local u31 = nil
local u32 = nil
local u33 = false

function warnIfHydrating() -- line: 92
	-- upvalues: ReactGlobals (copy), u33 (ref), console (copy)
	if ReactGlobals.__DEV__ and u33 then
		console.error("We should not be hydrating here. This is a bug in React. Please file a bug.")
	end
end
function enterHydrationState(p1) -- line: 102
	-- upvalues: supportsHydration (copy), u32 (ref), getFirstHydratableChild (copy), u31 (ref), u33 (ref)
	if not supportsHydration then
		return false
	end

	local containerInfo = p1.stateNode.containerInfo

	u32 = getFirstHydratableChild(containerInfo)
	u31 = p1
	u33 = true

	return true
end
function reenterHydrationStateFromDehydratedSuspenseInstance(p2, p3) -- line: 114
	-- upvalues: supportsHydration (copy), u32 (ref), getNextHydratableSibling (copy), u33 (ref)
	if not supportsHydration then
		return false
	end

	u32 = getNextHydratableSibling(p3)
	popToNextHostParent(p2)
	u33 = true

	return true
end
function deleteHydratableInstance(_, _) -- line: 128
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: deleteHydratableInstance")
	error("FIXME (roblox): deleteHydratableInstance is unimplemented", 2)
end
function insertNonHydratedInstance(_, p7) -- line: 163
	-- upvalues: Hydrating (copy), Placement (copy), ReactGlobals (copy)
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: insertNonHydratedInstance")
	error("FIXME (roblox): insertNonHydratedInstance is unimplemented", 2)
	p7.flags = bit32.bor(bit32.band(p7.flags, (bit32.bnot(Hydrating))), Placement)

	if not ReactGlobals.__DEV__ then
	end
end
function tryHydrate(p8, p9) -- line: 227
	-- upvalues: HostComponent (copy), canHydrateInstance (copy), HostText (copy), canHydrateTextInstance (copy), SuspenseComponent (copy), enableSuspenseServerRenderer (copy), canHydrateSuspenseInstance (copy), OffscreenLane (copy), createFiberFromDehydratedFragment (copy)
	if p8.tag == HostComponent then
		local type = p8.type
		local pendingProps = p8.pendingProps
		local v47 = canHydrateInstance(p9, type, pendingProps)

		if v47 ~= nil then
			p8.stateNode = v47

			return true
		end

		return false
	end

	if p8.tag == HostText then
		local pendingProps = p8.pendingProps
		local v49 = canHydrateTextInstance(p9, pendingProps)

		if v49 ~= nil then
			p8.stateNode = v49

			return true
		end

		return false
	end

	if p8.tag == SuspenseComponent then
		if enableSuspenseServerRenderer then
			local v50 = canHydrateSuspenseInstance(p9)

			if v50 ~= nil then
				p8.memoizedState = {
					dehydrated = v50,
					retryLane = OffscreenLane
				}

				local v51 = createFiberFromDehydratedFragment(v50)

				v51.return_ = p8
				p8.child = v51

				return true
			end
		end

		return false
	end

	return false
end
function tryToClaimNextHydratableInstance(p10) -- line: 272
	-- upvalues: u33 (ref), u32 (ref), u31 (ref), getNextHydratableSibling (copy), getFirstHydratableChild (copy)
	if not u33 then
		return
	end

	local v53 = u32

	if not v53 then
		insertNonHydratedInstance(u31, p10)
		u33 = false
		u31 = p10

		return
	end

	local v54 = v53

	if not tryHydrate(p10, v53) then
		v53 = getNextHydratableSibling(v54)

		if not v53 or not tryHydrate(p10, v53) then
			insertNonHydratedInstance(u31, p10)
			u33 = false
			u31 = p10

			return
		end

		deleteHydratableInstance(u31, v54)
	end

	u31 = p10
	u32 = getFirstHydratableChild(v53)
end
function prepareToHydrateHostInstance(p11, p12, p13) -- line: 308
	-- upvalues: supportsHydration (copy), invariant (copy), hydrateInstance (copy)
	if not supportsHydration then
		invariant(false, "Expected prepareToHydrateHostInstance() to never be called. This error is likely caused by a bug in React. Please file an issue.")
	end

	local stateNode = p11.stateNode
	local v59 = hydrateInstance(stateNode, p11.type, p11.memoizedProps, p12, p13, p11)

	p11.updateQueue = v59

	if v59 ~= nil then
		return true
	end

	return false
end
function prepareToHydrateHostTextInstance(p14) -- line: 340
	-- upvalues: supportsHydration (copy), invariant (copy), hydrateTextInstance (copy), ReactGlobals (copy), u31 (ref), HostRoot (copy), didNotMatchHydratedContainerTextInstance (copy), HostComponent (copy), didNotMatchHydratedTextInstance (copy)
	if not supportsHydration then
		invariant(false, "Expected prepareToHydrateHostTextInstance() to never be called. This error is likely caused by a bug in React. Please file an issue.")
	end

	local stateNode = p14.stateNode
	local memoizedProps = p14.memoizedProps
	local v63 = hydrateTextInstance(stateNode, memoizedProps, p14)

	if ReactGlobals.__DEV__ and v63 then
		local v64 = u31

		if v64 ~= nil then
			if v64.tag == HostRoot then
				local containerInfo = v64.stateNode.containerInfo

				didNotMatchHydratedContainerTextInstance(containerInfo, stateNode, memoizedProps)

				return v63
			end

			if v64.tag == HostComponent then
				local type = v64.type
				local memoizedProps2 = v64.memoizedProps
				local stateNode2 = v64.stateNode

				didNotMatchHydratedTextInstance(type, memoizedProps2, stateNode2, stateNode, memoizedProps)
			end
		end
	end

	return v63
end
function prepareToHydrateHostSuspenseInstance(p15) -- line: 383
	-- upvalues: supportsHydration (copy), invariant (copy), hydrateSuspenseInstance (copy)
	if not supportsHydration then
		invariant(false, "Expected prepareToHydrateHostSuspenseInstance() to never be called. This error is likely caused by a bug in React. Please file an issue.")
	end

	local memoizedState = p15.memoizedState
	local v71 = if memoizedState == nil then nil else memoizedState.dehydrated

	invariant(v71, "Expected to have a hydrated suspense instance. This error is likely caused by a bug in React. Please file an issue.")
	hydrateSuspenseInstance(v71, p15)
end
function skipPastDehydratedSuspenseInstance(p16) -- line: 408
	-- upvalues: supportsHydration (copy), invariant (copy), getNextHydratableInstanceAfterSuspenseInstance (copy)
	if not supportsHydration then
		invariant(false, "Expected skipPastDehydratedSuspenseInstance() to never be called. This error is likely caused by a bug in React. Please file an issue.")
	end

	local memoizedState = p16.memoizedState
	local v74 = if memoizedState == nil then nil else memoizedState.dehydrated

	invariant(v74, "Expected to have a hydrated suspense instance. This error is likely caused by a bug in React. Please file an issue.")

	return getNextHydratableInstanceAfterSuspenseInstance(v74)
end
function popToNextHostParent(p17) -- line: 431
	-- upvalues: HostComponent (copy), HostRoot (copy), SuspenseComponent (copy), u31 (ref)
	local return_ = p17.return_

	while return_ ~= nil and return_.tag ~= HostComponent and return_.tag ~= HostRoot and return_.tag ~= SuspenseComponent do
		return_ = return_.return_
	end

	u31 = return_
end
function popHydrationState(p18) -- line: 444
	-- upvalues: supportsHydration (copy), u31 (ref), u33 (ref), HostComponent (copy), shouldSetTextContent (copy), u32 (ref), getNextHydratableSibling (copy), SuspenseComponent (copy)
	if not supportsHydration then
		return false
	end

	if p18 ~= u31 then
		return false
	end

	if not u33 then
		popToNextHostParent(p18)
		u33 = true

		return false
	end

	local type = p18.type

	if p18.tag ~= HostComponent or type ~= "head" and type ~= "body" and not shouldSetTextContent(type, p18.memoizedProps) then
		local v79 = u32

		while v79 do
			deleteHydratableInstance(p18, v79)
			v79 = getNextHydratableSibling(v79)
		end
	end

	popToNextHostParent(p18)

	if p18.tag == SuspenseComponent then
		u32 = skipPastDehydratedSuspenseInstance(p18)
	elseif u31 then
		u32 = getNextHydratableSibling(p18.stateNode)
	else
		u32 = nil
	end

	return true
end
function resetHydrationState() -- line: 497
	-- upvalues: supportsHydration (copy), u31 (ref), u32 (ref), u33 (ref)
	if not supportsHydration then
		return
	end

	u31 = nil
	u32 = nil
	u33 = false
end
function getIsHydrating() -- line: 507
	-- upvalues: u33 (ref)
	return u33
end

return {
	warnIfHydrating = warnIfHydrating,
	enterHydrationState = enterHydrationState,
	getIsHydrating = getIsHydrating,
	reenterHydrationStateFromDehydratedSuspenseInstance = reenterHydrationStateFromDehydratedSuspenseInstance,
	resetHydrationState = resetHydrationState,
	tryToClaimNextHydratableInstance = tryToClaimNextHydratableInstance,
	prepareToHydrateHostInstance = prepareToHydrateHostInstance,
	prepareToHydrateHostTextInstance = prepareToHydrateHostTextInstance,
	prepareToHydrateHostSuspenseInstance = prepareToHydrateHostSuspenseInstance,
	popHydrationState = popHydrationState
}
