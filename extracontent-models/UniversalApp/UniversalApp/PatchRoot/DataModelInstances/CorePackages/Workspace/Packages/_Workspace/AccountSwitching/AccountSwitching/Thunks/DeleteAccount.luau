local Parent = script:FindFirstAncestor("AccountSwitching").Parent
local HttpService = game:GetService("HttpService")
local AuthCommon = require(Parent.AuthCommon)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Promise = require(Parent.Promise)
local AppStorageUtilities = AuthCommon.Utils.AppStorageUtilities
local recordSignOut = AuthCommon.Utils.recordSignOut
local Paths = require(script.Parent.Paths)

return function(p1, t1: {[any]: any}) -- line: 17
	-- upvalues: AppStorageUtilities (copy), Promise (copy), UrlBuilder (copy), Paths (copy), HttpService (copy), recordSignOut (copy)
	local v11 = AppStorageUtilities.getAccountBlob()

	if not t1.user_id or not v11 then
		return Promise.reject("invalid payload")
	end

	local v12 = UrlBuilder.fromString(Paths.DeleteAccount)
	local json = HttpService:JSONEncode({
		deleted_user_id = t1.user_id,
		encrypted_users_data_blob = v11
	})

	return p1(v12(), "POST", {
		postBody = json
	}):andThen(function(p2) -- line: 28
		-- upvalues: AppStorageUtilities (copy), recordSignOut (copy), t1 (copy), Promise (copy)
		if p2 and (p2.responseBody and p2.responseBody.encrypted_users_data_blob) then
			AppStorageUtilities.setAccountBlob(p2.responseBody.encrypted_users_data_blob)
			AppStorageUtilities.flush()
			pcall(function() -- line: 32
				-- upvalues: recordSignOut (copy), t1 (copy)
				recordSignOut(t1)
			end)

			return Promise.resolve(p2.responseBody)
		end

		return Promise.reject()
	end):catch(function(p3) -- line: 39
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
