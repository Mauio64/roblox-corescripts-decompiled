local parent = script.Parent.Parent

local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Set = LuauPolyfill.Set

require(parent.Shared)

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
local Shared = require(parent.Shared)
local ReactSymbols = Shared.ReactSymbols
local REACT_FORWARD_REF_TYPE = ReactSymbols.REACT_FORWARD_REF_TYPE
local REACT_MEMO_TYPE = ReactSymbols.REACT_MEMO_TYPE
local REACT_LAZY_TYPE = ReactSymbols.REACT_LAZY_TYPE

local __DEV__ = ReactGlobals.__DEV__

local v = nil

local v2 = nil

local findChildHostInstancesForFiberShallowly
local findHostInstancesForFiberShallowly
local findHostInstancesForMatchingFibersRecursively
local scheduleFibersWithFamiliesRecursively
local New = {}

function New.setRefreshHandler(callback)
	if __DEV__ then
		v = callback
	end
end

local function resolveFunctionForHotReloading(p) -- 2 equivalent calls inferred from this helper
	if not (__DEV__ and v ~= nil) then
		return p
	end

	local v3 = v(p)
	return if v3 == nil then p else v3.current
end

New.resolveFunctionForHotReloading = resolveFunctionForHotReloading

function New.resolveClassForHotReloading(p)
	return resolveFunctionForHotReloading(p) -- inferred equivalent call
end

function New.resolveForwardRefForHotReloading(p)
	if not (__DEV__ and v ~= nil) then
		return p
	end

	local v3 = v(p)

	if v3 ~= nil then
		return v3.current
	end

	if p == nil or typeof(p.render) ~= "function" then
		return p
	end

	local functionForHotReloading = resolveFunctionForHotReloading(p.render) -- inferred equivalent call

	if p.render == functionForHotReloading then
		return p
	end

	local v4 = {
		["$$typeof"] = REACT_FORWARD_REF_TYPE,
		render = functionForHotReloading,
		displayName = nil
	}

	if p.displayName ~= nil then
		v4.displayName = p.displayName
	end

	return v4
end

function New.isCompatibleFamilyForHotReloading(p, p2): boolean
	if not (__DEV__ and v ~= nil) then
		return false
	end

	local elementType = p.elementType
	local kind = p2.type
	local Typeof

	if typeof(kind) == "table" and kind ~= nil then
		Typeof = kind["$$typeof"]
	end

	local tag = p.tag
	local v3

	if tag == ClassComponent then
		v3 = typeof(kind) == "function" or false
	elseif tag == FunctionComponent then
		v3 = typeof(kind) == "function" or (Typeof == REACT_LAZY_TYPE or false)
	elseif tag == ForwardRef then
		v3 = Typeof == REACT_FORWARD_REF_TYPE or (Typeof == REACT_LAZY_TYPE or false)
	elseif tag == MemoComponent or tag == SimpleMemoComponent then
		v3 = Typeof == REACT_MEMO_TYPE or (Typeof == REACT_LAZY_TYPE or false)
	else
		return false
	end

	if v3 then
		local v4 = v(elementType)

		if v4 ~= nil and v4 == v(kind) then
			return true
		end
	end

	return false
end

function New.markFailedErrorBoundaryForHotReloading(p)
	if __DEV__ then
		if v == nil then
			return
		end

		if v2 == nil then
			v2 = Set.new()
		end

		v2:add(p)
	end
end

function New.scheduleRefresh(p, p2)
	if __DEV__ then
		if v == nil then
			return
		end

		local staleFamilies = p2.staleFamilies
		local updatedFamilies = p2.updatedFamilies
		local ReactFiberWorkLoopnew = require(script.Parent["ReactFiberWorkLoop.new"])
		local flushPassiveEffects = ReactFiberWorkLoopnew.flushPassiveEffects
		local flushSync = ReactFiberWorkLoopnew.flushSync
		flushPassiveEffects()
		flushSync(function()
			scheduleFibersWithFamiliesRecursively(p.current, updatedFamilies, staleFamilies)
		end)
	end
end

function New.scheduleRoot(p, p2)
	if __DEV__ then
		local ReactFiberContextnew = require(script.Parent["ReactFiberContext.new"])
		local emptyContextObject = ReactFiberContextnew.emptyContextObject

		if p.context ~= emptyContextObject then
			return
		end

		local ReactFiberWorkLoopnew = require(script.Parent["ReactFiberWorkLoop.new"])
		local flushPassiveEffects = ReactFiberWorkLoopnew.flushPassiveEffects
		local flushSync = ReactFiberWorkLoopnew.flushSync
		flushPassiveEffects()
		flushSync(function()
			local ReactFiberReconcilernew = require(script.Parent["ReactFiberReconciler.new"])
			ReactFiberReconcilernew.updateContainer(p2, p, nil, nil)
		end)
	end
end

