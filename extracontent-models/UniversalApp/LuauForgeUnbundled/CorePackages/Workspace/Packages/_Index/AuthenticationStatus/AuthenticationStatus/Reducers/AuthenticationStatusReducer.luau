local loginStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthenticationStatus/RobloxAppEnums").LoginStatus
local SetAuthenticationStatus = require("@game/CorePackages/Workspace/Packages/_Index/AuthenticationStatus/AuthenticationStatus/Actions/SetAuthenticationStatus")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthenticationStatus/Cryo")

return function(p2, p3)
	local joined = p2 or { status = loginStatus.UNKNOWN }

	if p3.type == SetAuthenticationStatus.name then
		joined = Cryo.Dictionary.join(joined, { status = p3.status })
	end

	return joined
end
