local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")

local LogoutFromAllSessionsAndReauthenticateRequest = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/LogoutFromAllSessionsAndReauthenticateRequest")

return function(p2)
	return LogoutFromAllSessionsAndReauthenticateRequest(p2):andThen(function(p3)
		return Promise.resolve(p3.responseBody)
	end):catch(function(p3)
		if p3.data then
			return Promise.reject(p3.data.errorCode)
		end

		if p3.StatusCode then
			return Promise.reject({ p3.StatusCode })
		end

		return Promise.reject()
	end)
end
