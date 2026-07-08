local Parent = script:FindFirstAncestor("RobloxAppNavigation").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local useNavigationProps = require(script.Parent.useNavigationProps)

require(script.Parent.types)

local function withNavigationProps(p1) -- line: 12
	-- upvalues: React (copy), Cryo (copy), useNavigationProps (copy)
	return function(p2) -- line: 13
		-- upvalues: React (copy), Cryo (copy), useNavigationProps (copy), p1 (copy)
		return function(p3) -- line: 14
			-- upvalues: React (copy), p2 (copy), Cryo (copy), useNavigationProps (copy), p1 (copy)
			return React.createElement(p2, Cryo.Dictionary.join(p3, useNavigationProps(p1)))
		end
	end
end

return withNavigationProps
