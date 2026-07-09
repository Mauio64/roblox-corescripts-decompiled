local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local NativePageWrapper = require(Modules.LuaApp.Components.NativePageWrapper)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local withLocalization = require(Modules.LuaApp.withLocalization)
local AppWebView = require(Modules.LuaApp.Components.WebView.AppWebView)
local GetFFlagEnableUnifiedStaticWebViews = require(Modules.LuaApp.Flags.GetFFlagEnableUnifiedStaticWebViews)
local v9 = Roact.PureComponent:extend("NativeReportAbuseWrapper")

function v9.render(p1) -- line: 22
	-- upvalues: Roact (copy), NativePageWrapper (copy), NotificationType (copy), withLocalization (copy)
	local isVisible = p1.props.isVisible
	local DisplayOrder = p1.props.DisplayOrder
	local url = p1.props.url
	local onClose = p1.props.onClose

	local function v15(p2) -- line: 28
		-- upvalues: Roact (copy), NativePageWrapper (copy), isVisible (copy), DisplayOrder (copy), url (copy), NotificationType (copy), onClose (copy)
		if game:GetEngineFeature("SetWebViewTitle") then
			return Roact.createElement(NativePageWrapper, {
				titleText = p2.titleText,
				isVisible = isVisible,
				DisplayOrder = DisplayOrder,
				url = url,
				notificationType = NotificationType.REPORT_ABUSE,
				onClose = onClose
			})
		end

		return Roact.createElement(NativePageWrapper, {
			titleText = p2.titleText,
			isVisible = isVisible,
			DisplayOrder = DisplayOrder,
			notificationData = url,
			notificationType = NotificationType.REPORT_ABUSE,
			onClose = onClose
		})
	end

	return withLocalization({
		titleText = "Feature.GameDetails.Label.ReportAbuse"
	})(function(p3) -- line: 52
		-- upvalues: v15 (copy)
		return v15(p3)
	end)
end

if GetFFlagEnableUnifiedStaticWebViews() then
	return function(t1: {[any]: any}) -- line: 58
		-- upvalues: Roact (copy), AppWebView (copy)
		return Roact.createElement(AppWebView, {
			titleKey = "Feature.GameDetails.Label.ReportAbuse",
			url = t1.url,
			windowCloseCallback = t1.onClose,
			overlayProps = {
				isVisible = t1.isVisible,
				DisplayOrder = t1.DisplayOrder
			}
		})
	end
end

return v9
