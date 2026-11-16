local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
require(ProfilePlatform.Common.Enums)
local React = require(parent.React)

local HttpService = game:GetService("HttpService")

return function(p)
	return React.useMemo(function()
		return `ProfilePlatform_${p}_${HttpService:GenerateGUID()}`
	end, { p })
end