scheduleFibersWithFamiliesRecursively = function(current, updatedFamilies, staleFamilies)
	if __DEV__ then
		local alternate = current.alternate
		local child = current.child
		local sibling = current.sibling
		local tag = current.tag
		local kind = current.type
		local v3 = nil

		if tag == FunctionComponent or tag == SimpleMemoComponent or tag == ClassComponent then
			v3 = kind
		elseif tag == ForwardRef then
			v3 = kind.render
		end

		if v == nil then
			error(Error.new("Expected resolveFamily to be set during hot reload."))
		end

		local v4 = false
		local v5 = false

		if v3 ~= nil then
			local v6 = v(v3)

			if v6 ~= nil then
				if staleFamilies:has(v6) then
					v5 = true
				elseif updatedFamilies:has(v6) then
					if tag == ClassComponent then
						v5 = true
					else
						v4 = true
					end
				end
			end
		end

		local v6 = v2 ~= nil and (v2:has(current) or alternate ~= nil and v2:has(alternate)) and true or v5

		if v6 then
			current._debugNeedsRemount = true
		end

		if v6 or v4 then
			local ReactFiberWorkLoopnew = require(script.Parent["ReactFiberWorkLoop.new"])
			ReactFiberWorkLoopnew.scheduleUpdateOnFiber(current, SyncLane, NoTimestamp)
		end

		if child ~= nil and not v6 then
			scheduleFibersWithFamiliesRecursively(child, updatedFamilies, staleFamilies)
		end

		if sibling ~= nil then
			scheduleFibersWithFamiliesRecursively(sibling, updatedFamilies, staleFamilies)
		end
	end
end

function New.findHostInstancesForRefresh(p, p2)
	if not __DEV__ then
		error(Error.new("Did not expect findHostInstancesForRefresh to be called in production."))

		return
	end

	local v3 = Set.new()
	local v4 = Set.new(Array.map(p2, function(p3)
		return p3.current
	end))

	findHostInstancesForMatchingFibersRecursively(p.current, v4, v3)
	return v3
end

findHostInstancesForMatchingFibersRecursively = function(current, object, p)
	if __DEV__ then
		local child = current.child
		local sibling = current.sibling
		local tag = current.tag
		local kind = current.type
		local v3 = nil

		if tag == FunctionComponent or tag == SimpleMemoComponent or tag == ClassComponent then
			v3 = kind
		elseif tag == ForwardRef then
			v3 = kind.render
		end

		if v3 ~= nil and object:has(v3) then
			findHostInstancesForFiberShallowly(current, p)
		elseif child ~= nil then
			findHostInstancesForMatchingFibersRecursively(child, object, p)
		end

		if sibling ~= nil then
			findHostInstancesForMatchingFibersRecursively(sibling, object, p)
		end
	end
end

findHostInstancesForFiberShallowly = function(data, object)
	if not __DEV__ or findChildHostInstancesForFiberShallowly(data, object) then
		return
	end

	while true do
		local tag = data.tag

		if tag == HostComponent then
			break
		end

		if tag == HostPortal then
			object:add(data.stateNode.containerInfo)
			return
		end

		if tag == HostRoot then
			object:add(data.stateNode.containerInfo)
			return
		end

		if data.return_ == nil then
			error(Error.new("Expected to reach root first."))
		end

		data = data.return_
	end

	object:add(data.stateNode)
end

findChildHostInstancesForFiberShallowly = function(data, object)
	-- [TOVEK] Lenient mode required for this code
	-- The code below is rebuilt as a state machine
	-- due to not being representable otherwise
	local return_, v3
	local controlFlowState = 16

	while true do
		if controlFlowState == 0 then
			return false
		end

		if controlFlowState == 1 then
			object:add(return_.stateNode)
			v3 = true
			controlFlowState = 3
		elseif controlFlowState == 2 then
			if return_.child == nil then
				controlFlowState = 14
			else
				controlFlowState = 4
			end
		elseif controlFlowState == 3 then
			controlFlowState = if return_ == data then 6 else 13
		elseif controlFlowState == 4 then
			return_.child.return_ = return_
			return_ = return_.child
			controlFlowState = 5
		else
			if controlFlowState == 5 then
				controlFlowState = 15
				continue
			end

			if controlFlowState == 6 then
				return v3
			end

			if controlFlowState == 7 then
				if return_.sibling == nil then
					controlFlowState = 8
				else
					controlFlowState = 9
				end
			elseif controlFlowState == 8 then
				if return_.return_ == nil or return_.return_ == data then
					controlFlowState = 10
				else
					controlFlowState = 11
				end
			elseif controlFlowState == 9 then
				assert(return_.sibling ~= nil, "should be non-nil")
				return_.sibling.return_ = return_.return_
				return_ = return_.sibling
				controlFlowState = 5
			else
				if controlFlowState == 10 then
					return v3
				end

				if controlFlowState == 11 then
					return_ = return_.return_
					controlFlowState = 7
				elseif controlFlowState == 12 then
					return_ = data
					v3 = false
					controlFlowState = 15
				else
					if controlFlowState == 13 then
						controlFlowState = 7
						continue
					end

					if controlFlowState == 14 then
						controlFlowState = 3
						continue
					end

					if controlFlowState == 15 then
						if return_.tag == HostComponent then
							controlFlowState = 1
						else
							controlFlowState = 2
						end
					else
						if controlFlowState ~= 16 then
							break
						end

						if __DEV__ then
							controlFlowState = 12
						else
							controlFlowState = 0
						end
					end
				end
			end
		end

		continue
	end
end

return New
