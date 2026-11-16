local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Promise = require(parent.Promise)
local LogoutAllLoggedInUsersRequest = require(AuthCommon.Http.Requests.LogoutAllLoggedInUsersRequest)
local GetLoggedInUsersMetadataRequest = require(AuthCommon.Http.Requests.GetLoggedInUsersMetadataRequest)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local recordSignOut = require(AuthCommon.Utils.recordSignOut)

local function recordSignOutOnLogoutAll(p, p2)
	local v, v2 = GetLoggedInUsersMetadataRequest(p, p2):await()

	if v and v2 and v2.responseBody and v2.responseBody.logged_in_users_metadata then
		for _, v3 in ipairs(v2.responseBody.logged_in_users_metadata) do
			pcall(function()
				recordSignOut(v3, true)
			end)
		end
	end
end

return function(p, _: boolean)
	if not FFlagEnableLuaAccountSwitch then
		return Promise.resolve()
	end

	local accountBlob = AppStorageUtilities.getAccountBlob()

	pcall(recordSignOutOnLogoutAll, p, accountBlob)

	AppStorageUtilities.setAccountBlob("")
	AppStorageUtilities.flush()
	return LogoutAllLoggedInUsersRequest(p, accountBlob):andThen(function(p2)
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
