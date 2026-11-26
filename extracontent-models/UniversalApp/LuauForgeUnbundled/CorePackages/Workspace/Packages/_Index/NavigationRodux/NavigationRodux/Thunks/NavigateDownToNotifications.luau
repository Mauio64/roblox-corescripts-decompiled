local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/ArgCheck")
local NavigateDown = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Thunks/NavigateDown")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RobloxAppEnums").AppPage

return function(onClose)
	ArgCheck.isTypeOrNil(onClose, "function", "onClose")

	return NavigateDown({
		name = appPage.Notifications,
		extraProps = { onClose = onClose }
	})
end
