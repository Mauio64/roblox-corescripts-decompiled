local scriptParent = script.Parent
local ReactGlobals = require(scriptParent.ReactGlobals)
local console = require(scriptParent.Shared).console
local t1 = {}
local ReactSymbols = require(scriptParent.Shared).ReactSymbols
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
local isValidElementType = require(scriptParent.Shared).isValidElementType
local REACT_BINDING_TYPE = ReactSymbols.REACT_BINDING_TYPE
local v20 = require(scriptParent.SafeFlags).createGetFFlag("ReactIsProtectedTypeOf", false)()

local function typeOf(p1) -- line: 50
	-- upvalues: v20 (copy), REACT_ELEMENT_TYPE (copy), REACT_FRAGMENT_TYPE (copy), REACT_PROFILER_TYPE (copy), REACT_STRICT_MODE_TYPE (copy), REACT_SUSPENSE_TYPE (copy), REACT_SUSPENSE_LIST_TYPE (copy), REACT_CONTEXT_TYPE (copy), REACT_FORWARD_REF_TYPE (copy), REACT_LAZY_TYPE (copy), REACT_MEMO_TYPE (copy), REACT_PROVIDER_TYPE (copy), REACT_PORTAL_TYPE (copy), REACT_BINDING_TYPE (copy)
	if typeof(p1) == "table" and p1 ~= nil then
		local result

		if v20 then
			local ok

			ok, result = pcall(function() -- line: 58
				-- upvalues: p1 (copy)
				return p1["$$typeof"]
			end)

			if not ok then
				return nil
			end
		else
			result = p1["$$typeof"]
		end

		if result == REACT_ELEMENT_TYPE then
			local type = p1.type

			if type == REACT_FRAGMENT_TYPE or type == REACT_PROFILER_TYPE or type == REACT_STRICT_MODE_TYPE or type == REACT_SUSPENSE_TYPE or type == REACT_SUSPENSE_LIST_TYPE then
				return type
			end

			local v28 = type and (typeof(type) == "table" and type["$$typeof"])

			if v28 == REACT_CONTEXT_TYPE or v28 == REACT_FORWARD_REF_TYPE or v28 == REACT_LAZY_TYPE or v28 == REACT_MEMO_TYPE or v28 == REACT_PROVIDER_TYPE then
				return v28
			end

			return result
		end

		if result == REACT_PORTAL_TYPE or result == REACT_BINDING_TYPE then
			return result
		end
	end

	return nil
end

t1.typeOf = typeOf
t1.ContextConsumer = REACT_CONTEXT_TYPE
t1.ContextProvider = REACT_PROVIDER_TYPE
t1.Element = REACT_ELEMENT_TYPE
t1.ForwardRef = REACT_FORWARD_REF_TYPE
t1.Fragment = REACT_FRAGMENT_TYPE
t1.Lazy = REACT_LAZY_TYPE
t1.Memo = REACT_MEMO_TYPE
t1.Portal = REACT_PORTAL_TYPE
t1.Profiler = REACT_PROFILER_TYPE
t1.StrictMode = REACT_STRICT_MODE_TYPE
t1.Suspense = REACT_SUSPENSE_TYPE
t1.Binding = ReactSymbols.REACT_BINDING_TYPE
t1.isValidElementType = isValidElementType

local u22 = false
local u23 = false

function t1.isAsyncMode(_) -- line: 183
	-- upvalues: ReactGlobals (copy), u22 (ref), console (copy)
	if ReactGlobals.__DEV__ and not u22 then
		u22 = true
		console.warn("The ReactIs.isAsyncMode() alias has been deprecated, and will be removed in React 18+.")
	end

	return false
end
function t1.isConcurrentMode(_) -- line: 200
	-- upvalues: ReactGlobals (copy), u23 (ref), console (copy)
	if ReactGlobals.__DEV__ and not u23 then
		u23 = true
		console.warn("The ReactIs.isConcurrentMode() alias has been deprecated, and will be removed in React 18+.")
	end

	return false
end
function t1.isContextConsumer(p4) -- line: 217
	-- upvalues: typeOf (copy), REACT_CONTEXT_TYPE (copy)
	return typeOf(p4) == REACT_CONTEXT_TYPE
end
function t1.isContextProvider(p5) -- line: 221
	-- upvalues: typeOf (copy), REACT_PROVIDER_TYPE (copy)
	return typeOf(p5) == REACT_PROVIDER_TYPE
end
function t1.isElement(p6) -- line: 225
	-- upvalues: REACT_ELEMENT_TYPE (copy)
	return typeof(p6) == "table" and (p6 ~= nil and p6["$$typeof"] == REACT_ELEMENT_TYPE)
end
function t1.isForwardRef(p7) -- line: 231
	-- upvalues: typeOf (copy), REACT_FORWARD_REF_TYPE (copy)
	return typeOf(p7) == REACT_FORWARD_REF_TYPE
end
function t1.isFragment(p8) -- line: 235
	-- upvalues: typeOf (copy), REACT_FRAGMENT_TYPE (copy)
	return typeOf(p8) == REACT_FRAGMENT_TYPE
end
function t1.isLazy(p9) -- line: 239
	-- upvalues: typeOf (copy), REACT_LAZY_TYPE (copy)
	return typeOf(p9) == REACT_LAZY_TYPE
end
function t1.isMemo(p10) -- line: 243
	-- upvalues: typeOf (copy), REACT_MEMO_TYPE (copy)
	return typeOf(p10) == REACT_MEMO_TYPE
end
function t1.isPortal(p11) -- line: 247
	-- upvalues: typeOf (copy), REACT_PORTAL_TYPE (copy)
	return typeOf(p11) == REACT_PORTAL_TYPE
end
function t1.isProfiler(p12) -- line: 251
	-- upvalues: typeOf (copy), REACT_PROFILER_TYPE (copy)
	return typeOf(p12) == REACT_PROFILER_TYPE
end
function t1.isStrictMode(p13) -- line: 255
	-- upvalues: typeOf (copy), REACT_STRICT_MODE_TYPE (copy)
	return typeOf(p13) == REACT_STRICT_MODE_TYPE
end
function t1.isSuspense(p14) -- line: 259
	-- upvalues: typeOf (copy), REACT_SUSPENSE_TYPE (copy)
	return typeOf(p14) == REACT_SUSPENSE_TYPE
end
function t1.isBinding(p15) -- line: 264
	-- upvalues: typeOf (copy), REACT_BINDING_TYPE (copy)
	return typeOf(p15) == REACT_BINDING_TYPE
end

return t1
