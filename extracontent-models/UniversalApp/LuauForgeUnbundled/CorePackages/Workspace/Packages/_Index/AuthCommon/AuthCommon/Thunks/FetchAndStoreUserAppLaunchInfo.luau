local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")

local GetUserAppLaunchInfo = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/GetUserAppLaunchInfo")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local AppStorageService = game:GetService("AppStorageService")

return function(p2)
	local v5, v6 = Promise.new(function(callback)
		GetUserAppLaunchInfo(p2):andThen(function(p3)
			if p3 and p3.responseBody then
				local name = p3.responseBody.name
				local id = tostring(p3.responseBody.id)
				AppStorageUtilities.setIncompleteSignupUserId(id)
				AppStorageUtilities.setIncompleteSignupUsername(name)
				AppStorageService:Flush()
			end

			callback(true)
		end):catch(function(p3)
			callback(false)
		end)
	end):await()
	return v6
end
