local parent = script:FindFirstAncestor("RobloxAppNavigation").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local useNavigationProps = require(script.Parent.useNavigationProps)
require(script.Parent.types)

local function withNavigationProps(p)
	return function(p2)
		return function(p3)
			return React.createElement(p2, Cryo.Dictionary.join(p3, useNavigationProps(p)))
		end
	end
end

return withNavigationProps
