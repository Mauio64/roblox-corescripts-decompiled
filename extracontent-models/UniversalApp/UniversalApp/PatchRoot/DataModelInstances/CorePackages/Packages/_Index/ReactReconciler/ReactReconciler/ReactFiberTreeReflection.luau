local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(ParentParent.Shared).console

require(script.Parent.ReactInternalTypes)
require(script.Parent.ReactFiberHostConfig)
require(script.Parent["ReactFiberSuspenseComponent.new"])

local invariant = require(ParentParent.Shared).invariant
local get = require(ParentParent.Shared).ReactInstanceMap.get
local ReactSharedInternals = require(ParentParent.Shared).ReactSharedInternals
local getComponentName = require(ParentParent.Shared).getComponentName
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
local enableFundamentalAPI = require(ParentParent.Shared).ReactFeatureFlags.enableFundamentalAPI
local ReactCurrentOwner = ReactSharedInternals.ReactCurrentOwner
local t1 = {}

local function getNearestMountedFiber(p1) -- line: 50
	-- upvalues: Placement (copy), Hydrating (copy), NoFlags (copy), HostRoot (copy)
	local v27 = p1

	if not p1.alternate then
		local v28 = p1

		repeat
			p1 = v28

			if bit32.band(p1.flags, (bit32.bor(Placement, Hydrating))) ~= NoFlags then
				v27 = p1.return_
			end

			v28 = p1.return_
		until not v28
	else
		while p1.return_ do
			p1 = p1.return_
		end
	end

	if p1.tag == HostRoot then
		return v27
	end

	return nil
end

t1.getNearestMountedFiber = getNearestMountedFiber

function t1.getSuspenseInstanceFromFiber(p2) -- line: 84
	-- upvalues: SuspenseComponent (copy)
	if p2.tag == SuspenseComponent then
		local memoizedState = p2.memoizedState

		if memoizedState == nil then
			local alternate = p2.alternate

			if alternate ~= nil then
				memoizedState = alternate.memoizedState
			end
		end

		if memoizedState then
			return memoizedState.dehydrated
		end
	end

	return nil
end
function t1.getContainerFromFiber(p3) -- line: 100
	-- upvalues: HostRoot (copy)
	if p3.tag == HostRoot then
		return p3.stateNode.containerInfo
	end

	return nil
end
function t1.isFiberMounted(p4) -- line: 104
	-- upvalues: getNearestMountedFiber (copy)
	return p4 == getNearestMountedFiber(p4)
end
function t1.isMounted(p5) -- line: 110
	-- upvalues: ReactGlobals (copy), ReactCurrentOwner (copy), ClassComponent (copy), console (copy), getComponentName (copy), get (copy), getNearestMountedFiber (copy)
	if ReactGlobals.__DEV__ then
		local current = ReactCurrentOwner.current

		if current ~= nil and current.tag == ClassComponent then
			local stateNode = current.stateNode

			if not stateNode._warnedAboutRefsInRender then
				console.error("%s is accessing isMounted inside its render() function. render() should be a pure function of props and state. It should never access something that requires stale data from the previous render, such as refs. Move this logic to componentDidMount and componentDidUpdate instead.", getComponentName(current.type) or "A component")
			end

			stateNode._warnedAboutRefsInRender = true
		end
	end

	local v37 = get(p5)

	if not v37 then
		return false
	end

	return v37 == getNearestMountedFiber(v37)
end

local function assertIsMounted(p6) -- line: 140
	-- upvalues: invariant (copy), getNearestMountedFiber (copy)
	invariant(p6 == getNearestMountedFiber(p6), "Unable to find node on an unmounted component.")
