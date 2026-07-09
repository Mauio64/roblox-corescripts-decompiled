local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local HttpService = game:GetService("HttpService")
local Promise = require(LoginV2Parent.Promise)
local PostStartAuthenticationByUser = require(LoginV2.Requests.PostStartAuthenticationByUser)

require(LoginV2.Common.LoginV2RequestTypes)

return function(p1, p2) -- line: 10
	-- upvalues: PostStartAuthenticationByUser (copy), Promise (copy), HttpService (copy)
	return function() -- line: 11
		-- upvalues: PostStartAuthenticationByUser (copy), p1 (copy), p2 (copy), Promise (copy), HttpService (copy)
		return PostStartAuthenticationByUser(p1, p2):andThen(function(p3) -- line: 12
			-- upvalues: Promise (copy)
			if p3 and p3.responseBody then
				return p3.responseBody
			end

			return Promise.reject()
		end, function(p4) -- line: 17
			-- upvalues: HttpService (copy), Promise (copy)
			local n1 = 0

			if p4.Body then
				n1 = HttpService:JSONDecode(p4.Body).errors[1].code
			end

			return Promise.reject({
				errorCode = n1
			})
		end)
	end
end
