local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Promise = require(AuthCommonParent.Promise)
local LogoutAllLoggedInUsersRequest = require(AuthCommon.Http.Requests.LogoutAllLoggedInUsersRequest)
local GetLoggedInUsersMetadataRequest = require(AuthCommon.Http.Requests.GetLoggedInUsersMetadataRequest)
local FFlagEnableLuaAccountSwitch = require(AuthCommonParent.SharedFlags).FFlagEnableLuaAccountSwitch
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local recordSignOut = require(AuthCommon.Utils.recordSignOut)

local function recordSignOutOnLogoutAll(p1, p2) -- line: 11
	-- upvalues: GetLoggedInUsersMetadataRequest (copy), recordSignOut (copy)
	local v12, v13 = GetLoggedInUsersMetadataRequest(p1, p2):await()

	if v12 and (v13 and v13.responseBody and v13.responseBody.logged_in_users_metadata) then
		for _, v in ipairs(v13.responseBody.logged_in_users_metadata) do
			pcall(function() -- line: 15
				-- upvalues: recordSignOut (copy), v (copy)
				recordSignOut(v, true)
			end)
		end
	end
end

return function(p3, _: boolean) -- line: 22
	-- upvalues: FFlagEnableLuaAccountSwitch (copy), Promise (copy), AppStorageUtilities (copy), recordSignOutOnLogoutAll (copy), LogoutAllLoggedInUsersRequest (copy)
	if not FFlagEnableLuaAccountSwitch then
		return Promise.resolve()
	end

	local v18 = AppStorageUtilities.getAccountBlob()

	pcall(recordSignOutOnLogoutAll, p3, v18)
	AppStorageUtilities.setAccountBlob("")
	AppStorageUtilities.flush()

	return LogoutAllLoggedInUsersRequest(p3, v18):andThen(function(p4) -- line: 33
		-- upvalues: Promise (copy)
		return Promise.resolve(p4.responseBody)
	end):catch(function(p5) -- line: 35
		-- upvalues: Promise (copy)
		if p5.data then
			return Promise.reject(p5.data.errorCode)
		end

		if not p5.StatusCode then
			return Promise.reject()
		end

		return Promise.reject({ p5.StatusCode })
	end)
end
