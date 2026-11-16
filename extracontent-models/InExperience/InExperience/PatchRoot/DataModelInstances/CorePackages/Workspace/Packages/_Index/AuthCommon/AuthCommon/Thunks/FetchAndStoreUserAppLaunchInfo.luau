local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local parent = AuthCommon.Parent
local GetUserAppLaunchInfo = require(AuthCommon.Http.Requests.GetUserAppLaunchInfo)
local Promise = require(parent.Promise)
local AppStorageService = game:GetService("AppStorageService")

return function(p)
	local _, v = Promise.new(function(callback)
		GetUserAppLaunchInfo(p):andThen(function(p2)
			if p2 and p2.responseBody then
				local name = p2.responseBody.name
				local id = tostring(p2.responseBody.id)
				AppStorageUtilities.setIncompleteSignupUserId(id)
				AppStorageUtilities.setIncompleteSignupUsername(name)
				AppStorageService:Flush()
			end

			callback(true)
		end):catch(function(_)
			callback(false)
		end)
	end):await()
	return v
end
