local ReactSymbols = require(script.Parent.ReactSymbols)
local REACT_CONTEXT_TYPE = ReactSymbols.REACT_CONTEXT_TYPE
local REACT_FORWARD_REF_TYPE = ReactSymbols.REACT_FORWARD_REF_TYPE
local REACT_FRAGMENT_TYPE = ReactSymbols.REACT_FRAGMENT_TYPE
local REACT_PROFILER_TYPE = ReactSymbols.REACT_PROFILER_TYPE
local REACT_PROVIDER_TYPE = ReactSymbols.REACT_PROVIDER_TYPE
local REACT_DEBUG_TRACING_MODE_TYPE = ReactSymbols.REACT_DEBUG_TRACING_MODE_TYPE
local REACT_STRICT_MODE_TYPE = ReactSymbols.REACT_STRICT_MODE_TYPE
local REACT_SUSPENSE_TYPE = ReactSymbols.REACT_SUSPENSE_TYPE
local REACT_MEMO_TYPE = ReactSymbols.REACT_MEMO_TYPE
local REACT_LAZY_TYPE = ReactSymbols.REACT_LAZY_TYPE
local REACT_FUNDAMENTAL_TYPE = ReactSymbols.REACT_FUNDAMENTAL_TYPE
local REACT_BLOCK_TYPE = ReactSymbols.REACT_BLOCK_TYPE
local REACT_SERVER_BLOCK_TYPE = ReactSymbols.REACT_SERVER_BLOCK_TYPE
local REACT_LEGACY_HIDDEN_TYPE = ReactSymbols.REACT_LEGACY_HIDDEN_TYPE

return function(p1) -- line: 31
	-- upvalues: REACT_FRAGMENT_TYPE (copy), REACT_PROFILER_TYPE (copy), REACT_DEBUG_TRACING_MODE_TYPE (copy), REACT_STRICT_MODE_TYPE (copy), REACT_SUSPENSE_TYPE (copy), REACT_LEGACY_HIDDEN_TYPE (copy), REACT_LAZY_TYPE (copy), REACT_MEMO_TYPE (copy), REACT_PROVIDER_TYPE (copy), REACT_CONTEXT_TYPE (copy), REACT_FORWARD_REF_TYPE (copy), REACT_FUNDAMENTAL_TYPE (copy), REACT_BLOCK_TYPE (copy), REACT_SERVER_BLOCK_TYPE (copy)
	local v17 = typeof(p1)

	if v17 == "string" or v17 == "function" then
		return true
	end

	if p1 == REACT_FRAGMENT_TYPE or p1 == REACT_PROFILER_TYPE or p1 == REACT_DEBUG_TRACING_MODE_TYPE or p1 == REACT_STRICT_MODE_TYPE or p1 == REACT_SUSPENSE_TYPE or p1 == REACT_LEGACY_HIDDEN_TYPE then
		return true
	end

	if v17 == "table" then
		if p1.isReactComponent then
			return true
		end

		if p1["$$typeof"] == REACT_LAZY_TYPE or p1["$$typeof"] == REACT_MEMO_TYPE or p1["$$typeof"] == REACT_PROVIDER_TYPE or p1["$$typeof"] == REACT_CONTEXT_TYPE or p1["$$typeof"] == REACT_FORWARD_REF_TYPE or p1["$$typeof"] == REACT_FUNDAMENTAL_TYPE or p1["$$typeof"] == REACT_BLOCK_TYPE or p1[1] == REACT_SERVER_BLOCK_TYPE then
			return true
		end
	end

	return false
end
