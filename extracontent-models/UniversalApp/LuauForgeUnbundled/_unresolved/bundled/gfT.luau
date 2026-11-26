local launchContext = require("@luauforge/bundled/gfQ").Enums.LaunchContext

local v5 = {
	Reopen = "Reopen",
	SignUp = "SignUp",
	Login = "Login",
	Unknown = "Unknown"
}

local v6 = { PostAuthenticationEvent = v5 }

function v6.parseLaunchContextToPostAuthenticationEventType(p2)
	if p2 == launchContext.Startup then
		return v5.Reopen
	end

	if p2 == launchContext.SignUp then
		return v5.SignUp
	end

	if p2 == launchContext.Login then
		return v5.Login
	end

	return v5.Unknown
end

return v6
