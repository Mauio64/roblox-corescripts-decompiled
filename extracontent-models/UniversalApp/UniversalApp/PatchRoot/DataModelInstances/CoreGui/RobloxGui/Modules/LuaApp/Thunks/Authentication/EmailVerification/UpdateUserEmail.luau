local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local PostUserEmail = require(Modules.LuaApp.Http.Requests.PostUserEmail)
local isStringEmail = require(Modules.LuaApp.Util.isStringEmail)

return function(p1, p2, p3) -- line: 19
	-- upvalues: isStringEmail (copy), Promise (copy), PostUserEmail (copy), HttpService (copy)
	return function(_) -- line: 20
		-- upvalues: isStringEmail (copy), p2 (copy), Promise (copy), PostUserEmail (copy), p1 (copy), p3 (copy), HttpService (copy)
		if not isStringEmail(p2) then
			return Promise.reject({
				EmailInvalid = true
			})
		end

		return PostUserEmail(p1, p2, p3):andThen(function(_) -- line: 27
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end, function(p6) -- line: 30
			-- upvalues: HttpService (copy), Promise (copy)
			local v12 = false
			local v13 = false
			local s1 = ""
			local n1 = 0

			if p6.Body then
				local v16 = HttpService:JSONDecode(p6.Body).errors[1]

				n1 = v16.code
				v12 = n1 == 8
				v13 = n1 == 9
				s1 = v16.message
			end

			return Promise.reject({
				EmailInvalid = v13,
				PasswordIncorrect = v12,
				Message = s1,
				ErrorCode = n1
			})
		end)
	end
end
