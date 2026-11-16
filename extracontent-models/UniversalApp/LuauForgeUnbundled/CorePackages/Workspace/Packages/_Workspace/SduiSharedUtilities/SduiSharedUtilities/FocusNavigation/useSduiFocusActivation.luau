local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")

local getSduiFocusActivationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/FocusNavigation/getSduiFocusActivationStore")

local function useSduiFocusActivation(p2, p3)
	React.useEffect(function()
		if p2 == nil or p3 == nil then
			return
		end

		return getSduiFocusActivationStore().register(p2, p3)
	end, { p2, p3 })
end

return useSduiFocusActivation
