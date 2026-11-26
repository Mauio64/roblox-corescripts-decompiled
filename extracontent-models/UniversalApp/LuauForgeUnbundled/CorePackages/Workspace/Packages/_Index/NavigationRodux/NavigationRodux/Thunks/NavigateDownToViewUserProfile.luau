local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/ArgCheck")
local NavigateDown = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Thunks/NavigateDown")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RobloxAppEnums").AppPage

return function(p2, onClose)
	ArgCheck.isInTypes(p2, { "string", "number" }, "userId")
	ArgCheck.isTypeOrNil(onClose, "function", "onClose")

	return NavigateDown({
		name = appPage.ViewUserProfile,
		detail = p2,
		extraProps = { onClose = onClose }
	})
end
