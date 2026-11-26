local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local LogoutAllLoggedInUsersRequest = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/LogoutAllLoggedInUsersRequest")
local GetLoggedInUsersMetadataRequest = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/GetLoggedInUsersMetadataRequest")
local fFlagEnableLuaAccountSwitch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableLuaAccountSwitch
local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")
local recordSignOut = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/recordSignOut")

local function recordSignOutOnLogoutAll(p2, p3)
	local v5, v6 = GetLoggedInUsersMetadataRequest(p2, p3):await()

	if v5 and v6 and v6.responseBody and v6.responseBody.logged_in_users_metadata then
		for i, v7 in ipairs(v6.responseBody.logged_in_users_metadata) do
			pcall(function()
				recordSignOut(v7, true)
			end)
		end
	end
end

return function(p2, p3)
	if not fFlagEnableLuaAccountSwitch then
		return Promise.resolve()
	end

	local accountBlob = AppStorageUtilities.getAccountBlob()

	pcall(recordSignOutOnLogoutAll, p2, accountBlob)

	AppStorageUtilities.setAccountBlob("")
	AppStorageUtilities.flush()
	return LogoutAllLoggedInUsersRequest(p2, accountBlob):andThen(function(p4)
		return Promise.resolve(p4.responseBody)
	end):catch(function(p4)
		if p4.data then
			return Promise.reject(p4.data.errorCode)
		end

		if p4.StatusCode then
			return Promise.reject({ p4.StatusCode })
		end

		return Promise.reject()
	end)
end
