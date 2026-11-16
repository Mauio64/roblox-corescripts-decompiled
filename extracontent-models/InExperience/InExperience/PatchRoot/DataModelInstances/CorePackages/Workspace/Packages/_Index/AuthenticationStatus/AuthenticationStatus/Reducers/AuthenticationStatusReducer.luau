local AuthenticationStatus = script:FindFirstAncestor("AuthenticationStatus")
local parent = AuthenticationStatus.Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local LoginStatus = RobloxAppEnums.LoginStatus
local SetAuthenticationStatus = require(AuthenticationStatus.Actions.SetAuthenticationStatus)
local Cryo = require(parent.Cryo)

return function(p, p2)
	local joined = p or { status = LoginStatus.UNKNOWN }

	if p2.type == SetAuthenticationStatus.name then
		joined = Cryo.Dictionary.join(joined, { status = p2.status })
	end

	return joined
end
