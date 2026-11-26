local CorePackages = game:GetService("CorePackages")

local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local useInputType = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useInputType

local function withLastInputGroup(p2)
	return function(p3)
		local v5 = useInputType()
		return React.createElement(p2, Dash.join(p3, { lastInputGroup = v5 }))
	end
end

return withLastInputGroup
