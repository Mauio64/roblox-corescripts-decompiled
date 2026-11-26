local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")

local getModalSignalStore = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SignalStores/getModalSignalStore")

return function()
	return React.useMemo(function()
		return getModalSignalStore(false)
	end, {})
end
