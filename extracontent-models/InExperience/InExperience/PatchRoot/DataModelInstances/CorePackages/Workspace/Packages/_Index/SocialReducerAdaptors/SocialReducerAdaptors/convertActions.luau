local SocialReducerAdaptors = script:FindFirstAncestor("SocialReducerAdaptors")
local dependencies = require(SocialReducerAdaptors.dependencies)
local llama = dependencies.llama

return function(p, p2, p3)
	return function(p4, p5)
		local v = p2[p5.type]
		local v2 = not v and { p5 } or v(p5)

		return llama.List.reduce(v2, p, p4 or p3)
	end
end
