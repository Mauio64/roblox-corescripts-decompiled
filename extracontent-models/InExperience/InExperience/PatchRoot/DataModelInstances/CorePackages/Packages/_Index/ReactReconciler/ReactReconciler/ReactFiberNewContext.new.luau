local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Number = LuauPolyfill.Number
local Error = LuauPolyfill.Error
local console = require(ParentParent.Shared).console

require(ParentParent.Shared)
require(script.Parent.ReactInternalTypes)

local lib = require(script.Parent["ReactFiberStack.new"])
local ReactFiberLane = require(script.Parent.ReactFiberLane)
local lib2 = require(script.Parent["ReactUpdateQueue.new"])
local isPrimaryRenderer = require(script.Parent.ReactFiberHostConfig).isPrimaryRenderer
local createCursor = lib.createCursor
local push = lib.push
local pop = lib.pop
local MAX_SIGNED_31_BIT_INT = require(script.Parent.MaxInts).MAX_SIGNED_31_BIT_INT
local ReactWorkTags = require(script.Parent.ReactWorkTags)
local ContextProvider = ReactWorkTags.ContextProvider
local ClassComponent = ReactWorkTags.ClassComponent
local NoLanes = ReactFiberLane.NoLanes
local NoTimestamp = ReactFiberLane.NoTimestamp
local isSubsetOfLanes = ReactFiberLane.isSubsetOfLanes
local includesSomeLane = ReactFiberLane.includesSomeLane
local mergeLanes = ReactFiberLane.mergeLanes
local pickArbitraryLane = ReactFiberLane.pickArbitraryLane
local objectIs = require(ParentParent.Shared).objectIs
local createUpdate = lib2.createUpdate
local ForceUpdate = lib2.ForceUpdate
local t1 = {}
local v28 = createCursor(nil)
local t2 = nil

if ReactGlobals.__DEV__ then
	t2 = {}
end

local u30 = nil
local u31 = nil
local u32 = nil
local u33 = false

function t1.resetContextDependencies() -- line: 74
	-- upvalues: u30 (ref), u31 (ref), u32 (ref), ReactGlobals (copy), u33 (ref)
	u30 = nil
	u31 = nil
	u32 = nil

	if ReactGlobals.__DEV__ then
		u33 = false
	end
end
function t1.enterDisallowedContextReadInDEV() -- line: 85
	-- upvalues: ReactGlobals (copy), u33 (ref)
	if ReactGlobals.__DEV__ then
		u33 = true
	end
end
function t1.exitDisallowedContextReadInDEV() -- line: 91
	-- upvalues: ReactGlobals (copy), u33 (ref)
	if ReactGlobals.__DEV__ then
		u33 = false
	end
end
function t1.pushProvider(p1, p2) -- line: 97
	-- upvalues: isPrimaryRenderer (copy), push (copy), v28 (copy), ReactGlobals (copy), t2 (ref), console (copy)
	local _context = p1.type._context

	if isPrimaryRenderer then
		push(v28, _context._currentValue, p1)
		_context._currentValue = p2

		if ReactGlobals.__DEV__ then
			if _context._currentRenderer ~= nil and _context._currentRenderer ~= t2 then
				console.error("Detected multiple renderers concurrently rendering the same context provider. This is currently unsupported.")
			end

			_context._currentRenderer = t2

			return
		end
	else
		push(v28, _context._currentValue2, p1)
		_context._currentValue2 = p2

		if ReactGlobals.__DEV__ then
			if _context._currentRenderer2 ~= nil and _context._currentRenderer2 ~= t2 then
				console.error("Detected multiple renderers concurrently rendering the same context provider. This is currently unsupported.")
			end

			_context._currentRenderer2 = t2
		end
	end
end
function t1.popProvider(p3) -- line: 135
	-- upvalues: v28 (copy), pop (copy), isPrimaryRenderer (copy)
	local current = v28.current

	pop(v28, p3)

	local _context = p3.type._context

	if isPrimaryRenderer then
		_context._currentValue = current

		return
	end

	_context._currentValue2 = current
end
function t1.calculateChangedBits(p4, p5, p6) -- line: 148
	-- upvalues: objectIs (copy), MAX_SIGNED_31_BIT_INT (copy)
	if objectIs(p6, p5) then
		return 0
	end

	local v43 = MAX_SIGNED_31_BIT_INT

	if typeof(p4._calculateChangedBits) == "function" then
		v43 = p4._calculateChangedBits(p6, p5)
	end

	return (math.floor(v43))
