return {
	maybe = function(p1: ((...any) -> ...any)) -- line: 10
		local _, result, v4 = xpcall(function() -- line: 12
			-- upvalues: p1 (copy)
			return p1(), true
		end, function() -- line: 14
		end)

		if v4 then
			return result
		end

		return nil
	end
}
