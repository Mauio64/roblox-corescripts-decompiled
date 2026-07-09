local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local Roact = require(Modules.Common.Roact)
local NativePageWrapper = require(Modules.LuaApp.Components.NativePageWrapper)
local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local mapTransitionAnimationToNativeString = require(Modules.LuaApp.mapTransitionAnimationToNativeString)
local withLocalization = require(Modules.LuaApp.withLocalization)

return function(p1) -- line: 10
	-- upvalues: mapTransitionAnimationToNativeString (copy), TransitionAnimation (copy), withLocalization (copy), Roact (copy), NativePageWrapper (copy), HttpService (copy)
	local isVisible = p1.isVisible
	local DisplayOrder = p1.DisplayOrder
	local transitionAnimation = p1.transitionAnimation
	local titleTextLocalizationKey = p1.titleTextLocalizationKey
	local v13 = mapTransitionAnimationToNativeString(transitionAnimation or "")

	assert(transitionAnimation == nil or (transitionAnimation == TransitionAnimation.None or v13 ~= nil), string.format("Unhandled transition animation: %q", (tostring(transitionAnimation))))

	local v14 = transitionAnimation ~= TransitionAnimation.None

	if game:GetEngineFeature("SetWebViewTitle") then
		return withLocalization({
			titleText = titleTextLocalizationKey
		})(function(p2) -- line: 28
			-- upvalues: Roact (copy), NativePageWrapper (copy), v14 (copy), v13 (copy), isVisible (copy), DisplayOrder (copy), p1 (copy)
			return Roact.createElement(NativePageWrapper, {
				titleText = p2.titleText,
				animated = v14,
				transitionAnimation = v13,
				isVisible = isVisible,
				DisplayOrder = DisplayOrder,
				notificationType = p1.notificationType,
				onClose = p1.onClose
			})
		end)
	end

	local json = HttpService:JSONEncode({
		animated = v14,
		transitionAnimation = v13
	})

	return Roact.createElement(NativePageWrapper, {
		isVisible = isVisible,
		DisplayOrder = DisplayOrder,
		notificationData = json,
		notificationType = p1.notificationType,
		onClose = p1.onClose
	})
end
