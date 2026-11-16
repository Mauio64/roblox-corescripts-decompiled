local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Number = LuauPolyfill.Number
local Error = LuauPolyfill.Error

local Shared = require(parent.Shared)
local console = Shared.console

local Shared2 = require(parent.Shared)
local enableAllocationTrims = Shared2.ReactFeatureFlags.enableAllocationTrims

require(parent.Shared)

require(script.Parent.ReactInternalTypes)

local ReactFiberStacknew = require(script.Parent["ReactFiberStack.new"])

local ReactFiberLane = require(script.Parent.ReactFiberLane)

local ReactUpdateQueuenew = require(script.Parent["ReactUpdateQueue.new"])

local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)
local isPrimaryRenderer = ReactFiberHostConfig.isPrimaryRenderer
local createCursor = ReactFiberStacknew.createCursor
local push = ReactFiberStacknew.push
local pop = ReactFiberStacknew.pop
local MaxInts = require(script.Parent.MaxInts)
local MAX_SIGNED_31_BIT_INT = MaxInts.MAX_SIGNED_31_BIT_INT
local ReactWorkTags = require(script.Parent.ReactWorkTags)
local ContextProvider = ReactWorkTags.ContextProvider
local ClassComponent = ReactWorkTags.ClassComponent

local NoLanes = ReactFiberLane.NoLanes
local NoTimestamp = ReactFiberLane.NoTimestamp
local isSubsetOfLanes = ReactFiberLane.isSubsetOfLanes
local includesSomeLane = ReactFiberLane.includesSomeLane
local mergeLanes = ReactFiberLane.mergeLanes
local pickArbitraryLane = ReactFiberLane.pickArbitraryLane

local Shared3 = require(parent.Shared)
local objectIs = Shared3.objectIs
local createUpdate = ReactUpdateQueuenew.createUpdate
local ForceUpdate = ReactUpdateQueuenew.ForceUpdate

local New = {}

local cursor = createCursor(nil)

local currentRenderer = ReactGlobals.__DEV__ and {} or nil

local v = nil
local v2 = nil
local v3 = nil

local v4 = false

function New.resetContextDependencies()
	v = nil
	v2 = nil
	v3 = nil

	if ReactGlobals.__DEV__ then
		v4 = false
	end
end

function New.enterDisallowedContextReadInDEV()
	if ReactGlobals.__DEV__ then
		v4 = true
	end
end

function New.exitDisallowedContextReadInDEV()
	if ReactGlobals.__DEV__ then
		v4 = false
	end
end

function New.pushProvider(p, currentValue)
	local context = p.type._context

	if isPrimaryRenderer then
		push(cursor, context._currentValue, p)

		context._currentValue = currentValue

		if ReactGlobals.__DEV__ then
			if context._currentRenderer ~= nil and context._currentRenderer ~= currentRenderer then
				console.error("Detected multiple renderers concurrently rendering the same context provider. This is currently unsupported.")
			end

			context._currentRenderer = currentRenderer
		end
	else
		push(cursor, context._currentValue2, p)

		context._currentValue2 = currentValue

		if ReactGlobals.__DEV__ then
			if context._currentRenderer2 ~= nil and context._currentRenderer2 ~= currentRenderer then
				console.error("Detected multiple renderers concurrently rendering the same context provider. This is currently unsupported.")
			end

			context._currentRenderer2 = currentRenderer
		end
	end
end

function New.popProvider(p)
	local current = cursor.current

	pop(cursor, p)

	local context = p.type._context

	if isPrimaryRenderer then
		context._currentValue = current
	else
		context._currentValue2 = current
	end
end

function New:calculateChangedBits(p, p2)
	if objectIs(p2, p) then
		return 0
	end

	local v5 = MAX_SIGNED_31_BIT_INT

	if typeof(self._calculateChangedBits) == "function" then
		v5 = self._calculateChangedBits(p2, p)
	end

	return (math.floor(v5))
end

