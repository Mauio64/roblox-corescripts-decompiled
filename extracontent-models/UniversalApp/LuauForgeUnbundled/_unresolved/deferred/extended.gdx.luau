local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local module = require("@luauforge/deferred/fow")
local module2 = require("@luauforge/bundled/fot")
local module3 = require("@luauforge/bundled/edC")
local module4 = require("@luauforge/deferred/fuc")

local module5 = require("@luauforge/bundled/fQI")

local extended = Roact.PureComponent:extend("NativeReportAbuseWrapper")

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
				notificationType = module2.REPORT_ABUSE,
				onClose = onClose
			})
		end

		return Roact.createElement(module, {
			titleText = p3.titleText,
			isVisible = isVisible,
			DisplayOrder = displayOrder,
			notificationData = url,
			notificationType = module2.REPORT_ABUSE,
			onClose = onClose
		})
	end

	return module3({ titleText = "Feature.GameDetails.Label.ReportAbuse" })(function(p3)
		return fn(p3)
	end)
end

if module5() then
	return function(props)
		return Roact.createElement(module4, {
			url = props.url,
			titleKey = "Feature.GameDetails.Label.ReportAbuse",
			windowCloseCallback = props.onClose,
			overlayProps = {
				isVisible = props.isVisible,
				DisplayOrder = props.DisplayOrder
			}
		})
	end
end

return extended