end
function t1.scheduleWorkOnParentPath(p7, p8) -- line: 179
	-- upvalues: isSubsetOfLanes (copy), mergeLanes (copy)
	while p7 ~= nil do
		local alternate = p7.alternate

		if not isSubsetOfLanes(p7.childLanes, p8) then
			p7.childLanes = mergeLanes(p7.childLanes, p8)

			if alternate ~= nil then
				alternate.childLanes = mergeLanes(alternate.childLanes, p8)
			end
		else
			if alternate == nil or isSubsetOfLanes(alternate.childLanes, p8) then
				return
			end

			alternate.childLanes = mergeLanes(alternate.childLanes, p8)
		end

		p7 = p7.return_
	end
end
function t1.propagateContextChange(p9, p10, n1: number, p11) -- line: 202
	-- upvalues: ClassComponent (copy), createUpdate (copy), NoTimestamp (copy), pickArbitraryLane (copy), ForceUpdate (copy), t1 (copy), ContextProvider (copy)
	local child = p9.child

	if child ~= nil then
		child.return_ = p9
	end

	while child ~= nil do
		local dependencies = child.dependencies
		local child2

		if dependencies ~= nil then
			child2 = child.child

			local firstContext = dependencies.firstContext

			while firstContext ~= nil do
				if p10 == firstContext.context and bit32.band(firstContext.observedBits, n1) ~= 0 then
					if child.tag == ClassComponent then
						local v55 = createUpdate(NoTimestamp, pickArbitraryLane(p11))

						v55.tag = ForceUpdate

						local updateQueue = child.updateQueue

						if updateQueue ~= nil then
							local shared = updateQueue.shared
							local pending = shared.pending

							if pending == nil then
								v55.next = v55
							else
								v55.next = pending.next
								pending.next = v55
							end

							shared.pending = v55
						end
					end

					child.lanes = bit32.bor(child.lanes, p11)

					local alternate = child.alternate

					if alternate ~= nil then
						alternate.lanes = bit32.bor(alternate.lanes, p11)
					end

					t1.scheduleWorkOnParentPath(child.return_, p11)
					dependencies.lanes = bit32.bor(dependencies.lanes, p11)

					break
				end

				firstContext = firstContext.next
			end
		else
			child2 = if child.tag ~= ContextProvider then child.child else if child.type ~= p9.type then child.child else nil
		end

		if child2 ~= nil then
			child2.return_ = child
		else
			child2 = child

			while child2 ~= nil do
				if child2 == p9 then
					child2 = nil

					break
				end

				local sibling = child2.sibling

				if sibling ~= nil then
					sibling.return_ = child2.return_
					child2 = sibling

					break
				end

				child2 = child2.return_
			end
		end

		child = child2
	end
end
function t1.prepareToReadContext(p12, p13, p14: ((...any) -> ...any)) -- line: 341
	-- upvalues: u30 (ref), u31 (ref), u32 (ref), includesSomeLane (copy)
	u30 = p12
	u31 = nil
	u32 = nil

	local dependencies = p12.dependencies

	if dependencies ~= nil and dependencies.firstContext ~= nil then
		if includesSomeLane(dependencies.lanes, p13) then
			p14()
		end

		dependencies.firstContext = nil
	end
end
function t1.readContext(p15, p16) -- line: 364
	-- upvalues: ReactGlobals (copy), u33 (ref), console (copy), u32 (ref), Number (copy), u31 (ref), u30 (ref), Error (copy), NoLanes (copy), isPrimaryRenderer (copy)
	if ReactGlobals.__DEV__ and u33 then
		console.error("Context can only be read while React is rendering. In classes, you can read it in the render method or getDerivedStateFromProps. In function components, you can read it directly in the function body, but not inside Hooks like useReducer() or useMemo().")
	end

	if p15 ~= u32 and p16 ~= false and p16 ~= 0 then
		if typeof(p16) ~= "number" or p16 == Number.MAX_SAFE_INTEGER then
			u32 = p15
			p16 = Number.MAX_SAFE_INTEGER
		end

		local t3 = {
			next = nil,
			context = p15,
			observedBits = p16
		}

		if u31 == nil then
			if u30 == nil then
				error(Error.new("Context can only be read while React is rendering. In classes, you can read it in the render method or getDerivedStateFromProps. In function components, you can read it directly in the function body, but not inside Hooks like useReducer() or useMemo()."))
			end

			u31 = t3
			u30.dependencies = {
				responders = nil,
				lanes = NoLanes,
				firstContext = t3
			}
		else
			u31.next = t3
			u31 = t3
		end
	end

	if isPrimaryRenderer then
		return p15._currentValue
	end

	return p15._currentValue2
end

return t1
