local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local ProfileScrollContext = require(script.Parent.ProfileScrollContext)

return function() -- line: 7
	-- upvalues: React (copy), ProfileScrollContext (copy)
	return React.useContext(ProfileScrollContext)
end
