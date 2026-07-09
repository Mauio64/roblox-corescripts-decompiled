local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent

require(ProfilePlatform.Common.Enums)

local React = require(ProfilePlatformParent.React)
local HttpService = game:GetService("HttpService")

return function(p1) -- line: 10
	-- upvalues: React (copy), HttpService (copy)
	return React.useMemo(function() -- line: 11
		-- upvalues: p1 (copy), HttpService (copy)
		return `ProfilePlatform_${ p1 }_${ HttpService:GenerateGUID() }`
	end, { p1 })
end
