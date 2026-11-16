local parent = script:FindFirstAncestor("EditProfileBackground").Parent
local EditProfileBackgroundAnalyticsContext = require(script.Parent.EditProfileBackgroundAnalyticsContext)
local React = require(parent.React)

return function()
	return React.useContext(EditProfileBackgroundAnalyticsContext)
end
