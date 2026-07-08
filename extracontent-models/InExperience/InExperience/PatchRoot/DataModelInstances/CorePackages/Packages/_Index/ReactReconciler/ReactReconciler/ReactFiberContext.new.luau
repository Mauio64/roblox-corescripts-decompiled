local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Error = LuauPolyfill.Error
local __DEV__ = ReactGlobals.__DEV__
local __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ = ReactGlobals.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__
local console = require(ParentParent.Shared).console

require(script.Parent.ReactInternalTypes)

local lib = require(script.Parent["ReactFiberStack.new"])
local isFiberMounted = require(script.Parent.ReactFiberTreeReflection).isFiberMounted
local disableLegacyContext = require(ParentParent.Shared).ReactFeatureFlags.disableLegacyContext
local ReactWorkTags = require(script.Parent.ReactWorkTags)
local ClassComponent = ReactWorkTags.ClassComponent
local HostRoot = ReactWorkTags.HostRoot
local getComponentName = require(ParentParent.Shared).getComponentName
local checkPropTypes = require(ParentParent.Shared).checkPropTypes
local createCursor = lib.createCursor
local push = lib.push
local pop = lib.pop
local t1 = nil

if __DEV__ then
	t1 = {}
end

local t2 = {}

if __DEV__ then
	Object.freeze(t2)
end

local v22 = createCursor(t2)
local v23 = createCursor(false)
local u24 = t2

local function isContextProvider(p1) -- line: 163
	if type(p1) == "function" then
		return false
	end

	return p1.childContextTypes ~= nil
end
local function processChildContext(p2, p3, t3: {[any]: any}) -- line: 221
	-- upvalues: __DEV__ (copy), getComponentName (copy), t1 (ref), console (copy), Error (copy), __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ (copy), checkPropTypes (copy), Object (copy)
	local stateNode = p2.stateNode
	local childContextTypes = p3.childContextTypes

	if stateNode.getChildContext == nil or type(stateNode.getChildContext) ~= "function" then
		if __DEV__ then
			local v55 = getComponentName(p3) or "Unknown"

			if not t1[v55] then
				t1[v55] = true
				console.error("%s.childContextTypes is specified but there is no getChildContext() method on the instance. You can either define getChildContext() on %s or remove childContextTypes from it.", v55, v55)
			end
		end

		return t3
	end

	local v56 = stateNode:getChildContext()

	for v57, _ in v56 do
		if childContextTypes[v57] == nil then
			local v59 = getComponentName(p3) or "Unknown"

			error(Error.new(string.format("%s.getChildContext(): key \"%s\" is not defined in childContextTypes.", v59, v57)))
		end
	end

	if __DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
		local v60 = getComponentName(p3) or "Unknown"

		checkPropTypes(childContextTypes, nil, v56, "child context", v60)
	end

	return Object.assign({}, t3, v56)
end

return {
	emptyContextObject = t2,
	getUnmaskedContext = function(_, p5, b1: boolean) -- line: 70
		-- upvalues: isContextProvider (ref), u24 (ref), v22 (copy)
		if b1 and isContextProvider(p5) then
			return u24
		end

		return v22.current
	end,
	cacheContext = function(p6, t4: {[any]: any}, t5: {[any]: any}) -- line: 90
		local stateNode = p6.stateNode

		stateNode.__reactInternalMemoizedUnmaskedChildContext = t4
		stateNode.__reactInternalMemoizedMaskedChildContext = t5
	end,
	getMaskedContext = function(p7, t6: {[any]: any}) -- line: 105
		-- upvalues: t2 (copy), __DEV__ (copy), __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ (copy), getComponentName (copy), checkPropTypes (copy)
		local type2 = p7.type

		if type(type2) == "function" then
			return t6
		end

		local contextTypes = type2.contextTypes

		if not contextTypes then
			return t2
		end

		local stateNode = p7.stateNode

		if stateNode and t6 == stateNode.__reactInternalMemoizedUnmaskedChildContext then
			return stateNode.__reactInternalMemoizedMaskedChildContext
		end

		local t7 = {}

		for v40, _ in contextTypes do
			t7[v40] = t6[v40]
		end

		if __DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
			local v42 = getComponentName(type2) or "Unknown"

			checkPropTypes(contextTypes, nil, t7, "context", v42)
		end

		if stateNode then
			local stateNode2 = p7.stateNode

			stateNode2.__reactInternalMemoizedUnmaskedChildContext = t6
			stateNode2.__reactInternalMemoizedMaskedChildContext = t7
		end

		return t7
	end,
	hasContextChanged = function() -- line: 154
		-- upvalues: disableLegacyContext (copy), v23 (copy)
		if disableLegacyContext then
			return false
		end

		return v23.current
	end,
	popContext = function(p8) -- line: 178
		-- upvalues: pop (copy), v23 (copy), v22 (copy)
		pop(v23, p8)
		pop(v22, p8)
	end,
	popTopLevelContextObject = function(p9) -- line: 188
		-- upvalues: pop (copy), v23 (copy), v22 (copy)
		pop(v23, p9)
		pop(v22, p9)
	end,
	pushTopLevelContextObject = function(p10, t8: {[any]: any}, b2: boolean) -- line: 198
		-- upvalues: v22 (copy), t2 (copy), Error (copy), push (copy), v23 (copy)
		if v22.current ~= t2 then
			error(Error.new("Unexpected context found on stack. This error is likely caused by a bug in React. Please file an issue."))
		end

		push(v22, t8, p10)
		push(v23, b2, p10)
	end,
	processChildContext = processChildContext,
	isContextProvider = isContextProvider,
	pushContextProvider = function(p11) -- line: 281
		-- upvalues: t2 (copy), u24 (ref), v22 (copy), push (copy), v23 (copy)
		local stateNode = p11.stateNode
		local v63 = stateNode and stateNode.__reactInternalMemoizedMergedChildContext or t2

		u24 = v22.current
		push(v22, v63, p11)
		push(v23, v23.current, p11)

		return true
	end,
	invalidateContextProvider = function(p12, p13, b3: boolean) -- line: 304
		-- upvalues: Error (copy), processChildContext (copy), u24 (ref), pop (copy), v23 (copy), v22 (copy), push (copy)
		local stateNode = p12.stateNode

		if not stateNode then
			error(Error.new("Expected to have an instance by this point. This error is likely caused by a bug in React. Please file an issue."))
		end

		if b3 then
			local v68 = processChildContext(p12, p13, u24)

			stateNode.__reactInternalMemoizedMergedChildContext = v68
			pop(v23, p12)
			pop(v22, p12)
			push(v22, v68, p12)
			push(v23, b3, p12)

			return
		end

		pop(v23, p12)
		push(v23, b3, p12)
	end,
	findCurrentUnmaskedContext = function(p14) -- line: 345
		-- upvalues: ClassComponent (copy), isFiberMounted (copy), Error (copy), HostRoot (copy)
		if p14.tag ~= ClassComponent or not isFiberMounted(p14) then
			error(Error.new("Expected subtree parent to be a mounted class component. This error is likely caused by a bug in React. Please file an issue."))
		end

		repeat
			if p14.tag == HostRoot then
				return p14.stateNode.context
			end

			if p14.tag == ClassComponent and p14.type.childContextTypes ~= nil then
				return p14.stateNode.__reactInternalMemoizedMergedChildContext
			end

			p14 = p14.return_
		until p14 == nil

		error(Error.new("Found unexpected detached subtree parent. This error is likely caused by a bug in React. Please file an issue."))
	end
}
