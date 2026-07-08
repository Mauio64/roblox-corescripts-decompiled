local SetUserTyping = require(script.Parent.SetUserTyping)
local n1 = 0

return function(p1, p2) -- line: 7
	-- upvalues: n1 (ref), SetUserTyping (copy)
	return function(p3) -- line: 8
		-- upvalues: n1 (ref), SetUserTyping (copy), p1 (copy), p2 (copy)
		spawn(function() -- line: 9
			-- upvalues: n1 (ref), p3 (copy), SetUserTyping (copy), p1 (copy), p2 (copy)
			n1 += 1

			local v6 = n1

			p3:dispatch(SetUserTyping(p1, p2, true))
			wait(8)

			if v6 == n1 then
				p3:dispatch(SetUserTyping(p1, p2, false))
			end
		end)
	end
end
