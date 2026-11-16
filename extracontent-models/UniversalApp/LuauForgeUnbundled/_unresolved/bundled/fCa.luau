local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local default = require("@luauforge/bundled/fCb").CredentialsProtocol.default
local keystoreConstants = require("@game/CorePackages/Workspace/Packages/AuthCommon").Common.KeystoreConstants

return function(p2)
	return default:isAvailable(default.CredentialsTypes.keystore, keystoreConstants.KeystoreTimeout):andThen(function(p3)
		if p3 and p3.keystore and p3.keystore.isAvailable then
			return default:deleteAllCredentialsFromKeystore(
				default.CredentialsTypes.keystore,
				p2,
				keystoreConstants.KeystoreTimeout
			)
		end

		return Promise.resolve(nil)
	end)
end
