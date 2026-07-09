local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AccountPinError = require(Modules.LuaApp.Enum.AccountSecurity.AccountPinError)
local PostLockAccountPin = require(Modules.LuaApp.Http.Requests.PostLockAccountPin)
local Promise = require(Modules.LuaApp.Promise)
local Enum = AccountPinError.Enum

return function(p1) -- line: 10
	-- upvalues: PostLockAccountPin (copy), Promise (copy), Enum (copy), HttpService (copy)
	return function(_) -- line: 11
		-- upvalues: PostLockAccountPin (copy), p1 (copy), Promise (copy), Enum (copy), HttpService (copy)
		return PostLockAccountPin(p1):andThen(function(p3) -- line: 13
			return p3.responseBody
		end):catch(function(p4) -- line: 16
			-- upvalues: Promise (copy), Enum (copy), HttpService (copy)
			if not p4.Body then
				return Promise.reject(Enum.Default)
			end

			local code = HttpService:JSONDecode(p4.Body).errors[1].code
			local v12 = Enum.fromRawValue(code)

			return Promise.reject(v12 or Enum.Default)
		end)
	end
end
