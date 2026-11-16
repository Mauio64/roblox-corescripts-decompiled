local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local llama = dependencies.llama

return function(p)
	return function(callback)
		return function(p2)
			local extended = roact.Component:extend("Connected-" .. tostring(p2))

			function extended.render(p3)
				return roact.createElement(p.Consumer, {
					render = function(p4)
						return roact.createElement(p2, llama.Dictionary.join(p3.props, callback(p4)))
					end
				})
			end

			return extended
		end
	end
end
