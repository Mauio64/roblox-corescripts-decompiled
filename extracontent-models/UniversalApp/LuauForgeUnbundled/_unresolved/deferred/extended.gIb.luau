local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local module = require("@luauforge/deferred/fvQ")
local module2 = require("@luauforge/bundled/fvN")
local module3 = require("@luauforge/bundled/egZ")
local module4 = require("@luauforge/deferred/fBD")

local module5 = require("@luauforge/bundled/gvh")

local extended = Roact.PureComponent:extend("NativeViewProfileWrapper")

function extended.render(p2)
	local isVisible = p2.props.isVisible
	local displayOrder = p2.props.DisplayOrder
	local url = p2.props.url
	local onClose = p2.props.onClose

	local function fn(p3)
		if game:GetEngineFeature("SetWebViewTitle") then
			return Roact.createElement(module, {
				titleText = p3.titleText,
				isVisible = isVisible,
				DisplayOrder = displayOrder,
				url = url,
				notificationType = module2.VIEW_PROFILE,
				onClose = onClose
			})
		end

		return Roact.createElement(module, {
			titleText = p3.titleText,
			isVisible = isVisible,
			DisplayOrder = displayOrder,
			notificationData = url,
			notificationType = module2.VIEW_PROFILE,
			onClose = onClose
		})
	end

	return module3({ titleText = "CommonUI.Features.Label.Profile" })(function(p3)
		return fn(p3)
	end)
end

if module5() then
	return function(props)
		return Roact.createElement(module4, {
			url = props.url,
			titleKey = "CommonUI.Features.Label.Profile",
			windowCloseCallback = props.onClose,
			overlayProps = {
				isVisible = props.isVisible,
				DisplayOrder = props.DisplayOrder
			}
		})
	end
end

return extended
