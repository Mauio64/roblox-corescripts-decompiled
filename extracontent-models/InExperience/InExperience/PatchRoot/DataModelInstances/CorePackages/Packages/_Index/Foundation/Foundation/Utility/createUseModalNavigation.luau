local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local function createUseModalNavigation(p)
	return function()
		local v = React.useContext(p)

		return {
			closeAffordanceRef = v.closeAffordanceRef,
			setContentStartRef = v.setContentStartRef
		}
	end
end

return createUseModalNavigation
