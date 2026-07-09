local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local useInputType = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useInputType

local function withLastInputGroup(p1) -- line: 13
	-- upvalues: useInputType (copy), React (copy), Dash (copy)
	return function(p2) -- line: 14
		-- upvalues: useInputType (copy), React (copy), p1 (copy), Dash (copy)
		local v8 = useInputType()

		return React.createElement(p1, Dash.join(p2, {
			lastInputGroup = v8
		}))
	end
end

return withLastInputGroup
