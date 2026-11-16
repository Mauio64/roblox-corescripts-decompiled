local HttpService = game:GetService("HttpService")
local module = require("@luauforge/bundled/fCO")
local urlBuilder = require("@luauforge/bundled/fDq").UrlBuilder
local module2 = require("@luauforge/bundled/fDo")
local appStorageUtilities = module.Utils.AppStorageUtilities
local recordSignOut = module.Utils.recordSignOut
local module3 = require("@luauforge/bundled/fDr")

return function(callback, p2)
	local accountBlob = appStorageUtilities.getAccountBlob()

	if p2.user_id and accountBlob then
		local v5 = urlBuilder.fromString(module3.DeleteAccount)
		local jsonEncode = HttpService:JSONEncode({
			deleted_user_id = p2.user_id,
			encrypted_users_data_blob = accountBlob
		})

		return callback(v5(), "POST", { postBody = jsonEncode }):andThen(function(p3)
			if not (p3 and p3.responseBody and p3.responseBody.encrypted_users_data_blob) then
				return module2.reject()
			end

			appStorageUtilities.setAccountBlob(p3.responseBody.encrypted_users_data_blob)
			appStorageUtilities.flush()
			pcall(function()
				recordSignOut(p2)
			end)
			return module2.resolve(p3.responseBody)
		end):catch(function(p3)
			if p3.data then
				return module2.reject(p3.data.errorCode)
			end

			if p3.StatusCode then
				return module2.reject({ p3.StatusCode })
			end

			return module2.reject()
		end)
	end

	return module2.reject("invalid payload")
end