function New.scheduleWorkOnParentPath(state, p)
	while state ~= nil do
		local alternate = state.alternate

		if isSubsetOfLanes(state.childLanes, p) then
			if alternate == nil or isSubsetOfLanes(alternate.childLanes, p) then
				break
			end

			alternate.childLanes = mergeLanes(alternate.childLanes, p)
		else
			state.childLanes = mergeLanes(state.childLanes, p)

			if alternate ~= nil then
				alternate.childLanes = mergeLanes(alternate.childLanes, p)
			end
		end

		state = state.return_
	end
end

function New.propagateContextChange(return_, p, p2: number, p3)
	local return_2 = return_.child

	if return_2 ~= nil then
		return_2.return_ = return_
	end

	while return_2 ~= nil do
		local dependencies = return_2.dependencies
		local v5

		if dependencies == nil then
			if return_2.tag == ContextProvider then
				if return_2.type ~= return_.type then
					v5 = return_2.child
				end
			else
				v5 = return_2.child
			end
		else
			v5 = return_2.child

			local v6 = dependencies.firstContext

			while v6 ~= nil do
				if v6.context == p and bit32.band(v6.observedBits, p2) ~= 0 then
					if return_2.tag == ClassComponent then
						local update = createUpdate(NoTimestamp, pickArbitraryLane(p3))
						update.tag = ForceUpdate

						local updateQueue = return_2.updateQueue

						if updateQueue ~= nil then
							local Shared4 = updateQueue.shared
							local pending = Shared4.pending

							if pending == nil then
								update.next = update
							else
								update.next = pending.next
								pending.next = update
							end

							Shared4.pending = update
						end
					end

					return_2.lanes = bit32.bor(return_2.lanes, p3)
					local alternate = return_2.alternate

					if alternate ~= nil then
						alternate.lanes = bit32.bor(alternate.lanes, p3)
					end

					New.scheduleWorkOnParentPath(return_2.return_, p3)

					dependencies.lanes = bit32.bor(dependencies.lanes, p3)
					break
				end

				v6 = v6.next
			end
		end

		if v5 == nil then
			v5 = return_2

			while v5 ~= nil do
				if v5 == return_ then
					v5 = nil
					break
				end

				local sibling = v5.sibling

				if sibling == nil then
					v5 = v5.return_
				else
					sibling.return_ = v5.return_
					v5 = sibling
					break
				end
			end
		else
			v5.return_ = return_2
		end

		return_2 = v5
	end
end

function New.prepareToReadContext(p, p2, callback)
	v = p
	v2 = nil
	v3 = nil

	local dependencies = p.dependencies

	if dependencies ~= nil and dependencies.firstContext ~= nil then
		if includesSomeLane(dependencies.lanes, p2) then
			callback()
		end

		dependencies.firstContext = nil
	end
end

function New:readContext(observedBits)
	if ReactGlobals.__DEV__ and v4 then
		console.error("Context can only be read while React is rendering. In classes, you can read it in the render method or getDerivedStateFromProps. In function components, you can read it directly in the function body, but not inside Hooks like useReducer() or useMemo().")
	end

	if v3 ~= self and observedBits ~= false and observedBits ~= 0 then
		if typeof(observedBits) ~= "number" or observedBits == Number.MAX_SAFE_INTEGER then
			v3 = self
			observedBits = Number.MAX_SAFE_INTEGER
		end

		local v5 = enableAllocationTrims and { context = self, observedBits = observedBits }
			or { context = self, observedBits = observedBits, next = nil }

		if v2 == nil then
			if v == nil then
				error(Error.new("Context can only be read while React is rendering. In classes, you can read it in the render method or getDerivedStateFromProps. In function components, you can read it directly in the function body, but not inside Hooks like useReducer() or useMemo()."))
			end

			v2 = v5

			if enableAllocationTrims then
				local dependencies = v.dependencies

				if dependencies == nil then
					v.dependencies = { lanes = NoLanes, firstContext = v5 }
				else
					dependencies.lanes = NoLanes
					dependencies.firstContext = v5
				end
			else
				v.dependencies = { lanes = NoLanes, firstContext = v5, responders = nil }
			end
		else
			v2.next = v5
			v2 = v5
		end
	end

	if isPrimaryRenderer then
		return self._currentValue
	end

	return self._currentValue2
end

return New
