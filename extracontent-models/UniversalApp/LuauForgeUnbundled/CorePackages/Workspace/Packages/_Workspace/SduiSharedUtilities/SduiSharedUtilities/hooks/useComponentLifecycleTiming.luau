local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiLoadTimer")

local function useComponentLifecycleTiming(p2, p3)
	React.useEffect(function()
		if p2 then
			p2.logComponentMounted()
		end
	end, { p2 })

	React.useEffect(function()
		if p2 and p3 then
			p2.logComponentReady()
		end
	end, { p2, p3 })
end

return useComponentLifecycleTiming
