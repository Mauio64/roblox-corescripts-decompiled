return function(p1: ((...any) -> ...any), n1: number) -- line: 1
	local u3 = nil
	local v4 = n1 / 1000

	return {
		cancel = function() -- line: 5
			-- upvalues: u3 (ref)
			if u3 then
				task.cancel(u3)
				u3 = nil
			end
		end,
		call = function(...) -- line: 11
			-- upvalues: u3 (ref), v4 (copy), p1 (copy)
			local t1 = { ... }

			u3 = task.delay(v4, function() -- line: 13
				-- upvalues: p1 (copy), t1 (copy)
				p1(unpack(t1))
			end)
		end
	}
end
