local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Set = LuauPolyfill.Set

require(ParentParent.Shared)
require(script.Parent.ReactInternalTypes)
require(script.Parent.ReactFiberHostConfig)

local ReactFiberLane = require(script.Parent.ReactFiberLane)
local SyncLane = ReactFiberLane.SyncLane
local NoTimestamp = ReactFiberLane.NoTimestamp
local ReactWorkTags = require(script.Parent.ReactWorkTags)
local ClassComponent = ReactWorkTags.ClassComponent
local FunctionComponent = ReactWorkTags.FunctionComponent
local ForwardRef = ReactWorkTags.ForwardRef
local HostComponent = ReactWorkTags.HostComponent
local HostPortal = ReactWorkTags.HostPortal
local HostRoot = ReactWorkTags.HostRoot
local MemoComponent = ReactWorkTags.MemoComponent
local SimpleMemoComponent = ReactWorkTags.SimpleMemoComponent
local ReactSymbols = require(ParentParent.Shared).ReactSymbols
local REACT_FORWARD_REF_TYPE = ReactSymbols.REACT_FORWARD_REF_TYPE
local REACT_MEMO_TYPE = ReactSymbols.REACT_MEMO_TYPE
local REACT_LAZY_TYPE = ReactSymbols.REACT_LAZY_TYPE
local __DEV__ = ReactGlobals.__DEV__
local u24 = nil
local u25 = nil
local t1 = {}
local findChildHostInstancesForFiberShallowly = nil
local findHostInstancesForFiberShallowly = nil
local findHostInstancesForMatchingFibersRecursively = nil
local scheduleFibersWithFamiliesRecursively = nil

function t1.setRefreshHandler(p1: ((...any) -> ...any)?) -- line: 92
	-- upvalues: __DEV__ (copy), u24 (ref)
	if __DEV__ then
		u24 = p1
	end
end
function t1.resolveFunctionForHotReloading(p2) -- line: 99
	-- upvalues: __DEV__ (copy), u24 (ref)
	if __DEV__ then
		if u24 == nil then
			return p2
		end

		local v33 = u24(p2)

		if v33 == nil then
			return p2
		end

		return v33.current
	end

	return p2
end
function t1.resolveClassForHotReloading(p3) -- line: 117
	-- upvalues: __DEV__ (copy), u24 (ref)
	if __DEV__ then
		if u24 == nil then
			return p3
		end

		local v35 = u24(p3)

		if v35 == nil then
			return p3
		end

		return v35.current
	end

	return p3
end
function t1.resolveForwardRefForHotReloading(p4) -- line: 123
	-- upvalues: __DEV__ (copy), u24 (ref), REACT_FORWARD_REF_TYPE (copy)
	if __DEV__ then
		if u24 == nil then
			return p4
		end

		local v37 = u24(p4)

		if v37 == nil then
			if p4 ~= nil and typeof(p4.render) == "function" then
				local render = p4.render

				if __DEV__ then
					if u24 == nil then
					else
						local v39 = u24(render)

						render = if v39 ~= nil then v39.current else render
					end
				end

				if render ~= p4.render then
					local t2 = {
						["$$typeof"] = REACT_FORWARD_REF_TYPE,
						render = render,
						displayName = nil
					}

					if p4.displayName ~= nil then
						t2.displayName = p4.displayName
					end

					return t2
				end
			end

			return p4
		end

		return v37.current
	end

	return p4
