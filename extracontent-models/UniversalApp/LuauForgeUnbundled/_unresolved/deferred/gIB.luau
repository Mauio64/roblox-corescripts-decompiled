local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/ego")
local module2 = require("@luauforge/bundled/fvN")
local module3 = require("@luauforge/deferred/fvQ")

return function(props)
	local isVisible = props.isVisible
	local displayOrder = props.DisplayOrder
	local jsonEncode = HttpService:JSONEncode(props.data)

	return module.createElement(module3, {
		isVisible = isVisible,
		DisplayOrder = displayOrder,
		notificationData = jsonEncode,
		notificationType = module2.NATIVE_SHARE
	})
end
