local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)

require(ProfilePlatform.Analytics.EventNames)

local AppCommonLib = require(ProfilePlatformParent.AppCommonLib)

return React.createContext({
	fireAnalyticsEvent = function() -- line: 29
	end,
	scrollViewPositionChangedSignal = AppCommonLib.Signal.new()
})
