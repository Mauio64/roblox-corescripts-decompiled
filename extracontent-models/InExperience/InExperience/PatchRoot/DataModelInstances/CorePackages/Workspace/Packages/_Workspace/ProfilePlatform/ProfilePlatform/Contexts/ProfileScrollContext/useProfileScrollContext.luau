local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(parent.React)

local ProfileScrollContext = require(script.Parent.ProfileScrollContext)

return function()
	return React.useContext(ProfileScrollContext)
end
