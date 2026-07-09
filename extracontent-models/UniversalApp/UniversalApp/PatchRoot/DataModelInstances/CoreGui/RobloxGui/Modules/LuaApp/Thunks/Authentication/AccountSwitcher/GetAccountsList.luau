local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local GetLoggedInUsersMetadata = require(Modules.LuaApp.Http.Requests.AccountSwitcher.GetLoggedInUsersMetadata)
local FFlagEnableLuaAccountSwitch = require(Modules.LuaApp.Flags.FFlagEnableLuaAccountSwitch)
local AppStorageUtilities = require(Modules.LuaApp.Thunks.Authentication.AppStorageUtilities)
local v6 = game:DefineFastFlag("EnablePackageGetAccountsList1", false)
local CorePackages = game:GetService("CorePackages")

if v6 then
	return require(CorePackages.Workspace.Packages.AccountSwitching).GetAccountsList
end

return function(p1, b1: boolean) -- line: 15
	-- upvalues: FFlagEnableLuaAccountSwitch (copy), Promise (copy), AppStorageUtilities (copy), GetLoggedInUsersMetadata (copy)
	if not FFlagEnableLuaAccountSwitch then
		return Promise.resolve()
	end

	local v10 = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or ""

	return GetLoggedInUsersMetadata(p1, v10, not b1):andThen(function(p2) -- line: 21
		-- upvalues: FFlagEnableLuaAccountSwitch (copy), AppStorageUtilities (copy), Promise (copy)
		if FFlagEnableLuaAccountSwitch then
			AppStorageUtilities.setAccountBlob(p2.responseBody.encrypted_users_data_blob)
			AppStorageUtilities.flush()
		end

		return Promise.resolve(p2.responseBody)
	end):catch(function(p3) -- line: 27
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
