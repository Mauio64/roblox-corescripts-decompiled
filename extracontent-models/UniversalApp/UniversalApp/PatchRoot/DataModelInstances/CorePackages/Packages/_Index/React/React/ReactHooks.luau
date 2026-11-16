local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local Shared = require(parent.Shared)
local console = Shared.console

require(parent.Shared)

require(parent.Shared)

local Shared2 = require(parent.Shared)
local ReactCurrentDispatcher = Shared2.ReactSharedInternals.ReactCurrentDispatcher

local function resolveDispatcher() -- 13 equivalent calls inferred from this helper
	local current = ReactCurrentDispatcher.current

	if ReactGlobals.__DEV__ and current == nil then
		console.error([[
Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:
1. You might have mismatching versions of React and the renderer (such as React DOM)
2. You might be breaking the Rules of Hooks
3. You might have more than one copy of React in the same app
See https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.]])
	end

	return current
end

local ReactHooks = {}

function ReactHooks.useContext(p, value, ...)
	local dispatcher = resolveDispatcher() -- inferred equivalent call

	if ReactGlobals.__DEV__ then
		if value ~= nil then
			console.error(
				"useContext() second argument is reserved for future use in React. Passing it is not supported. You passed: %s.%s",
				value,
				typeof(value) == "number" and Array.isArray({ ... }) and "\n\nDid you call Array.map(useContext)? Calling Hooks inside a loop is not supported. Learn more at https://reactjs.org/link/rules-of-hooks" or ""
			)
		end

		if p._context ~= nil then
			local context = p._context

			if context.Consumer == p then
				console.error("Calling useContext(Context.Consumer) is not supported, may cause bugs, and will be removed in a future major release. Did you mean to call useContext(Context) instead?")
			elseif context.Provider == p then
				console.error("Calling useContext(Context.Provider) is not supported. Did you mean to call useContext(Context) instead?")
			end
		end
	end

	return dispatcher.useContext(p, value)
end

function ReactHooks.useState(p, ...)
	return resolveDispatcher().useState(p, ...) -- inferred equivalent call
end

function ReactHooks.useReducer(callback, p, callback2)
	return resolveDispatcher().useReducer(callback, p, callback2) -- inferred equivalent call
end

function ReactHooks.useRef(p)
	return resolveDispatcher().useRef(p) -- inferred equivalent call
end

function ReactHooks.useBinding(p)
	return resolveDispatcher().useBinding(p) -- inferred equivalent call
end

function ReactHooks.useEffect(callback, p)
	return resolveDispatcher().useEffect(callback, p) -- inferred equivalent call
end

function ReactHooks.useLayoutEffect(callback, p)
	return resolveDispatcher().useLayoutEffect(callback, p) -- inferred equivalent call
end

function ReactHooks.useCallback(p, p2)
	return resolveDispatcher().useCallback(p, p2) -- inferred equivalent call
end

function ReactHooks.useMemo(callback, p)
	return resolveDispatcher().useMemo(callback, p) -- inferred equivalent call
end

function ReactHooks.useImperativeHandle(p, callback, p2)
	return resolveDispatcher().useImperativeHandle(p, callback, p2) -- inferred equivalent call
end

function ReactHooks.useDebugValue(p, callback)
	if not ReactGlobals.__DEV__ then
		return nil
	end

	return resolveDispatcher().useDebugValue(p, callback) -- inferred equivalent call
end

ReactHooks.emptyObject = {}

function ReactHooks.useOpaqueIdentifier()
	return resolveDispatcher().useOpaqueIdentifier() -- inferred equivalent call
end

function ReactHooks.useMutableSource(p, p2, p3)
	return resolveDispatcher().useMutableSource(p, p2, p3) -- inferred equivalent call
end

return ReactHooks