end
function t1.isCompatibleFamilyForHotReloading(p5, p6) -- line: 160
	-- upvalues: __DEV__ (copy), u24 (ref), ClassComponent (copy), FunctionComponent (copy), REACT_LAZY_TYPE (copy), ForwardRef (copy), REACT_FORWARD_REF_TYPE (copy), MemoComponent (copy), SimpleMemoComponent (copy), REACT_MEMO_TYPE (copy)
	if __DEV__ then
		if u24 == nil then
			return false
		end

		local elementType = p5.elementType
		local type = p6.type
		local v45 = false
		local v46 = if typeof(type) ~= "table" or type == nil then nil else type["$$typeof"]
		local tag = p5.tag

		if tag == ClassComponent then
			if typeof(type) == "function" then
				v45 = true
			end
		elseif tag == FunctionComponent then
			if typeof(type) == "function" then
				v45 = true
			elseif v46 == REACT_LAZY_TYPE then
				v45 = true
			end
		elseif tag == ForwardRef then
			if v46 == REACT_FORWARD_REF_TYPE then
				v45 = true
			elseif v46 == REACT_LAZY_TYPE then
				v45 = true
			end
		else
			if tag ~= MemoComponent and tag ~= SimpleMemoComponent then
				return false
			end

			if v46 == REACT_MEMO_TYPE then
				v45 = true
			elseif v46 == REACT_LAZY_TYPE then
				v45 = true
			end
		end

		if v45 then
			local v48 = u24(elementType)

			if v48 ~= nil and v48 == u24(type) then
				return true
			end
		end

		return false
	end

	return false
end
function t1.markFailedErrorBoundaryForHotReloading(p7) -- line: 247
	-- upvalues: __DEV__ (copy), u24 (ref), u25 (ref), Set (copy)
	if __DEV__ then
		if u24 == nil then
			return
		end

		if u25 == nil then
			u25 = Set.new()
		end

		u25:add(p7)
	end
end
function t1.scheduleRefresh(p8, t3: {[any]: any}) -- line: 267
	-- upvalues: __DEV__ (copy), u24 (ref), scheduleFibersWithFamiliesRecursively (ref)
	if __DEV__ then
		if u24 == nil then
			return
		end

		local staleFamilies = t3.staleFamilies
		local updatedFamilies = t3.updatedFamilies
		local lib = require(script.Parent["ReactFiberWorkLoop.new"])
		local flushPassiveEffects = lib.flushPassiveEffects
		local flushSync = lib.flushSync

		flushPassiveEffects()
		flushSync(function() -- line: 279
			-- upvalues: scheduleFibersWithFamiliesRecursively (ref), p8 (copy), updatedFamilies (copy), staleFamilies (copy)
			scheduleFibersWithFamiliesRecursively(p8.current, updatedFamilies, staleFamilies)
		end)
	end
end
function t1.scheduleRoot(p9, p10) -- line: 291
	-- upvalues: __DEV__ (copy)
	if __DEV__ then
		if require(script.Parent["ReactFiberContext.new"]).emptyContextObject ~= p9.context then
			return
		end

		local lib = require(script.Parent["ReactFiberWorkLoop.new"])
		local flushPassiveEffects = lib.flushPassiveEffects
		local flushSync = lib.flushSync

		flushPassiveEffects()
		flushSync(function() -- line: 306
			-- upvalues: p10 (copy), p9 (copy)
			require(script.Parent["ReactFiberReconciler.new"]).updateContainer(p10, p9, nil, nil)
		end)
	end
end
function scheduleFibersWithFamiliesRecursively(p11, p12, p13) -- line: 316
	-- upvalues: __DEV__ (copy), FunctionComponent (copy), SimpleMemoComponent (copy), ClassComponent (copy), ForwardRef (copy), u24 (ref), Error (copy), u25 (ref), SyncLane (copy), NoTimestamp (copy), scheduleFibersWithFamiliesRecursively (ref)
	if __DEV__ then
		local alternate = p11.alternate
		local child = p11.child
		local sibling = p11.sibling
		local tag = p11.tag
		local type = p11.type
		local v70 = nil

		if tag == FunctionComponent or tag == SimpleMemoComponent or tag == ClassComponent then
			v70 = type
		elseif tag == ForwardRef then
			v70 = type.render
		end

		if u24 == nil then
			error(Error.new("Expected resolveFamily to be set during hot reload."))
		end

		local v71 = false
		local v72 = false

		if v70 ~= nil then
			local v73 = u24(v70)

			if v73 ~= nil then
				if p13:has(v73) then
					v72 = true
				elseif p12:has(v73) then
					if tag == ClassComponent then
						v72 = true
					else
						v71 = true
					end
				end
			end
		end

		if u25 ~= nil and (u25:has(p11) or alternate ~= nil and u25:has(alternate)) then
			v72 = true
		end

		if v72 then
			p11._debugNeedsRemount = true
		end

		if v72 or v71 then
			require(script.Parent["ReactFiberWorkLoop.new"]).scheduleUpdateOnFiber(p11, SyncLane, NoTimestamp)
		end

		if child ~= nil and not v72 then
			scheduleFibersWithFamiliesRecursively(child, p12, p13)
		end

		if sibling ~= nil then
			scheduleFibersWithFamiliesRecursively(sibling, p12, p13)
		end
	end
