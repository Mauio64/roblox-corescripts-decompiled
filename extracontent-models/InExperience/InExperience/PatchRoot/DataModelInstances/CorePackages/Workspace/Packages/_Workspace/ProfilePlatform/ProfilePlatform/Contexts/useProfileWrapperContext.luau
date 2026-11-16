local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local ProfileWrapperContext = require(script.Parent.ProfileWrapperContext)
local React = require(parent.React)

return function()
	return React.useContext(ProfileWrapperContext)
end
