local llama = require("@game/CorePackages/Workspace/Packages/_Index/SocialReducerAdaptors/SocialReducerAdaptors/dependencies").llama

return function(p2, p3, p4)
	return function(p5, p6)
		local v6 = p3[p6.type]
		local v7 = not v6 and { p6 } or v6(p6)

		return llama.List.reduce(v7, p2, p5 or p4)
	end
end
