local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
require(ProfilePlatform.Analytics.EventNames)
local AppCommonLib = require(parent.AppCommonLib)

return React.createContext({
	fireAnalyticsEvent = function() end,
	scrollViewPositionChangedSignal = AppCommonLib.Signal.new()
})
