local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/ego")
local module2 = require("@luauforge/bundled/fvN")
local module3 = require("@luauforge/deferred/gID")
local module4 = require("@luauforge/bundled/egZ")

local function renderWrapper(data)
	return module4({
		title = "Feature.SocialShare.Action.Redirect",
		errorMessage = "Feature.SocialShare.Response.Error",
		errorSubMessage = "Feature.SocialShare.Response.Error.Subtext"
	})(function(props)
		return module.createElement(module3, {
			isVisible = data.isVisible,
			DisplayOrder = data.displayOrder,
			notificationData = HttpService:JSONEncode(data.data),
			notificationType = module2.SDK_SHARE,
			title = props.title,
			errorMessage = props.errorMessage,
			errorSubMessage = props.errorSubMessage,
			responseType = "SDKShare",
			dispatchTimeout = data.shareTimeout
		})
	end)
end

return require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy.connect(function(p2, p3)
	return {
		shareTimeout = p2.getShareToAccountProviderTimeout()
	}
end)(renderWrapper)
