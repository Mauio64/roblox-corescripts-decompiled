local Parent = script:FindFirstAncestor("ExternalAttribution").Parent
local LaunchContext = require(Parent.AppStartup).Enums.LaunchContext
local t1 = {
	Reopen = "Reopen",
	SignUp = "SignUp",
	Login = "Login",
	Unknown = "Unknown"
}

return {
	PostAuthenticationEvent = t1,
	parseLaunchContextToPostAuthenticationEventType = function(p1) -- line: 18
		-- upvalues: LaunchContext (copy), t1 (copy)
		if p1 == LaunchContext.Startup then
			return t1.Reopen
		end

		if p1 == LaunchContext.SignUp then
			return t1.SignUp
		end

		if p1 == LaunchContext.Login then
			return t1.Login
		end

		return t1.Unknown
	end
}
