local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PasswordError = require(Modules.LuaApp.Enum.AccountSecurity.PasswordError)
local PostChangePassword = require(Modules.LuaApp.Http.Requests.PostChangePassword)
local Promise = require(Modules.LuaApp.Promise)
local Enum = PasswordError.Enum

return function(p1, p2, p3) -- line: 10
	-- upvalues: PostChangePassword (copy), Promise (copy), Enum (copy), HttpService (copy)
	return function(_) -- line: 11
		-- upvalues: PostChangePassword (copy), p1 (copy), p2 (copy), p3 (copy), Promise (copy), Enum (copy), HttpService (copy)
		return PostChangePassword(p1, p2, p3):andThen(function(p5) -- line: 13
			return p5.responseBody
		end):catch(function(p6) -- line: 16
			-- upvalues: Promise (copy), Enum (copy), HttpService (copy)
			if not p6.Body then
				return Promise.reject(Enum.Default)
			end

			local code = HttpService:JSONDecode(p6.Body).errors[1].code
			local v14 = Enum.fromRawValue(code)

			return Promise.reject(v14 or Enum.Default)
		end)
	end
end
