local module = require("@luauforge/bundled/ghI")
local module2 = require("@luauforge/bundled/ghJ")
local fFlagEnableLuaAccountSwitch = require("@luauforge/bundled/ghC").FFlagEnableLuaAccountSwitch

local module3 = require("@luauforge/bundled/ghM")
local appStorageUtilities = require("@luauforge/bundled/ghh").Utils.AppStorageUtilities

return function(p2, p3, p4)
	if not fFlagEnableLuaAccountSwitch then
		return module.resolve()
	end

	return module2(
		p2,
		fFlagEnableLuaAccountSwitch and appStorageUtilities.getAccountBlob() or "",
		not p3,
		p4
	):andThen(function(p5)
		if fFlagEnableLuaAccountSwitch then
			local logged_in_users_metadata = p5.responseBody.logged_in_users_metadata

			if module3 and (logged_in_users_metadata == nil or #logged_in_users_metadata == 0) then
				appStorageUtilities.setAccountBlob("")
			else
				appStorageUtilities.setAccountBlob(p5.responseBody.encrypted_users_data_blob)
			end

			appStorageUtilities.flush()
		end

		return module.resolve(p5.responseBody)
	end):catch(function(p5)
		if p5.data then
			return module.reject(p5.data.errorCode)
		end

		if p5.StatusCode then
			return module.reject({ p5.StatusCode })
		end

		return module.reject()
	end)
end
