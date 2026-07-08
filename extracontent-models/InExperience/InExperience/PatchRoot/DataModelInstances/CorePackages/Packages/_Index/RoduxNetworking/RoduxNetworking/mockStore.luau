return {
	config = function(t1: {[any]: any}?) -- line: 7
		local v2 = t1 or {}
		local u3 = v2.state or {}

		return {
			dispatch = v2.dispatch or function(p1, p2) -- line: 12
				if type(p2) == "function" then
					p2(p1)
				end
			end,
			getState = function() -- line: 18
				-- upvalues: u3 (ref)
				return u3
			end,
			setState = function(_, p4) -- line: 22
				-- upvalues: u3 (ref)
				u3 = p4
			end
		}
	end
}
