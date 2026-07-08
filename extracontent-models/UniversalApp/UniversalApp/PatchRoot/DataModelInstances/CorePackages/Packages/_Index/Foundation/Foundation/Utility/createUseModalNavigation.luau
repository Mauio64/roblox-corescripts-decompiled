local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)

local function createUseModalNavigation(p1) -- line: 16
	-- upvalues: React (copy)
	return function() -- line: 17
		-- upvalues: React (copy), p1 (copy)
		local v5 = React.useContext(p1)

		return {
			closeAffordanceRef = v5.closeAffordanceRef,
			setContentStartRef = v5.setContentStartRef
		}
	end
end

return createUseModalNavigation
