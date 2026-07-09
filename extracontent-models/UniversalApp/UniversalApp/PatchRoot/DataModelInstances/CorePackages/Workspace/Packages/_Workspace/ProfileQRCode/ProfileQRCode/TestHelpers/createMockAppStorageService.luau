local function createMockRobloxEventReceiver(p1) -- line: 1
	return {
		GetItem = function(_, _) -- line: 3
			-- upvalues: p1 (copy)
			if p1 then
				return p1
			end

			return "true"
		end,
		SetItem = function(_, _, _) -- line: 7
		end,
		Flush = function(_) -- line: 11
		end
	}
end

return createMockRobloxEventReceiver
