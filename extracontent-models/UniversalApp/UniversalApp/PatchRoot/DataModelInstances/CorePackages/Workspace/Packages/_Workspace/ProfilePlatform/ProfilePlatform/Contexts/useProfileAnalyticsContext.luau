local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local ProfileAnalyticsContext = require(script.Parent.ProfileAnalyticsContext)
local React = require(Parent.React)

return function() -- line: 6
	-- upvalues: React (copy), ProfileAnalyticsContext (copy)
	return React.useContext(ProfileAnalyticsContext)
end
