local parent = script:FindFirstAncestor("EditProfile").Parent
local EditProfileAnalyticsContext = require(script.Parent.EditProfileAnalyticsContext)
local React = require(parent.React)

return function()
	return React.useContext(EditProfileAnalyticsContext)
end
