local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local llama = dependencies.llama

return function(p1) -- line: 6
	-- upvalues: Roact (copy), llama (copy)
	return function(p2) -- line: 7
		-- upvalues: Roact (copy), p1 (copy), llama (copy)
		return function(p3) -- line: 8
			-- upvalues: Roact (copy), p1 (copy), llama (copy), p2 (copy)
			local v8 = Roact.Component:extend("Connected-" .. tostring(p3))

			function v8.render(p4) -- line: 11
				-- upvalues: Roact (copy), p1 (copy), p3 (copy), llama (copy), p2 (copy)
				return Roact.createElement(p1.Consumer, {
					render = function(p5) -- line: 13
						-- upvalues: Roact (copy), p3 (copy), llama (copy), p4 (copy), p2 (copy)
						return Roact.createElement(p3, llama.Dictionary.join(p4.props, p2(p5)))
					end
				})
			end

			return v8
		end
	end
end
