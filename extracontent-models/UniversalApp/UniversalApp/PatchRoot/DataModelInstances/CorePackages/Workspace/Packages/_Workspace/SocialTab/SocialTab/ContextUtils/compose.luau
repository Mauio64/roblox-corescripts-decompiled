local SocialTab = script:FindFirstAncestor("SocialTab")
local llama = require(SocialTab.dependencies).llama

return function(...) -- line: 5
	-- upvalues: llama (copy)
	local t1 = { ... }

	return function(p1) -- line: 7
		-- upvalues: llama (copy), t1 (copy)
		return llama.List.reduceRight(t1, function(p2, p3) -- line: 8
			return p3(p2)
		end, p1)
	end
end
