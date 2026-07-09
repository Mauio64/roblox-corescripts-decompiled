local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local NativePageWrapper = require(Modules.LuaApp.Components.NativePageWrapper)
local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local mapTransitionAnimationToNativeString = require(Modules.LuaApp.mapTransitionAnimationToNativeString)
local WebViewWindow = require(Modules.LuaApp.Enum.WebViewWindow)
local AppWebView = require(Modules.LuaApp.Components.WebView.AppWebView)

local function YouTubePageWrapper(t1: {[any]: any}) -- line: 24
	-- upvalues: mapTransitionAnimationToNativeString (copy), TransitionAnimation (copy), HttpService (copy), React (copy), NativePageWrapper (copy), NotificationType (copy)
	local isVisible = t1.isVisible
	local DisplayOrder = t1.DisplayOrder
	local url = t1.url
	local title = t1.title
	local transitionAnimation = t1.transitionAnimation
	local v18 = mapTransitionAnimationToNativeString(transitionAnimation)

	assert(transitionAnimation == nil or (transitionAnimation == TransitionAnimation.None or v18 ~= nil), string.format("Unhandled transition animation: %q", (tostring(transitionAnimation))))

	local v19 = transitionAnimation ~= TransitionAnimation.None
	local json = HttpService:JSONEncode({
		url = url,
		title = title,
		animated = v19,
		transitionAnimation = v18
	})

	return React.createElement(NativePageWrapper, {
		isVisible = isVisible,
		DisplayOrder = DisplayOrder,
		notificationData = json,
		notificationType = NotificationType.OPEN_YOUTUBE_VIDEO
	})
end

if require(Modules.LuaApp.Flags.GetFFlagEnableUnifiedStaticWebViews)() then
	return function(t2: {[any]: any}) -- line: 56
		-- upvalues: React (copy), AppWebView (copy), WebViewWindow (copy)
		return React.createElement(AppWebView, {
			url = t2.url,
			title = t2.title,
			transitionAnimation = t2.transitionAnimation,
			windowType = WebViewWindow.Dialog,
			overlayProps = {
				isVisible = t2.isVisible,
				DisplayOrder = t2.DisplayOrder
			}
		})
	end
end

return YouTubePageWrapper
