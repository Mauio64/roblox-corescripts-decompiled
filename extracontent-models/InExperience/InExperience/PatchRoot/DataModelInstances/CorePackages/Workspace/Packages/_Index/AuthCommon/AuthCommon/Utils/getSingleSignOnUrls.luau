local parent = script:FindFirstAncestor("AuthCommon").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local function getSingleSignOnUrls(p)
	local v = p or getAppFeaturePolicies()

	local urlAuthRoutes = v.getUrlAuthRoutes()
	local singleSignOnUrls = {}

	local linkedAuthEndpointsEnabled = v.getLinkedAuthEndpointsEnabled()

	if urlAuthRoutes.account then
		singleSignOnUrls.account = urlBuilder.fromString("auth" .. ":" .. urlAuthRoutes.account)
	end

	if linkedAuthEndpointsEnabled and urlAuthRoutes.linkedLogin then
		singleSignOnUrls.connect = urlBuilder.fromString("auth" .. ":" .. urlAuthRoutes.linkedLogin)
	elseif urlAuthRoutes.connect then
		singleSignOnUrls.connect = urlBuilder.fromString("auth" .. ":" .. urlAuthRoutes.connect)
	end

	if urlAuthRoutes.disconnect then
		singleSignOnUrls.disconnect = urlBuilder.fromString("auth" .. ":" .. urlAuthRoutes.disconnect)
	end

	if linkedAuthEndpointsEnabled and urlAuthRoutes.externalLogin then
		singleSignOnUrls.login = urlBuilder.fromString("auth" .. ":" .. urlAuthRoutes.externalLogin)
	elseif urlAuthRoutes.login then
		singleSignOnUrls.login = urlBuilder.fromString("auth" .. ":" .. urlAuthRoutes.login)
	end

	if linkedAuthEndpointsEnabled and urlAuthRoutes.linkedSignup then
		singleSignOnUrls.signup = urlBuilder.fromString("auth" .. ":" .. urlAuthRoutes.linkedSignup)
	elseif urlAuthRoutes.signup then
		singleSignOnUrls.signup = urlBuilder.fromString("auth" .. ":" .. urlAuthRoutes.signup)
	end

	if linkedAuthEndpointsEnabled then
		singleSignOnUrls.linkingPlatform = v.getLinkingPlatform()
	end

	return singleSignOnUrls
end

return getSingleSignOnUrls
