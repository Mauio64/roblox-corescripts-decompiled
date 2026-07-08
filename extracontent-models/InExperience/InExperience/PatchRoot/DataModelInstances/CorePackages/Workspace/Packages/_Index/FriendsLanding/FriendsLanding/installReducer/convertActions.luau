local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local llama = require(FriendsLanding.dependencies).llama

return function(p1, p2, p3) -- line: 6
	-- upvalues: llama (copy)
	return function(p4, p5) -- line: 7
		-- upvalues: p3 (copy), p2 (copy), llama (copy), p1 (copy)
		local v8 = p4 or p3
		local t1 = { p5 }
		local v10 = p2[p5.type]

		if v10 then
			t1 = v10(p5)
		end

		return llama.List.reduce(t1, p1, v8)
	end
end
