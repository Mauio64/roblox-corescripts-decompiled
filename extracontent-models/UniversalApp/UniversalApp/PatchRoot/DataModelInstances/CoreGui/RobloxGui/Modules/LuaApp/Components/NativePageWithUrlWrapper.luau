local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local NativePageWrapper = require(Modules.LuaApp.Components.NativePageWrapper)
local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local mapTransitionAnimationToNativeString = require(Modules.LuaApp.mapTransitionAnimationToNativeString)
local withLocalization = require(Modules.LuaApp.withLocalization)
local AppWebView = require(Modules.LuaApp.Components.WebView.AppWebView)

local function NativePageWithUrlWrapper(t1: {[any]: any}) -- line: 29
	-- upvalues: mapTransitionAnimationToNativeString (copy), TransitionAnimation (copy), HttpService (copy), React (copy), NativePageWrapper (copy), withLocalization (copy)
	local isVisible = t1.isVisible
	local DisplayOrder = t1.DisplayOrder
	local url = t1.url
	local title = t1.title
	local titleKey = t1.titleKey
	local transitionAnimation = t1.transitionAnimation
	local notificationType = t1.notificationType
	local onClose = t1.onClose
	local v20 = mapTransitionAnimationToNativeString(transitionAnimation)

	assert(transitionAnimation == nil or (transitionAnimation == TransitionAnimation.None or v20 ~= nil), string.format("Unhandled transition animation: %q", (tostring(transitionAnimation))))

	local v21 = transitionAnimation ~= TransitionAnimation.None

	local function v22(p1) -- line: 48
		-- upvalues: HttpService (copy), url (copy), v21 (copy), v20 (copy), React (copy), NativePageWrapper (copy), isVisible (copy), DisplayOrder (copy), notificationType (copy), onClose (copy)
		local json = HttpService:JSONEncode({
			url = url,
			title = p1,
			animated = v21,
			transitionAnimation = v20
		})

		return React.createElement(NativePageWrapper, {
			isVisible = isVisible,
			DisplayOrder = DisplayOrder,
			notificationData = json,
			notificationType = notificationType,
			onClose = onClose
		})
	end

	if titleKey ~= nil and title == nil then
		return withLocalization({
			title = titleKey
		})(function(p2) -- line: 68
			-- upvalues: v22 (copy)
			return v22(p2.title)
		end)
	end

	return v22(title)
end

if require(Modules.LuaApp.Flags.GetFFlagEnableUnifiedStaticWebViews)() then
	return function(t2: {[any]: any}) -- line: 77
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

return NativePageWithUrlWrapper
