local AccountSwitching = script:FindFirstAncestor("AccountSwitching")
local AccountSwitchingParent = AccountSwitching.Parent
local Promise = require(AccountSwitchingParent.Promise)
local GetLoggedInUsersMetadata = require(AccountSwitching.Thunks.GetLoggedInUsersMetadata)
local FFlagEnableLuaAccountSwitch = require(AccountSwitchingParent.SharedFlags).FFlagEnableLuaAccountSwitch
local AppStorageUtilities = require(AccountSwitchingParent.AuthCommon).Utils.AppStorageUtilities

return function(p1, b1: boolean) -- line: 8
	-- upvalues: FFlagEnableLuaAccountSwitch (copy), Promise (copy), AppStorageUtilities (copy), GetLoggedInUsersMetadata (copy)
	if not FFlagEnableLuaAccountSwitch then
		return Promise.resolve()
	end

	local v9 = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or ""

	return GetLoggedInUsersMetadata(p1, v9, not b1):andThen(function(p2) -- line: 14
		-- upvalues: FFlagEnableLuaAccountSwitch (copy), AppStorageUtilities (copy), Promise (copy)
		if FFlagEnableLuaAccountSwitch then
			AppStorageUtilities.setAccountBlob(p2.responseBody.encrypted_users_data_blob)
			AppStorageUtilities.flush()
		end

		return Promise.resolve(p2.responseBody)
	end):catch(function(p3) -- line: 20
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
