local Parent = script:FindFirstAncestor("LazyRequire").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)

local function createLazyComponent(p1: ((...any) -> ...any)) -- line: 13
	-- upvalues: React (copy), Cryo (copy)
	return React.forwardRef(function(p2, p3) -- line: 16
		-- upvalues: React (copy), p1 (copy), Cryo (copy)
		return React.createElement(p1(), Cryo.Dictionary.join(p2, {
			ref = p3
		}))
	end)
end

return createLazyComponent
