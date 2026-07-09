local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local default = require(CorePackages.Workspace.Packages.CredentialsProtocol).CredentialsProtocol.default
local KeystoreConstants = require(CorePackages.Workspace.Packages.AuthCommon).Common.KeystoreConstants

return function(p1) -- line: 8
	-- upvalues: default (copy), KeystoreConstants (copy), Promise (copy)
	return default:isAvailable(default.CredentialsTypes.keystore, KeystoreConstants.KeystoreTimeout):andThen(function(p2) -- line: 12
		-- upvalues: default (copy), p1 (copy), KeystoreConstants (copy), Promise (copy)
		if p2 and (p2.keystore and p2.keystore.isAvailable) then
			return default:deleteAllCredentialsFromKeystore(default.CredentialsTypes.keystore, p1, KeystoreConstants.KeystoreTimeout)
		end

		return Promise.resolve(nil)
	end)
end
