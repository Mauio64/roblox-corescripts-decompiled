local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local FocusNavigationUtilsParent = FocusNavigationUtils.Parent
local React = require(FocusNavigationUtilsParent.React)
local FocusNavigableSurfaceRegistry = require(FocusNavigationUtils.FocusNavigableSurfaceRegistry)
local useRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useRegisterFocusNavigableSurface
local useDeRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useDeRegisterFocusNavigableSurface

require(FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum)

return function(p1, p2, b1: boolean?) -- line: 17
	-- upvalues: useRegisterFocusNavigableSurface (copy), useDeRegisterFocusNavigableSurface (copy), React (copy)
	local v10 = useRegisterFocusNavigableSurface()
	local v11 = useDeRegisterFocusNavigableSurface()
	local v12 = p1 ~= nil and (b1 == nil or b1)

	React.useEffect(function() -- line: 26
		-- upvalues: v12 (copy), v10 (copy), p2 (copy), p1 (copy), v11 (copy)
		if v12 then
			v10(p2, p1)
		else
			v11(p2, p1)
		end

		return function() -- line: 33
			-- upvalues: v11 (copy), p2 (copy), p1 (copy)
			v11(p2, p1)
		end
	end, {
		v12,
		p2,
		p1
	})
end
