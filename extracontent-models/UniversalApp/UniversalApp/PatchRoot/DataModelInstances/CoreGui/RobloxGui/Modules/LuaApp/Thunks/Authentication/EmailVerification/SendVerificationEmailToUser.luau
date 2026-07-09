local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SendUserVerifyEmail = require(Modules.LuaApp.Http.Requests.SendUserVerifyEmail)

return function(p1) -- line: 13
	-- upvalues: SendUserVerifyEmail (copy)
	return function(_) -- line: 14
		-- upvalues: SendUserVerifyEmail (copy), p1 (copy)
		return SendUserVerifyEmail(p1)
	end
end
