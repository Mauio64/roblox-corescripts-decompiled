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

return function(p): boolean
	local typeName = typeof(p)

	if typeName == "string" or typeName == "function" then
		return true
	end

	if
		p == REACT_FRAGMENT_TYPE
		or p == REACT_PROFILER_TYPE
		or p == REACT_DEBUG_TRACING_MODE_TYPE
		or p == REACT_STRICT_MODE_TYPE
		or p == REACT_SUSPENSE_TYPE
		or p == REACT_LEGACY_HIDDEN_TYPE
	then
		return true
	end

	if typeName ~= "table" then
		return false
	end

	if p.isReactComponent then
		return true
	end

	if
		p["$$typeof"] == REACT_LAZY_TYPE
		or p["$$typeof"] == REACT_MEMO_TYPE
		or p["$$typeof"] == REACT_PROVIDER_TYPE
		or p["$$typeof"] == REACT_CONTEXT_TYPE
		or p["$$typeof"] == REACT_FORWARD_REF_TYPE
		or p["$$typeof"] == REACT_FUNDAMENTAL_TYPE
		or p["$$typeof"] == REACT_BLOCK_TYPE
		or p[1] == REACT_SERVER_BLOCK_TYPE
	then
		return true
	end

	return false
end
