local AuthenticationStatus = script:FindFirstAncestor("AuthenticationStatus")
local AuthenticationStatusParent = AuthenticationStatus.Parent
local LoginStatus = require(AuthenticationStatusParent.RobloxAppEnums).LoginStatus
local SetAuthenticationStatus = require(AuthenticationStatus.Actions.SetAuthenticationStatus)
local Cryo = require(AuthenticationStatusParent.Cryo)

return function(p1, p2) -- line: 7
	-- upvalues: LoginStatus (copy), SetAuthenticationStatus (copy), Cryo (copy)
	local v8 = p1 or {
		status = LoginStatus.UNKNOWN
	}

	if p2.type == SetAuthenticationStatus.name then
		v8 = Cryo.Dictionary.join(v8, {
			status = p2.status
		})
	end

	return v8
end
