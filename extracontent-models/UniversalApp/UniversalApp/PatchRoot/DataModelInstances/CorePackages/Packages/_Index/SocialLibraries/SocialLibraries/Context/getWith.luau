local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local Roact = require(SocialLibraries.dependencies).Roact

return function(p1) -- line: 5
	-- upvalues: Roact (copy)
	return function(p2) -- line: 6
		-- upvalues: Roact (copy), p1 (copy)
		assert(type(p2) == "function", "Expect renderCallback to be a function.")

		return Roact.createElement(p1.Consumer, {
			render = p2
		})
	end
end
