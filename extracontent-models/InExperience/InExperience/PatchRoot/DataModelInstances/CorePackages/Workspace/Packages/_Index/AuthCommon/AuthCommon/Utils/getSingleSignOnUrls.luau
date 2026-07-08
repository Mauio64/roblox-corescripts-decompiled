local Parent = script:FindFirstAncestor("AuthCommon").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local getAppFeaturePolicies = require(Parent.UniversalAppPolicy).getAppFeaturePolicies

local function getSingleSignOnUrls(p1) -- line: 26
	-- upvalues: getAppFeaturePolicies (copy), UrlBuilder (copy)
	local v6 = p1 or getAppFeaturePolicies()
	local v7 = v6.getUrlAuthRoutes()
	local t1 = {}
	local v9 = v6.getLinkedAuthEndpointsEnabled()

	if v7.account then
		t1.account = UrlBuilder.fromString("auth" .. ":" .. v7.account)
	end

	if v9 and v7.linkedLogin then
		t1.connect = UrlBuilder.fromString("auth" .. ":" .. v7.linkedLogin)
	elseif v7.connect then
		t1.connect = UrlBuilder.fromString("auth" .. ":" .. v7.connect)
	end

	if v7.disconnect then
		t1.disconnect = UrlBuilder.fromString("auth" .. ":" .. v7.disconnect)
	end

	if v9 and v7.externalLogin then
		t1.login = UrlBuilder.fromString("auth" .. ":" .. v7.externalLogin)
	elseif v7.login then
		t1.login = UrlBuilder.fromString("auth" .. ":" .. v7.login)
	end

	if v9 and v7.linkedSignup then
		t1.signup = UrlBuilder.fromString("auth" .. ":" .. v7.linkedSignup)
	elseif v7.signup then
		t1.signup = UrlBuilder.fromString("auth" .. ":" .. v7.signup)
	end

	if v9 then
		t1.linkingPlatform = v6.getLinkingPlatform()
	end

	return t1
end

return getSingleSignOnUrls
