local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Shared = require(parent.Shared)
local console = Shared.console

local function unimplemented(p: string) -- 2 equivalent calls inferred from this helper
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	print("UNIMPLEMENTED ERROR: " .. p)
	error("FIXME (roblox): " .. p .. " is unimplemented", 2)
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

local Shared2 = require(parent.Shared)
local invariant = Shared2.invariant

local ReactFibernew = require(script.Parent["ReactFiber.new"])

local createFiberFromDehydratedFragment = ReactFibernew.createFiberFromDehydratedFragment

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

local Shared3 = require(parent.Shared)
local enableSuspenseServerRenderer = Shared3.ReactFeatureFlags.enableSuspenseServerRenderer
local ReactFiberLane = require(script.Parent.ReactFiberLane)
local OffscreenLane = ReactFiberLane.OffscreenLane

local v = nil
local v2 = nil
local isHydrating = false

function warnIfHydrating()
	if ReactGlobals.__DEV__ and isHydrating then
		console.error("We should not be hydrating here. This is a bug in React. Please file a bug.")
	end
end

function enterHydrationState(p): boolean
	if not supportsHydration then
		return false
	end

	v2 = getFirstHydratableChild(p.stateNode.containerInfo)
	v = p
	isHydrating = true
	return true
end

function reenterHydrationStateFromDehydratedSuspenseInstance(p, p2): boolean
	if not supportsHydration then
		return false
	end

	v2 = getNextHydratableSibling(p2)
	popToNextHostParent(p)
	isHydrating = true
	return true
end

function deleteHydratableInstance(_, _)
	unimplemented("deleteHydratableInstance") -- inferred equivalent call
end

function insertNonHydratedInstance(_, p)
	unimplemented("insertNonHydratedInstance") -- inferred equivalent call
	p.flags = bit32.bor(bit32.band(p.flags, (bit32.bnot(Hydrating))), Placement)
	local ___DEV__ = ReactGlobals.__DEV__
end

function tryHydrate(return_, p): boolean
	if return_.tag == HostComponent then
		local stateNode = canHydrateInstance(p, return_.type, return_.pendingProps)

		if stateNode == nil then
			return false
		end

		return_.stateNode = stateNode
		return true
	elseif return_.tag == HostText then
		local stateNode = canHydrateTextInstance(p, return_.pendingProps)

		if stateNode == nil then
			return false
		end

		return_.stateNode = stateNode
		return true
	else
		if not (return_.tag == SuspenseComponent and enableSuspenseServerRenderer) then
			return false
		end

		local dehydrated = canHydrateSuspenseInstance(p)

		if dehydrated == nil then
			return false
		end

		return_.memoizedState = { dehydrated = dehydrated, retryLane = OffscreenLane }

		local fiberFromDehydratedFragment = createFiberFromDehydratedFragment(dehydrated)
		fiberFromDehydratedFragment.return_ = return_
		return_.child = fiberFromDehydratedFragment
		return true
	end
end

function tryToClaimNextHydratableInstance(p)
	if not isHydrating then
		return
	end

	local v3 = v2

	if v3 then
		if not tryHydrate(p, v3) then
			local nextHydratableSibling = getNextHydratableSibling(v3)

			if nextHydratableSibling and tryHydrate(p, nextHydratableSibling) then
				deleteHydratableInstance(v, v3)
				v3 = nextHydratableSibling
			else
				insertNonHydratedInstance(v, p)
				isHydrating = false
				v = p
				return
			end
		end

		v = p
		v2 = getFirstHydratableChild(v3)
	else
		insertNonHydratedInstance(v, p)
		isHydrating = false
		v = p
	end
end

function prepareToHydrateHostInstance(state, p, p2): boolean
	if not supportsHydration then
		invariant(
			false,
			"Expected prepareToHydrateHostInstance() to never be called. This error is likely caused by a bug in React. Please file an issue."
		)
	end

	local updateQueue = hydrateInstance(state.stateNode, state.type, state.memoizedProps, p, p2, state)

	state.updateQueue = updateQueue
	return updateQueue ~= nil
end

function prepareToHydrateHostTextInstance(p)
	if not supportsHydration then
		invariant(
			false,
			"Expected prepareToHydrateHostTextInstance() to never be called. This error is likely caused by a bug in React. Please file an issue."
		)
	end

	local stateNode = p.stateNode
	local memoizedProps = p.memoizedProps
	local v3 = hydrateTextInstance(stateNode, memoizedProps, p)

	if not (ReactGlobals.__DEV__ and v3) then
		return v3
	end

	local v4 = v

	if v4 == nil then
		return v3
	end

	if v4.tag == HostRoot then
		didNotMatchHydratedContainerTextInstance(v4.stateNode.containerInfo, stateNode, memoizedProps)
		return v3
	end

	if v4.tag == HostComponent then
		didNotMatchHydratedTextInstance(v4.type, v4.memoizedProps, v4.stateNode, stateNode, memoizedProps)
	end

	return v3
end

function prepareToHydrateHostSuspenseInstance(p)
	if not supportsHydration then
		invariant(
			false,
			"Expected prepareToHydrateHostSuspenseInstance() to never be called. This error is likely caused by a bug in React. Please file an issue."
		)
	end

	local memoizedState = p.memoizedState
	local dehydrated

	if memoizedState ~= nil then
		dehydrated = memoizedState.dehydrated
	end

	invariant(
		dehydrated,
		"Expected to have a hydrated suspense instance. This error is likely caused by a bug in React. Please file an issue."
	)

	hydrateSuspenseInstance(dehydrated, p)
end

function skipPastDehydratedSuspenseInstance(p)
	if not supportsHydration then
		invariant(
			false,
			"Expected skipPastDehydratedSuspenseInstance() to never be called. This error is likely caused by a bug in React. Please file an issue."
		)
	end

	local memoizedState = p.memoizedState
	local dehydrated

	if memoizedState ~= nil then
		dehydrated = memoizedState.dehydrated
	end

	invariant(
		dehydrated,
		"Expected to have a hydrated suspense instance. This error is likely caused by a bug in React. Please file an issue."
	)

	return getNextHydratableInstanceAfterSuspenseInstance(dehydrated)
end

function popToNextHostParent(p)
	local return_ = p.return_

	while
		return_ ~= nil
		and return_.tag ~= HostComponent
		and return_.tag ~= HostRoot
		and return_.tag ~= SuspenseComponent
	do
		return_ = return_.return_
	end

	v = return_
end

function popHydrationState(data): boolean
	if not (supportsHydration and data == v) then
		return false
	end

	if isHydrating then
		local kind = data.type

		if
			data.tag ~= HostComponent
			or kind ~= "head" and kind ~= "body" and not shouldSetTextContent(kind, data.memoizedProps)
		then
			local v3 = v2

			while v3 do
				deleteHydratableInstance(data, v3)
				v3 = getNextHydratableSibling(v3)
			end
		end

		popToNextHostParent(data)

		if data.tag == SuspenseComponent then
			v2 = skipPastDehydratedSuspenseInstance(data)
		elseif v then
			v2 = getNextHydratableSibling(data.stateNode)
		else
			v2 = nil
		end

		return true
	end

	popToNextHostParent(data)
	isHydrating = true
	return false
end

function resetHydrationState()
	if not supportsHydration then
		return
	end

	v = nil
	v2 = nil
	isHydrating = false
end

function getIsHydrating()
	return isHydrating
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
