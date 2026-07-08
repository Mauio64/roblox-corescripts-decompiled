local SocialReducerAdaptors = script:FindFirstAncestor("SocialReducerAdaptors")
local llama = require(SocialReducerAdaptors.dependencies).llama

return function(p1, t1: {[any]: any}, p2) -- line: 14
	-- upvalues: llama (copy)
	return function(p3, t2: {[any]: any}) -- line: 15
		-- upvalues: p2 (copy), t1 (copy), llama (copy), p1 (copy)
		local v8 = p3 or p2
		local t3 = { t2 }
		local v10 = t1[t2.type]

		if v10 then
			t3 = v10(t2)
		end

		return llama.List.reduce(t3, p1, v8)
	end
end
