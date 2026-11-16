local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local parent = NavigationRodux.Parent

local ArgCheck = require(parent.ArgCheck)
local NavigateDown = require(NavigationRodux.Thunks.NavigateDown)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UrlBuilder = require(parent.UrlBuilder)

local AppPage = RobloxAppEnums.AppPage
local urlBuilder = UrlBuilder.UrlBuilder

return function(userId, conversationId, onClose)
	ArgCheck.isInTypes(userId, { "string", "number" }, "userId")
	ArgCheck.isInTypes(conversationId, { "string", "number" }, "conversationId")
	ArgCheck.isTypeOrNil(onClose, "function", "onClose")

	return NavigateDown({
		name = AppPage.ReportAbuse,
		detail = urlBuilder.user.report({ userId = userId, conversationId = conversationId }),
		extraProps = { onClose = onClose }
	})
end
