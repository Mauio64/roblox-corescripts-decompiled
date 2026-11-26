local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/ego")
local module2 = require("@luauforge/deferred/fvQ")
local module3 = require("@luauforge/bundled/fBF")
local module4 = require("@luauforge/deferred/fBE")
local module5 = require("@luauforge/bundled/egZ")

return function(props)
	local isVisible = props.isVisible
	local displayOrder = props.DisplayOrder
	local transitionAnimation = props.transitionAnimation
	local titleTextLocalizationKey = props.titleTextLocalizationKey

	local v5 = module4(transitionAnimation or "")
	assert(
		transitionAnimation == nil or transitionAnimation == module3.None or v5 ~= nil,
		string.format("Unhandled transition animation: %q", (tostring(transitionAnimation)))
	)

	local v6 = transitionAnimation ~= module3.None

	if game:GetEngineFeature("SetWebViewTitle") then
		return module5({ titleText = titleTextLocalizationKey })(function(p2)
			return module.createElement(module2, {
				titleText = p2.titleText,
				animated = v6,
				transitionAnimation = v5,
				isVisible = isVisible,
				DisplayOrder = displayOrder,
				notificationType = props.notificationType,
				onClose = props.onClose
			})
		end)
	end

	local jsonEncode = HttpService:JSONEncode({
		animated = v6,
		transitionAnimation = v5
	})

	return module.createElement(module2, {
		isVisible = isVisible,
		DisplayOrder = displayOrder,
		notificationData = jsonEncode,
		notificationType = props.notificationType,
		onClose = props.onClose
	})
end
