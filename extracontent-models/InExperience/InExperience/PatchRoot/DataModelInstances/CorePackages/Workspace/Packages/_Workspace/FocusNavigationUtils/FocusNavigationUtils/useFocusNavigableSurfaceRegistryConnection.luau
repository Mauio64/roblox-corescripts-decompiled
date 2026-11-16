local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local parent = FocusNavigationUtils.Parent
local React = require(parent.React)

local FocusNavigableSurfaceRegistry = require(FocusNavigationUtils.FocusNavigableSurfaceRegistry)
local useRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useRegisterFocusNavigableSurface
local useDeRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useDeRegisterFocusNavigableSurface
require(FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum)

return function(p, p2, flag: boolean?)
	local v = useRegisterFocusNavigableSurface()
	local v2 = useDeRegisterFocusNavigableSurface()
	local v3

	if p == nil then
		v3 = false
	else
		v3 = flag == nil or flag
	end

	React.useEffect(function()
		if v3 then
			v(p2, p)
		else
			v2(p2, p)
		end

		return function()
			v2(p2, p)
		end
	end, { v3, p2, p })
end
