local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local NativeHandshakeWrapper = require(Modules.LuaApp.Components.NativeHandshakeWrapper)
local withLocalization = require(Modules.LuaApp.withLocalization)

local function renderWrapper(p1) -- line: 11
	-- upvalues: withLocalization (copy), Roact (copy), NativeHandshakeWrapper (copy), HttpService (copy), NotificationType (copy)
	return withLocalization({
		title = "Feature.SocialShare.Action.Redirect",
		errorMessage = "Feature.SocialShare.Response.Error",
		errorSubMessage = "Feature.SocialShare.Response.Error.Subtext"
	})(function(p2) -- line: 16
		-- upvalues: Roact (copy), NativeHandshakeWrapper (copy), p1 (copy), HttpService (copy), NotificationType (copy)
		return Roact.createElement(NativeHandshakeWrapper, {
			responseType = "SDKShare",
			isVisible = p1.isVisible,
			DisplayOrder = p1.displayOrder,
			notificationData = HttpService:JSONEncode(p1.data),
			notificationType = NotificationType.SDK_SHARE,
			title = p2.title,
			errorMessage = p2.errorMessage,
			errorSubMessage = p2.errorSubMessage,
			dispatchTimeout = p1.shareTimeout
		})
	end)
end

return require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy.connect(function(p3, _) -- line: 31
	return {
		shareTimeout = p3.getShareToAccountProviderTimeout()
	}
end)(renderWrapper)
