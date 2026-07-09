local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AccountPinError = require(Modules.LuaApp.Enum.AccountSecurity.AccountPinError)
local PostUnlockAccountPin = require(Modules.LuaApp.Http.Requests.PostUnlockAccountPin)
local Promise = require(Modules.LuaApp.Promise)
local Enum = AccountPinError.Enum

return function(p1, p2) -- line: 10
	-- upvalues: PostUnlockAccountPin (copy), Promise (copy), Enum (copy), HttpService (copy)
	return function(_) -- line: 11
		-- upvalues: PostUnlockAccountPin (copy), p1 (copy), p2 (copy), Promise (copy), Enum (copy), HttpService (copy)
		return PostUnlockAccountPin(p1, p2):andThen(function(p4) -- line: 13
			return p4.responseBody
		end):catch(function(p5) -- line: 16
			-- upvalues: Promise (copy), Enum (copy), HttpService (copy)
			if not p5.Body then
				return Promise.reject(Enum.Default)
			end

			local code = HttpService:JSONDecode(p5.Body).errors[1].code
			local v13 = Enum.fromRawValue(code)

			return Promise.reject(v13 or Enum.Default)
		end)
	end
end
