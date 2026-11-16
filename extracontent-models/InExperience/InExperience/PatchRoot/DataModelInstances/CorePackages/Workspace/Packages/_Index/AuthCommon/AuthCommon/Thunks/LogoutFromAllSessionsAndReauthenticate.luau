local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Promise = require(parent.Promise)

local LogoutFromAllSessionsAndReauthenticateRequest = require(AuthCommon.Http.Requests.LogoutFromAllSessionsAndReauthenticateRequest)

return function(p)
	return LogoutFromAllSessionsAndReauthenticateRequest(p):andThen(function(p2)
		return Promise.resolve(p2.responseBody)
	end):catch(function(p2)
		if p2.data then
			return Promise.reject(p2.data.errorCode)
		end

		if p2.StatusCode then
			return Promise.reject({ p2.StatusCode })
		end

		return Promise.reject()
	end)
end
