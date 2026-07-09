local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local HttpService = game:GetService("HttpService")
local Promise = require(LoginV2Parent.Promise)
local PostStartPasskeyAuthentication = require(LoginV2.Requests.PostStartPasskeyAuthentication)

return function(p1) -- line: 10
	-- upvalues: PostStartPasskeyAuthentication (copy), Promise (copy), HttpService (copy)
	return function() -- line: 11
		-- upvalues: PostStartPasskeyAuthentication (copy), p1 (copy), Promise (copy), HttpService (copy)
		return PostStartPasskeyAuthentication(p1):andThen(function(p2) -- line: 12
			-- upvalues: Promise (copy)
			if p2 and p2.responseBody then
				return p2.responseBody
			end

			return Promise.reject()
		end, function(p3) -- line: 17
			-- upvalues: HttpService (copy), Promise (copy)
			local n1 = 0

			if p3.Body then
				n1 = HttpService:JSONDecode(p3.Body).errors[1].code
			end

			return Promise.reject({
				errorCode = n1
			})
		end)
	end
end
