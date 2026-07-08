local ParentParent = script.Parent.Parent.Parent
local ReactRoblox = require(ParentParent.Dev.ReactRoblox)

return function(p1, p2) -- line: 6
	-- upvalues: ReactRoblox (copy)
	local v5 = p2 or 1
	local n1 = 0

	while v5 > n1 and not p1() do
		ReactRoblox.act(function() -- line: 10
			-- upvalues: n1 (ref)
			n1 += task.wait()
		end)
	end
end
