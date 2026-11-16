local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local ProfileAnalyticsContext = require(script.Parent.ProfileAnalyticsContext)
local React = require(parent.React)

return function()
	return React.useContext(ProfileAnalyticsContext)
end
