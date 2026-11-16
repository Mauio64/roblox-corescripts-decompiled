local module = require("@luauforge/bundled/ecV")
local module2 = require("@luauforge/bundled/fPj")
local module3 = require("@luauforge/bundled/fDx")
local module4 = require("@luauforge/bundled/fBn")

if game:DefineFastFlag("EnablePackageGetAccountsList1", false) then
	return require("@luauforge/bundled/fCJ").GetAccountsList
end

return function(p2, p3)
	if not module3 then
		return module.resolve()
	end

	return module2(p2, module3 and module4.getAccountBlob() or "", not p3):andThen(function(p4)
		if module3 then
			module4.setAccountBlob(p4.responseBody.encrypted_users_data_blob)
			module4.flush()
		end

		return module.resolve(p4.responseBody)
	end):catch(function(p4)
		if p4.data then
			return module.reject(p4.data.errorCode)
		end

		if p4.StatusCode then
			return module.reject({ p4.StatusCode })
		end

		return module.reject()
	end)
end
