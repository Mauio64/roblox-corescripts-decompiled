local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact

return function(p)
	return function(render)
		assert(type(render) == "function", "Expect renderCallback to be a function.")
		return roact.createElement(p.Consumer, { render = render })
	end
end
