local Parent = script:FindFirstAncestor("EditProfileBackground").Parent
local EditProfileBackgroundAnalyticsContext = require(script.Parent.EditProfileBackgroundAnalyticsContext)
local React = require(Parent.React)

return function() -- line: 8
	-- upvalues: React (copy), EditProfileBackgroundAnalyticsContext (copy)
	return React.useContext(EditProfileBackgroundAnalyticsContext)
end
