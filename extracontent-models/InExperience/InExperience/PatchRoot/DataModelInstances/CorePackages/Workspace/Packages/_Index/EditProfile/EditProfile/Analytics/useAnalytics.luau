local Parent = script:FindFirstAncestor("EditProfile").Parent
local EditProfileAnalyticsContext = require(script.Parent.EditProfileAnalyticsContext)
local React = require(Parent.React)

return function() -- line: 8
	-- upvalues: React (copy), EditProfileAnalyticsContext (copy)
	return React.useContext(EditProfileAnalyticsContext)
end
