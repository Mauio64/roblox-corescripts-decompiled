local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")

local FocusNavigableSurfaceRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusNavigableSurfaceRegistry")
local useRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useRegisterFocusNavigableSurface
local useDeRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useDeRegisterFocusNavigableSurface
require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusNavigableSurfaceIdentifierEnum")

return function(p2, p3, p4)
	local v5 = useRegisterFocusNavigableSurface()
	local v6 = useDeRegisterFocusNavigableSurface()

	local v7 = not (p2 == nil) and (p4 == nil or p4)
	React.useEffect(function()
		if v7 then
			v5(p3, p2)
		else
			v6(p3, p2)
		end

		return function()
			v6(p3, p2)
		end
	end, { v7, p3, p2 })
end
