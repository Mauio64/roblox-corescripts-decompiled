local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local ProfileWrapperContext = require(script.Parent.ProfileWrapperContext)
local React = require(Parent.React)

return function() -- line: 6
	-- upvalues: React (copy), ProfileWrapperContext (copy)
	return React.useContext(ProfileWrapperContext)
end
