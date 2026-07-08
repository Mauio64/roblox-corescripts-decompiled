local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Promise = require(AuthCommonParent.Promise)
local LogoutFromAllSessionsAndReauthenticateRequest = require(AuthCommon.Http.Requests.LogoutFromAllSessionsAndReauthenticateRequest)

return function(p1) -- line: 11
	-- upvalues: LogoutFromAllSessionsAndReauthenticateRequest (copy), Promise (copy)
	return LogoutFromAllSessionsAndReauthenticateRequest(p1):andThen(function(p2) -- line: 12
		-- upvalues: Promise (copy)
		return Promise.resolve(p2.responseBody)
	end):catch(function(p3) -- line: 14
		-- upvalues: Promise (copy)
		if p3.data then
			return Promise.reject(p3.data.errorCode)
		end

		if not p3.StatusCode then
			return Promise.reject()
		end

		return Promise.reject({ p3.StatusCode })
	end)
end
