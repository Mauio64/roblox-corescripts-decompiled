local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local parent = NavigationRodux.Parent

local ArgCheck = require(parent.ArgCheck)
local NavigateDown = require(NavigationRodux.Thunks.NavigateDown)
local RobloxAppEnums = require(parent.RobloxAppEnums)

local AppPage = RobloxAppEnums.AppPage

return function(detail, onClose)
	ArgCheck.isInTypes(detail, { "string", "number" }, "userId")
	ArgCheck.isTypeOrNil(onClose, "function", "onClose")

	return NavigateDown({
		name = AppPage.ViewUserProfile,
		detail = detail,
		extraProps = { onClose = onClose }
	})
end
