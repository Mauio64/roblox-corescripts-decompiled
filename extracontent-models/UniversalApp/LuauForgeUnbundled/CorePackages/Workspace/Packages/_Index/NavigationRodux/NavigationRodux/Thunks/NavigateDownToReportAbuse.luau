local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/ArgCheck")
local NavigateDown = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Thunks/NavigateDown")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RobloxAppEnums")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/UrlBuilder")

local appPage = RobloxAppEnums.AppPage
local urlBuilder = UrlBuilder.UrlBuilder

return function(p2, p3, onClose)
	ArgCheck.isInTypes(p2, { "string", "number" }, "userId")
	ArgCheck.isInTypes(p3, { "string", "number" }, "conversationId")
	ArgCheck.isTypeOrNil(onClose, "function", "onClose")

	return NavigateDown({
		name = appPage.ReportAbuse,
		detail = urlBuilder.user.report({ userId = p2, conversationId = p3 }),
		extraProps = { onClose = onClose }
	})
end
