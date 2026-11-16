local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Shared = require(parent.Shared)
local console = Shared.console

require(script.Parent.ReactInternalTypes)

require(script.Parent.ReactFiberHostConfig)

require(script.Parent["ReactFiberSuspenseComponent.new"])

local Shared2 = require(parent.Shared)
local invariant = Shared2.invariant

local Shared3 = require(parent.Shared)
local get = Shared3.ReactInstanceMap.get
local Shared4 = require(parent.Shared)
local ReactSharedInternals = Shared4.ReactSharedInternals
local Shared5 = require(parent.Shared)
local getComponentName = Shared5.getComponentName
local ReactWorkTags = require(script.Parent.ReactWorkTags)
local ClassComponent = ReactWorkTags.ClassComponent
local HostComponent = ReactWorkTags.HostComponent
local HostRoot = ReactWorkTags.HostRoot
local HostPortal = ReactWorkTags.HostPortal
local HostText = ReactWorkTags.HostText
local FundamentalComponent = ReactWorkTags.FundamentalComponent
local SuspenseComponent = ReactWorkTags.SuspenseComponent
local ReactFiberFlags = require(script.Parent.ReactFiberFlags)
local NoFlags = ReactFiberFlags.NoFlags
local Placement = ReactFiberFlags.Placement
local Hydrating = ReactFiberFlags.Hydrating

local Shared6 = require(parent.Shared)
local enableFundamentalAPI = Shared6.ReactFeatureFlags.enableFundamentalAPI

local ReactCurrentOwner = ReactSharedInternals.ReactCurrentOwner

local function getNearestMountedFiber(data)
	local v

	if data.alternate then
		v = data

		while data.return_ do
			data = data.return_
		end
	else
		v = data

		while true do
			if bit32.band(data.flags, (bit32.bor(Placement, Hydrating))) ~= NoFlags then
				v = data.return_
			end

			local return_ = data.return_

			if not return_ then
				break
			end

			data = return_
		end
	end

	return if data.tag == HostRoot then v else nil
end

local ReactFiberTreeReflection = {}
ReactFiberTreeReflection.getNearestMountedFiber = getNearestMountedFiber

function ReactFiberTreeReflection.getSuspenseInstanceFromFiber(data)
	if data.tag ~= SuspenseComponent then
		return nil
	end

	local memoizedState = data.memoizedState

	if memoizedState == nil then
		local alternate = data.alternate

		if alternate ~= nil then
			memoizedState = alternate.memoizedState
		end
	end

	return if memoizedState then memoizedState.dehydrated else nil
end

function ReactFiberTreeReflection.getContainerFromFiber(p)
	return if p.tag == HostRoot then p.stateNode.containerInfo else nil
end

function ReactFiberTreeReflection.isFiberMounted(p): boolean
	return getNearestMountedFiber(p) == p
end

function ReactFiberTreeReflection.isMounted(p): boolean
	if ReactGlobals.__DEV__ then
		local current = ReactCurrentOwner.current

		if current ~= nil and current.tag == ClassComponent then
			local stateNode = current.stateNode

			if not stateNode._warnedAboutRefsInRender then
				console.error(
					"%s is accessing isMounted inside its render() function. render() should be a pure function of props and state. It should never access something that requires stale data from the previous render, such as refs. Move this logic to componentDidMount and componentDidUpdate instead.",
					getComponentName(current.type) or "A component"
				)
			end

			stateNode._warnedAboutRefsInRender = true
		end
	end

	local v = get(p)

	if v then
		return getNearestMountedFiber(v) == v
	end

	return false
end

local function assertIsMounted(return_) -- 2 equivalent calls inferred from this helper
	invariant(getNearestMountedFiber(return_) == return_, "Unable to find node on an unmounted component.")
end

