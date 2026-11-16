local parent = script.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Shared = require(parent.Shared)
local console = Shared.console

local Shared2 = require(parent.Shared)
local ReactSymbols = Shared2.ReactSymbols

local REACT_CONTEXT_TYPE = ReactSymbols.REACT_CONTEXT_TYPE
local REACT_ELEMENT_TYPE = ReactSymbols.REACT_ELEMENT_TYPE
local REACT_FORWARD_REF_TYPE = ReactSymbols.REACT_FORWARD_REF_TYPE
local REACT_FRAGMENT_TYPE = ReactSymbols.REACT_FRAGMENT_TYPE
local REACT_LAZY_TYPE = ReactSymbols.REACT_LAZY_TYPE
local REACT_MEMO_TYPE = ReactSymbols.REACT_MEMO_TYPE
local REACT_PORTAL_TYPE = ReactSymbols.REACT_PORTAL_TYPE
local REACT_PROFILER_TYPE = ReactSymbols.REACT_PROFILER_TYPE
local REACT_PROVIDER_TYPE = ReactSymbols.REACT_PROVIDER_TYPE
local REACT_STRICT_MODE_TYPE = ReactSymbols.REACT_STRICT_MODE_TYPE
local REACT_SUSPENSE_TYPE = ReactSymbols.REACT_SUSPENSE_TYPE
local REACT_SUSPENSE_LIST_TYPE = ReactSymbols.REACT_SUSPENSE_LIST_TYPE

local Shared3 = require(parent.Shared)
local isValidElementType = Shared3.isValidElementType

local REACT_BINDING_TYPE = ReactSymbols.REACT_BINDING_TYPE

local SafeFlags = require(parent.SafeFlags)

local v = SafeFlags.createGetFFlag("ReactIsProtectedTypeOf", false)()

local function typeOf(p)
	if typeof(p) ~= "table" or p == nil then
		return nil
	end

	local result

	if v then
		local success
		success, result = pcall(function()
			return p["$$typeof"]
		end)

		if not success then
			return nil
		end
	else
		result = p["$$typeof"]
	end

	if result == REACT_ELEMENT_TYPE then
		local v2 = p.type

		if
			v2 == REACT_FRAGMENT_TYPE
			or v2 == REACT_PROFILER_TYPE
			or v2 == REACT_STRICT_MODE_TYPE
			or v2 == REACT_SUSPENSE_TYPE
			or v2 == REACT_SUSPENSE_LIST_TYPE
		then
			return v2
		end

		if v2 then
			v2 = typeof(v2) == "table" and v2["$$typeof"]
		end

		if
			v2 == REACT_CONTEXT_TYPE
			or v2 == REACT_FORWARD_REF_TYPE
			or v2 == REACT_LAZY_TYPE
			or v2 == REACT_MEMO_TYPE
			or v2 == REACT_PROVIDER_TYPE
		then
			return v2
		end

		return result
	elseif result == REACT_PORTAL_TYPE or result == REACT_BINDING_TYPE then
		return result
	end

	return nil
end

local ReactIs = {}
ReactIs.typeOf = typeOf
ReactIs.ContextConsumer = REACT_CONTEXT_TYPE
ReactIs.ContextProvider = REACT_PROVIDER_TYPE
ReactIs.Element = REACT_ELEMENT_TYPE
ReactIs.ForwardRef = REACT_FORWARD_REF_TYPE
ReactIs.Fragment = REACT_FRAGMENT_TYPE
ReactIs.Lazy = REACT_LAZY_TYPE
ReactIs.Memo = REACT_MEMO_TYPE
ReactIs.Portal = REACT_PORTAL_TYPE
ReactIs.Profiler = REACT_PROFILER_TYPE
ReactIs.StrictMode = REACT_STRICT_MODE_TYPE
ReactIs.Suspense = REACT_SUSPENSE_TYPE
ReactIs.Binding = ReactSymbols.REACT_BINDING_TYPE
ReactIs.isValidElementType = isValidElementType
local v2 = false
local v3 = false
function ReactIs.isAsyncMode(_): boolean
	if ReactGlobals.__DEV__ and not v2 then
		v2 = true
		console.warn("The ReactIs.isAsyncMode() alias has been deprecated, and will be removed in React 18+.")
	end

	return false
end
function ReactIs.isConcurrentMode(_): boolean
	if ReactGlobals.__DEV__ and not v3 then
		v3 = true
		console.warn("The ReactIs.isConcurrentMode() alias has been deprecated, and will be removed in React 18+.")
	end

	return false
end
function ReactIs.isContextConsumer(p): boolean
	return typeOf(p) == REACT_CONTEXT_TYPE
end
function ReactIs.isContextProvider(p): boolean
	return typeOf(p) == REACT_PROVIDER_TYPE
end
function ReactIs.isElement(p): boolean
	return typeof(p) == "table" and p ~= nil and p["$$typeof"] == REACT_ELEMENT_TYPE
end
function ReactIs.isForwardRef(p): boolean
	return typeOf(p) == REACT_FORWARD_REF_TYPE
end
function ReactIs.isFragment(p): boolean
	return typeOf(p) == REACT_FRAGMENT_TYPE
end
function ReactIs.isLazy(p): boolean
	return typeOf(p) == REACT_LAZY_TYPE
end
function ReactIs.isMemo(p): boolean
	return typeOf(p) == REACT_MEMO_TYPE
end
function ReactIs.isPortal(p): boolean
	return typeOf(p) == REACT_PORTAL_TYPE
end
function ReactIs.isProfiler(p): boolean
	return typeOf(p) == REACT_PROFILER_TYPE
end
function ReactIs.isStrictMode(p): boolean
	return typeOf(p) == REACT_STRICT_MODE_TYPE
end
function ReactIs.isSuspense(p): boolean
	return typeOf(p) == REACT_SUSPENSE_TYPE
end

function ReactIs.isBinding(p): boolean
	return typeOf(p) == REACT_BINDING_TYPE
end

return ReactIs
