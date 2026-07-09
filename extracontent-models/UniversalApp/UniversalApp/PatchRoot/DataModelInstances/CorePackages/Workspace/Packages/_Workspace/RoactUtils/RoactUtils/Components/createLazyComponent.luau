local RoactUtils = script:FindFirstAncestor("RoactUtils")
local RoactUtilsParent = RoactUtils.Parent
local React = require(RoactUtilsParent.React)

require(RoactUtils.types)

local function createLazyComponent(p1: ((...any) -> ...any)) -- line: 15
	-- upvalues: React (copy)
	local v6 = React.memo(function(p2) -- line: 16
		-- upvalues: React (copy), p1 (copy)
		local v8 = React.useMemo(p1, {})

		return React.createElement(v8, p2)
	end)

	return function(p3) -- line: 20
		-- upvalues: React (copy), v6 (copy)
		return React.createElement(v6, p3)
	end
end

return createLazyComponent
