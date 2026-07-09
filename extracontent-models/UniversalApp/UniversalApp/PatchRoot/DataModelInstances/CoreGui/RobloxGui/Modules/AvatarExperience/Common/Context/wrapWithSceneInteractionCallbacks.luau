local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local SceneInteractionCallbacksContext = require(script.Parent.SceneInteractionCallbacksContext)

return function(p1) -- line: 8
	-- upvalues: Roact (copy), SceneInteractionCallbacksContext (copy), Cryo (copy)
	return function(p2) -- line: 9
		-- upvalues: Roact (copy), SceneInteractionCallbacksContext (copy), p1 (copy), Cryo (copy)
		return Roact.createElement(SceneInteractionCallbacksContext.Consumer, {
			render = function(p3) -- line: 11
				-- upvalues: Roact (copy), p1 (copy), Cryo (copy), p2 (copy)
				return Roact.createElement(p1, Cryo.Dictionary.join(p2, p3))
			end
		})
	end
end