local function findCurrentFiberUsingSlowPath(p)
	local alternate = p.alternate

	if alternate then
		local v = alternate
		local v2 = p

		while true do
			local return_ = v2.return_

			if return_ == nil then
				break
			end

			local alternate2 = return_.alternate

			if alternate2 == nil then
				v = return_.return_

				if v == nil then
					break
				end

				v2 = v
			else
				if return_.child == alternate2.child then
					local v3 = return_.child

					while v3 do
						if v3 == v2 then
							assertIsMounted(return_) -- inferred equivalent call
							return p
						end

						if v3 == v then
							assertIsMounted(return_) -- inferred equivalent call
							return alternate
						end

						v3 = v3.sibling
					end

					invariant(false, "Unable to find node on an unmounted component.")
				end

				if v2.return_ == v.return_ then
					local v3 = return_.child
					local v4 = false

					while v3 do
						if v3 == v2 then
							v = alternate2
							v2 = return_
							v4 = true
							break
						elseif v3 == v then
							v = return_
							v2 = alternate2
							v4 = true
							break
						else
							v3 = v3.sibling
						end
					end

					if not v4 then
						local v5 = alternate2.child

						while v5 do
							if v5 == v2 then
								v = return_
								v2 = alternate2
								v4 = true
								break
							elseif v5 == v then
								v = alternate2
								v2 = return_
								v4 = true
								break
							else
								v5 = v5.sibling
							end
						end

						invariant(
							v4,
							"Child was not found in either parent set. This indicates a bug in React related to the return pointer. Please file an issue."
						)
					end
				else
					v = alternate2
					v2 = return_
				end

				invariant(
					v2.alternate == v,
					"Return fibers should always be each others' alternates. This error is likely caused by a bug in React. Please file an issue."
				)
			end
		end

		invariant(v2.tag == HostRoot, "Unable to find node on an unmounted component.")
		return if v2.stateNode.current == v2 then p else alternate
	else
		local nearestMountedFiber = getNearestMountedFiber(p)
		invariant(nearestMountedFiber ~= nil, "Unable to find node on an unmounted component.")
		return if nearestMountedFiber == p then p else nil
	end
end

ReactFiberTreeReflection.findCurrentFiberUsingSlowPath = findCurrentFiberUsingSlowPath

function ReactFiberTreeReflection.findCurrentHostFiber(p)
	local currentFiberUsingSlowPath = findCurrentFiberUsingSlowPath(p)

	if not currentFiberUsingSlowPath then
		return nil
	end

	local result = currentFiberUsingSlowPath

	while true do
		local child = result.child

		if result.tag == HostComponent or result.tag == HostText then
			return result
		end

		if child then
			child.return_ = result
			result = child
		else
			if result == currentFiberUsingSlowPath then
				return nil
			end

			local return_ = result.return_
			result = result.sibling

			while not result do
				if not return_ or return_ == currentFiberUsingSlowPath then
					return nil
				end
			end

			result.return_ = return_
		end
	end
end

function ReactFiberTreeReflection.findCurrentHostFiberWithNoPortals(p)
	local currentFiberUsingSlowPath = findCurrentFiberUsingSlowPath(p)

	if not currentFiberUsingSlowPath then
		return nil
	end

	local result = currentFiberUsingSlowPath

	while true do
		local child = result.child

		if
			result.tag == HostComponent
			or result.tag == HostText
			or enableFundamentalAPI and result.tag == FundamentalComponent
		then
			return result
		end

		if child and result.tag ~= HostPortal then
			child.return_ = result
			result = child
		else
			if result == currentFiberUsingSlowPath then
				return nil
			end

			local return_ = result.return_
			result = result.sibling

			while not result do
				if not return_ or return_ == currentFiberUsingSlowPath then
					return nil
				end
			end

			result.return_ = return_
		end
	end
end

function ReactFiberTreeReflection.isFiberSuspenseAndTimedOut(p): boolean
	local memoizedState = p.memoizedState
	return p.tag == SuspenseComponent and memoizedState ~= nil and memoizedState.dehydrated == nil
end

function ReactFiberTreeReflection.doesFiberContain(p, p2): boolean
	local alternate = p.alternate

	while p2 ~= nil do
		if p2 == p or p2 == alternate then
			return true
		end

		p2 = p2.return_
	end

	return false
end

return ReactFiberTreeReflection
