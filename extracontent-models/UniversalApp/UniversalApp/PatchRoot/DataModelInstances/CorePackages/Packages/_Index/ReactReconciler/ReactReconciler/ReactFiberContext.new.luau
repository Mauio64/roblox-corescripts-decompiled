local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Error = LuauPolyfill.Error

local __DEV__ = ReactGlobals.__DEV__

local __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ = ReactGlobals.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__

local Shared = require(parent.Shared)
local console = Shared.console

require(script.Parent.ReactInternalTypes)

local ReactFiberStacknew = require(script.Parent["ReactFiberStack.new"])

local ReactFiberTreeReflection = require(script.Parent.ReactFiberTreeReflection)
local isFiberMounted = ReactFiberTreeReflection.isFiberMounted

local Shared2 = require(parent.Shared)
local disableLegacyContext = Shared2.ReactFeatureFlags.disableLegacyContext
local ReactWorkTags = require(script.Parent.ReactWorkTags)
local ClassComponent = ReactWorkTags.ClassComponent
local HostRoot = ReactWorkTags.HostRoot
local Shared3 = require(parent.Shared)
local getComponentName = Shared3.getComponentName
local Shared4 = require(parent.Shared)
local checkPropTypes = Shared4.checkPropTypes

local createCursor = ReactFiberStacknew.createCursor
local push = ReactFiberStacknew.push
local pop = ReactFiberStacknew.pop

local v = __DEV__ and {} or nil

local emptyContextObject = {}

if __DEV__ then
	Object.freeze(emptyContextObject)
end

local cursor = createCursor(emptyContextObject)

local cursor2 = createCursor(false)

local v2 = emptyContextObject

local isContextProvider

local function getUnmaskedContext(_, p, flag: boolean)
	return if flag and isContextProvider(p) then v2 else cursor.current
end

local function cacheContext(p, reactInternalMemoizedUnmaskedChildContext, reactInternalMemoizedMaskedChildContext) -- 1 equivalent call inferred from this helper
	local stateNode = p.stateNode
	stateNode.__reactInternalMemoizedUnmaskedChildContext = reactInternalMemoizedUnmaskedChildContext
	stateNode.__reactInternalMemoizedMaskedChildContext = reactInternalMemoizedMaskedChildContext
end

isContextProvider = function(callback): boolean
	return type(callback) ~= "function" and callback.childContextTypes ~= nil
end

local function processChildContext(p, p2, p3)
	local stateNode = p.stateNode
	local childContextTypes = p2.childContextTypes

	if stateNode.getChildContext == nil or type(stateNode.getChildContext) ~= "function" then
		if not __DEV__ then
			return p3
		end

		local v3 = getComponentName(p2) or "Unknown"

		if not v[v3] then
			v[v3] = true
			console.error(
				"%s.childContextTypes is specified but there is no getChildContext() method on the instance. You can either define getChildContext() on %s or remove childContextTypes from it.",
				v3,
				v3
			)
		end

		return p3
	else
		local childContext = stateNode:getChildContext()

		for k, _ in childContext do
			if childContextTypes[k] ~= nil then
				continue
			end

			local v3 = getComponentName(p2) or "Unknown"
			error(Error.new(string.format(
				"%s.getChildContext(): key \"%s\" is not defined in childContextTypes.",
				v3,
				k
			)))
		end

		if __DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
			checkPropTypes(childContextTypes, nil, childContext, "child context", getComponentName(p2) or "Unknown")
		end

		return Object.assign({}, p3, childContext)
	end
end

local New = {}
New.emptyContextObject = emptyContextObject
New.getUnmaskedContext = getUnmaskedContext
New.cacheContext = cacheContext

function New.getMaskedContext(p, reactInternalMemoizedUnmaskedChildContext)
	local kind = p.type

	if type(kind) == "function" then
		return reactInternalMemoizedUnmaskedChildContext
	end

	local contextTypes = kind.contextTypes

	if not contextTypes then
		return emptyContextObject
	end

	local stateNode = p.stateNode

	if
		stateNode
		and stateNode.__reactInternalMemoizedUnmaskedChildContext == reactInternalMemoizedUnmaskedChildContext
	then
		return stateNode.__reactInternalMemoizedMaskedChildContext
	end

	local result = {}

	for k, _ in contextTypes do
		result[k] = reactInternalMemoizedUnmaskedChildContext[k]
	end

	if __DEV__ or __DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
		checkPropTypes(contextTypes, nil, result, "context", getComponentName(kind) or "Unknown")
	end

	if stateNode then
		cacheContext(p, reactInternalMemoizedUnmaskedChildContext, result) -- inferred equivalent call
	end

	return result
end

function New.hasContextChanged()
	return not disableLegacyContext and cursor2.current
end

function New.popContext(p)
	pop(cursor2, p)
	pop(cursor, p)
end

function New.popTopLevelContextObject(p)
	pop(cursor2, p)
	pop(cursor, p)
end

function New.pushTopLevelContextObject(p, p2, flag: boolean)
	if cursor.current ~= emptyContextObject then
		error(Error.new("Unexpected context found on stack. This error is likely caused by a bug in React. Please file an issue."))
	end

	push(cursor, p2, p)
	push(cursor2, flag, p)
end

New.processChildContext = processChildContext
New.isContextProvider = isContextProvider

function New.pushContextProvider(p): boolean
	local stateNode = p.stateNode

	local __reactInternalMemoizedMergedChildContext = stateNode
		and stateNode.__reactInternalMemoizedMergedChildContext
		or emptyContextObject

	v2 = cursor.current
	push(cursor, __reactInternalMemoizedMergedChildContext, p)
	push(cursor2, cursor2.current, p)

	return true
end

function New.invalidateContextProvider(p, p2, flag: boolean)
	local stateNode = p.stateNode

	if not stateNode then
		error(Error.new("Expected to have an instance by this point. This error is likely caused by a bug in React. Please file an issue."))
	end

	if flag then
		local reactInternalMemoizedMergedChildContext = processChildContext(p, p2, v2)
		stateNode.__reactInternalMemoizedMergedChildContext = reactInternalMemoizedMergedChildContext

		pop(cursor2, p)
		pop(cursor, p)

		push(cursor, reactInternalMemoizedMergedChildContext, p)
		push(cursor2, flag, p)
	else
		pop(cursor2, p)
		push(cursor2, flag, p)
	end
end

function New.findCurrentUnmaskedContext(data)
	if data.tag ~= ClassComponent or not isFiberMounted(data) then
		error(Error.new("Expected subtree parent to be a mounted class component. This error is likely caused by a bug in React. Please file an issue."))
	end

	while data.tag ~= HostRoot do
		if data.tag == ClassComponent and data.type.childContextTypes ~= nil then
			return data.stateNode.__reactInternalMemoizedMergedChildContext
		end

		data = data.return_

		if data == nil then
			error(Error.new("Found unexpected detached subtree parent. This error is likely caused by a bug in React. Please file an issue."))

			return
		end
	end

	return data.stateNode.context
end

return New
