require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local HttpService = game:GetService("HttpService")

return function(p2)
	return React.useMemo(function()
		return `ProfilePlatform_${p2}_${HttpService:GenerateGUID()}`
	end, { p2 })
end