end
function t1.findHostInstancesForRefresh(p14, p15) -- line: 383
	-- upvalues: __DEV__ (copy), Set (copy), Array (copy), findHostInstancesForMatchingFibersRecursively (ref), Error (copy)
	if __DEV__ then
		local v76 = Set.new()
		local v77 = Set.new(Array.map(p15, function(p16) -- line: 389
			return p16.current
		end))

		findHostInstancesForMatchingFibersRecursively(p14.current, v77, v76)

		return v76
	end

	error(Error.new("Did not expect findHostInstancesForRefresh to be called in production."))
end
function findHostInstancesForMatchingFibersRecursively(p17, p18, p19) -- line: 404
	-- upvalues: __DEV__ (copy), FunctionComponent (copy), SimpleMemoComponent (copy), ClassComponent (copy), ForwardRef (copy), findHostInstancesForFiberShallowly (ref), findHostInstancesForMatchingFibersRecursively (ref)
	if __DEV__ then
		local child = p17.child
		local sibling = p17.sibling
		local tag = p17.tag
		local type = p17.type
		local v85 = nil

		if tag == FunctionComponent or tag == SimpleMemoComponent or tag == ClassComponent then
			v85 = type
		elseif tag == ForwardRef then
			v85 = type.render
		end

		if v85 ~= nil and p18:has(v85) then
			findHostInstancesForFiberShallowly(p17, p19)
		elseif child ~= nil then
			findHostInstancesForMatchingFibersRecursively(child, p18, p19)
		end

		if sibling ~= nil then
			findHostInstancesForMatchingFibersRecursively(sibling, p18, p19)
		end
	end
end
function findHostInstancesForFiberShallowly(p20, p21) -- line: 448
	-- upvalues: __DEV__ (copy), findChildHostInstancesForFiberShallowly (ref), HostComponent (copy), HostPortal (copy), HostRoot (copy), Error (copy)
	if __DEV__ then
		if findChildHostInstancesForFiberShallowly(p20, p21) then
			return
		end

		while true do
			local tag = p20.tag

			if tag == HostComponent then
				break
			end

			if tag == HostPortal then
				p21:add(p20.stateNode.containerInfo)

				return
			end

			if tag == HostRoot then
				p21:add(p20.stateNode.containerInfo)

				return
			end

			if p20.return_ == nil then
				error(Error.new("Expected to reach root first."))
			end

			p20 = p20.return_
		end

		p21:add(p20.stateNode)

		return
	end
end
function findChildHostInstancesForFiberShallowly(p22, p23) -- line: 480
	-- upvalues: __DEV__ (copy), HostComponent (copy)
	if not __DEV__ then
		return false
	end

	local v91 = p22
	local v92 = false
	local g94 = nil

	repeat
		local g93 = false

		while v91.tag ~= HostComponent do
			if v91.child == nil then
				g94 = true
			end

			if g94 then
				break
			end

			v91.child.return_ = v91
			v91 = v91.child
		end

		if not g94 then
			v92 = true
			p23:add(v91.stateNode)
		end

		g94 = false

		if v91 == p22 then
			return v92
		end

		while v91.sibling == nil do
			if v91.return_ == nil or p22 == v91.return_ then
				return v92
			end

			v91 = v91.return_
		end

		assert(v91.sibling ~= nil, "should be non-nil")
		v91.sibling.return_ = v91.return_
		v91 = v91.sibling
		g93 = true
	until not g93
end

return t1