end
local function findCurrentFiberUsingSlowPath(p7) -- line: 147
	-- upvalues: getNearestMountedFiber (copy), invariant (copy), HostRoot (copy)
	local alternate = p7.alternate

	if not alternate then
		local v41 = getNearestMountedFiber(p7)

		invariant(v41 ~= nil, "Unable to find node on an unmounted component.")

		if v41 ~= p7 then
			return nil
		end

		return p7
	end

	local v42 = p7
	local v43 = alternate

	while true do
		local return_ = v42.return_

		if return_ == nil then
			break
		end

		local alternate2 = return_.alternate

		if alternate2 ~= nil then
			if return_.child == alternate2.child then
				local child = return_.child

				while child do
					if child == v42 then
						invariant(return_ == getNearestMountedFiber(return_), "Unable to find node on an unmounted component.")

						return p7
					end

					if child == v43 then
						invariant(return_ == getNearestMountedFiber(return_), "Unable to find node on an unmounted component.")

						return alternate
					end

					child = child.sibling
				end

				invariant(false, "Unable to find node on an unmounted component.")
			end

			if v42.return_ ~= v43.return_ then
				v42 = return_
				v43 = alternate2
			else
				local v47 = false
				local child = return_.child

				while child do
					if child == v42 then
						v47 = true
						v42 = return_
						v43 = alternate2

						break
					end

					if child == v43 then
						v47 = true
						v43 = return_
						v42 = alternate2

						break
					end

					child = child.sibling
				end

				if not v47 then
					local child2 = alternate2.child

					while child2 do
						if child2 == v42 then
							v47 = true
							v42 = alternate2
							v43 = return_

							break
						end

						if child2 == v43 then
							v47 = true
							v43 = alternate2
							v42 = return_

							break
						end

						child2 = child2.sibling
					end

					invariant(v47, "Child was not found in either parent set. This indicates a bug in React related to the return pointer. Please file an issue.")
				end
			end

			invariant(v43 == v42.alternate, "Return fibers should always be each others' alternates. This error is likely caused by a bug in React. Please file an issue.")

			continue
		end

		v43 = return_.return_

		if v43 == nil then
			break
		end

		v42 = v43
	end

	invariant(v42.tag == HostRoot, "Unable to find node on an unmounted component.")

	if v42 == v42.stateNode.current then
		return p7
	end

	return alternate
end

t1.findCurrentFiberUsingSlowPath = findCurrentFiberUsingSlowPath

function t1.findCurrentHostFiber(p8) -- line: 282
	-- upvalues: findCurrentFiberUsingSlowPath (copy), HostComponent (copy), HostText (copy)
	local v51 = findCurrentFiberUsingSlowPath(p8)

	if not v51 then
		return nil
	end

	local v52 = v51

	while true do
		local child = v52.child

		if v52.tag == HostComponent or v52.tag == HostText then
			break
		end

		if not child then
			if v52 == v51 then
				return nil
			end

			local return_ = v52.return_

			v52 = v52.sibling

			while not v52 do
				if not return_ or return_ == v51 then
					return nil
				end
			end

			v52.return_ = return_

			continue
		end

		child.return_ = v52
		v52 = child
	end

	return v52
end
function t1.findCurrentHostFiberWithNoPortals(p9) -- line: 321
	-- upvalues: findCurrentFiberUsingSlowPath (copy), HostComponent (copy), HostText (copy), enableFundamentalAPI (copy), FundamentalComponent (copy), HostPortal (copy)
	local v56 = findCurrentFiberUsingSlowPath(p9)

	if not v56 then
		return nil
	end

	local v57 = v56

	while true do
		local child = v57.child

		if v57.tag == HostComponent or v57.tag == HostText or enableFundamentalAPI and v57.tag == FundamentalComponent then
			break
		end

		if not child or v57.tag == HostPortal then
			if v57 == v56 then
				return nil
			end

			local return_ = v57.return_

			v57 = v57.sibling

			while not v57 do
				if not return_ or return_ == v56 then
					return nil
				end
			end

			v57.return_ = return_

			continue
		end

		child.return_ = v57
		v57 = child
	end

	return v57
end
function t1.isFiberSuspenseAndTimedOut(p10) -- line: 363
	-- upvalues: SuspenseComponent (copy)
	local memoizedState = p10.memoizedState

	return p10.tag == SuspenseComponent and (memoizedState ~= nil and memoizedState.dehydrated == nil)
end
function t1.doesFiberContain(p11, p12) -- line: 370
	local alternate = p11.alternate

	while p12 ~= nil do
		if p12 == p11 or p12 == alternate then
			return true
		end

		p12 = p12.return_
	end

	return false
end

return t1
