local Parent = script:FindFirstAncestor("ProfileQRCode").Parent
local React = require(Parent.React)
local ProfileQRCodeAnalytics = require(script.Parent.ProfileQRCodeAnalytics)

return function() -- line: 8
	-- upvalues: React (copy), ProfileQRCodeAnalytics (copy)
	return React.useContext(ProfileQRCodeAnalytics)
end
