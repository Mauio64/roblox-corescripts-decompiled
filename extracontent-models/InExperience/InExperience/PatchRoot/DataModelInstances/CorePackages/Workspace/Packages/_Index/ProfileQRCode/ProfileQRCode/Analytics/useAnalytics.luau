local parent = script:FindFirstAncestor("ProfileQRCode").Parent
local React = require(parent.React)
local ProfileQRCodeAnalytics = require(script.Parent.ProfileQRCodeAnalytics)

return function()
	return React.useContext(ProfileQRCodeAnalytics)
end
