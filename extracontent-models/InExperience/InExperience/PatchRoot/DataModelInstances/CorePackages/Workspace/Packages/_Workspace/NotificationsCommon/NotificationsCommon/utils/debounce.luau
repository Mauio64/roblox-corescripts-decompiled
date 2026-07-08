return function(p1, n1: number?) -- line: 1
	local u3 = nil
	local v4 = n1 or 0.5

	return function(...) -- line: 5
		-- upvalues: u3 (ref), v4 (copy), p1 (copy)
		local t1 = { ... }

		if u3 then
			task.cancel(u3)
		end

		u3 = task.delay(v4, function() -- line: 12
			-- upvalues: p1 (copy), t1 (copy), u3 (ref)
			p1(unpack(t1))
			u3 = nil
		end)
	end
end
