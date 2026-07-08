local t1 = {
	REACT_ELEMENT_TYPE = 60103,
	REACT_PORTAL_TYPE = 60106,
	REACT_FRAGMENT_TYPE = 60107,
	REACT_STRICT_MODE_TYPE = 60108,
	REACT_PROFILER_TYPE = 60114,
	REACT_PROVIDER_TYPE = 60109,
	REACT_CONTEXT_TYPE = 60110,
	REACT_FORWARD_REF_TYPE = 60112,
	REACT_SUSPENSE_TYPE = 60113,
	REACT_SUSPENSE_LIST_TYPE = 60120,
	REACT_MEMO_TYPE = 60115,
	REACT_LAZY_TYPE = 60116,
	REACT_BLOCK_TYPE = 60121,
	REACT_SERVER_BLOCK_TYPE = 60122,
	REACT_FUNDAMENTAL_TYPE = 60117,
	REACT_SCOPE_TYPE = 60119,
	REACT_OPAQUE_ID_TYPE = 60128,
	REACT_DEBUG_TRACING_MODE_TYPE = 60129,
	REACT_OFFSCREEN_TYPE = 60130,
	REACT_LEGACY_HIDDEN_TYPE = 60131,
	REACT_BINDING_TYPE = 60132
}

function t1.getIteratorFn(p1) -- line: 84
	-- upvalues: t1 (copy)
	if typeof(p1) == "table" then
		if p1["$$typeof"] == t1.REACT_PORTAL_TYPE then
			return nil
		end

		return function() -- line: 91
			-- upvalues: p1 (copy)
			local u3 = nil
			local u4 = nil

			return {
				next = function() -- line: 94
					-- upvalues: u3 (ref), u4 (ref), p1 (copy)
					local v5, v6 = next(p1, u3)

					u3 = v5
					u4 = v6

					return {
						done = u4 == nil,
						key = u3,
						value = u4
					}
				end
			}
		end
	end

	return nil
end

return t1
