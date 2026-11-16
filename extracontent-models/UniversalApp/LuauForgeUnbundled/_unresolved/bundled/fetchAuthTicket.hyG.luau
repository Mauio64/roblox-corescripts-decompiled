local module = require("@luauforge/bundled/hxA")
local url = require("@luauforge/bundled/hxE").Url

local function send(p2)
	local promise = module.asPromise(p2)

	if not module.FFlagHttpClientRetryExtensions then
		promise:finally(p2.dispose)
	end

	return promise
end

local function getClientAssertion(p2)
	local request = module.createRequest({
		networkImpl = p2,
		method = "GET",
		url = `{url.AUTH_URL}v1/client-assertion/`,
		analyticsKey = "auth.client-assertion",
		decode = module.decodeJson(function(p3)
			if typeof(p3) == "table" then
				return p3.clientAssertion
			end

			return nil
		end),
		headers = {}
	})
	local clientAssertion = module.asPromise(request)

	if not module.FFlagHttpClientRetryExtensions then
		clientAssertion:finally(request.dispose)
	end

	return clientAssertion
end

local function decodeTicket(p2)
	local v5, v6, v7 = module.decodeJson(function(): boolean
		return true
	end)(p2)

	if v6 ~= nil then
		return nil, v6, v7
	end

	local rbxauthenticationticket = if p2.headers then p2.headers["rbx-authentication-ticket"] else nil

	if typeof(rbxauthenticationticket) == "string" and rbxauthenticationticket ~= "" then
		return rbxauthenticationticket, nil, nil
	end

	return nil, "missing authentication ticket", p2.statusCode
end

local function fetchAuthTicket(p2)
	local v5 = p2 or module.createRequestInternalNetwork()
	return getClientAssertion(v5):catch(function(): nil
		return nil
	end):andThen(function(p3)
		local request = module.createRequest({
			networkImpl = v5,
			method = "POST",
			url = `{url.AUTH_URL}v1/authentication-ticket/`,
			body = { clientAssertion = p3 },
			analyticsKey = "auth.authentication-ticket",
			decode = decodeTicket,
			headers = {}
		})
		local promise = module.asPromise(request)

		if not module.FFlagHttpClientRetryExtensions then
			promise:finally(request.dispose)
		end

		return promise
	end)
end

return fetchAuthTicket
