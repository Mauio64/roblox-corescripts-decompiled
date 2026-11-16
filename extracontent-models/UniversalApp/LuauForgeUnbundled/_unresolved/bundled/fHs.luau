local module = require("@luauforge/bundled/fHt")
local url = require("@luauforge/bundled/fHu").Url
local getAppFeaturePolicies = require("@luauforge/bundled/fHv").getAppFeaturePolicies

local module2 = require("@luauforge/bundled/fHw")

local defineFastString = game:DefineFastString("ExternalIdentityGoogleProviderId", "1581220258196741")

local defineFastString2 = game:DefineFastString("ExternalIdentityAppleProviderId", "129176487952242")

local defineFastString3 = game:DefineFastString(
	"ExternalIdentityDesktopBrowserPostAuthenticationIntentId",
	"app-auth-ticket-deeplink-redirect"
)

local v5 = { google = defineFastString, apple = defineFastString2 }

local function send(p2)
	local promise = module.asPromise(p2)

	if not module.FFlagHttpClientRetryExtensions then
		promise:finally(p2.dispose)
	end

	return promise
end

local function appleUsesBrowserSignInPolicy()
	return getAppFeaturePolicies().getExternalIdentityAppleUsesBrowserSignIn()
end

local function create(p2, p3, data)
	local v6 = p2 or module.createRequestInternalNetwork()
	local v7 = p3 or url.AUTH_URL
	local v8

	if data and data.enableAppleBrowserSignIn ~= nil then
		v8 = data.enableAppleBrowserSignIn
	else
		v8 = module2
	end

	local appleUsesBrowserSignIn = data and data.appleUsesBrowserSignIn or appleUsesBrowserSignInPolicy

	local usesBrowserSignIn = data and data.usesBrowserSignIn

	return {
		requestNonce = function(p4)
			local request = module.createRequest({
				networkImpl = v6,
				method = "POST",
				url = `{v7}v1/external/{v5[p4]}/sso/native/nonce`,
				analyticsKey = `external-identity.{p4}.nonce`,
				decode = module.decodeJson(function(p5)
					return p5.nonce
				end)
			})
			local nonce = module.asPromise(request)

			if not module.FFlagHttpClientRetryExtensions then
				nonce:finally(request.dispose)
			end

			return nonce
		end,
		exchangeIdToken = function(p4)
			local request = module.createRequest({
				networkImpl = v6,
				method = "POST",
				url = `{v7}v1/external/access`,
				body = {
					authenticationProof = p4,
					identityProviderPlatformType = "Web",
					postAuthenticationIntentId = "app-auth-ticket"
				},
				analyticsKey = "external-identity.access",
				decode = function(p5)
					local v9, v10, v11 = module.decodeJson(function(): boolean
						return true
					end)(p5)

					if v10 ~= nil then
						return nil, v10, v11
					end

					local rbxauthenticationticket = if p5.headers then p5.headers["rbx-authentication-ticket"] else nil

					if rbxauthenticationticket then
						return rbxauthenticationticket, nil, nil
					end

					return nil, "missing authentication ticket", p5.statusCode
				end
			})
			local promise = module.asPromise(request)

			if not module.FFlagHttpClientRetryExtensions then
				promise:finally(request.dispose)
			end

			return promise
		end,
		browserStartUrl = function(p4)
			local v9 = not (usesBrowserSignIn == nil) and usesBrowserSignIn(p4)
			local v10

			if v9 then
				v10 = v9
			else
				v10 = v8

				if v10 then
					v10 = p4 == "apple" and appleUsesBrowserSignIn()
				end
			end

			if not v10 then
				return nil
			end

			return `{v7}v1/external/{v5[p4]}/sso/oauth/init?postAuthenticationIntentId={not v9 and "app-auth-ticket-deeplink-redirect" or defineFastString3}`
		end
	}
end

return { create = create, default = create(nil, nil) }
