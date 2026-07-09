return function() -- line: 5
	local t1 = {}

	return {
		mockEventReceiver = {
			observeEvent = function(_, s1: string, p2: ((...any) -> ...any)) -- line: 8
				-- upvalues: t1 (copy)
				t1[s1] = p2
			end
		},
		events = t1
	}
end
