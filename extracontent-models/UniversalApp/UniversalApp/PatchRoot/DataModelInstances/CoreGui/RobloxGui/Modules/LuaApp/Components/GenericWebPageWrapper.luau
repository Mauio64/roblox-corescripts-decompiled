local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local mapTransitionAnimationToNativeString = require(Modules.LuaApp.mapTransitionAnimationToNativeString)
local withLocalization = require(Modules.LuaApp.withLocalization)
local NativePageWrapper = require(Modules.LuaApp.Components.NativePageWrapper)
local AppWebView = require(Modules.LuaApp.Components.WebView.AppWebView)
local WebViewStateTracker = require(CorePackages.Workspace.Packages.WebViewUtils).WebViewStateTracker
local GetFFlagEnableUnifiedStaticWebViews = require(Modules.LuaApp.Flags.GetFFlagEnableUnifiedStaticWebViews)
local FFlagEnableWebViewStateTracker = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableWebViewStateTracker
local v14 = game:DefineFastFlag("EnableWebViewStateTrackerInGenericWebPageWrapper", false)

local function GenericWebPageWrapper(t1: {[any]: any}) -- line: 35
	-- upvalues: mapTransitionAnimationToNativeString (copy), TransitionAnimation (copy), FFlagEnableWebViewStateTracker (copy), v14 (copy), React (copy), WebViewStateTracker (copy), HttpService (copy), NativePageWrapper (copy), NotificationType (copy), withLocalization (copy)
	local isVisible = t1.isVisible
	local DisplayOrder = t1.DisplayOrder
	local url = t1.url
	local titleKey = t1.titleKey
	local title = t1.title
	local searchParams = t1.searchParams
	local transitionAnimation = t1.transitionAnimation
	local v24 = mapTransitionAnimationToNativeString(transitionAnimation)

	assert(transitionAnimation == nil or (transitionAnimation == TransitionAnimation.None or v24 ~= nil), string.format("Unhandled transition animation: %q", (tostring(transitionAnimation))))

	local v25 = transitionAnimation ~= TransitionAnimation.None

	if FFlagEnableWebViewStateTracker and v14 then
		React.useEffect(function() -- line: 54
			-- upvalues: WebViewStateTracker (copy), url (copy), title (copy), isVisible (copy)
			WebViewStateTracker.markOpen(url, title, isVisible)
		end, {})
		React.useEffect(function() -- line: 57
			-- upvalues: WebViewStateTracker (copy), url (copy), title (copy), isVisible (copy)
			WebViewStateTracker.updateMetadata(url, title, isVisible)
		end, {
			url,
			title,
			isVisible
		})
	end

	local function v26() -- line: 62
		-- upvalues: WebViewStateTracker (copy), t1 (copy)
		WebViewStateTracker.markClosed()

		if t1.onClose then
			t1.onClose()
		end
	end
	local function v27(p1) -- line: 69
		-- upvalues: HttpService (copy), url (copy), searchParams (copy), v25 (copy), v24 (copy), React (copy), NativePageWrapper (copy), isVisible (copy), DisplayOrder (copy), NotificationType (copy), FFlagEnableWebViewStateTracker (copy), v14 (copy), v26 (copy), t1 (copy)
		local json = HttpService:JSONEncode({
			url = url,
			title = p1,
			searchParams = searchParams,
			animated = v25,
			transitionAnimation = v24
		})

		return React.createElement(NativePageWrapper, {
			isVisible = isVisible,
			DisplayOrder = DisplayOrder,
			notificationData = json,
			notificationType = NotificationType.OPEN_CUSTOM_WEBVIEW,
			onClose = if not FFlagEnableWebViewStateTracker or not v14 then t1.onClose else v26
		})
	end

	if titleKey ~= nil and title == nil then
		return withLocalization({
			title = titleKey
		})(function(p2) -- line: 92
			-- upvalues: v27 (copy)
			return v27(p2.title)
		end)
	end

	return v27(title)
end

if GetFFlagEnableUnifiedStaticWebViews() then
	return function(t2: {[any]: any}) -- line: 101
		-- upvalues: React (copy), AppWebView (copy)
		return React.createElement(AppWebView, {
			url = t2.url,
			title = t2.title,
			titleKey = t2.titleKey,
			searchParams = t2.searchParams,
			transitionAnimation = t2.transitionAnimation,
			windowCloseCallback = t2.onClose,
			overlayProps = {
				isVisible = t2.isVisible,
				DisplayOrder = t2.DisplayOrder
			}
		})
	end
end

return GenericWebPageWrapper
