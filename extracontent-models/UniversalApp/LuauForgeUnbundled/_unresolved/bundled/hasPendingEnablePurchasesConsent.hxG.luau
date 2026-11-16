local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/hxA")
local module2 = require("@luauforge/bundled/hxC")
local url = require("@luauforge/bundled/hxE").Url

local function decode(p2)
	local v5 = false

	for k, v7 in (typeof(p2) ~= "table" or typeof(p2.consents) ~= "table") and {} or p2.consents do
		local consentData = if typeof(v7) == "table" then v7.consentData else nil

		if
			typeof(consentData) == "table"
			and typeof(consentData.enablePurchases) == "string"
			and consentData.enablePurchases ~= ""
		then
			v5 = true
			break
		end
	end

	local nextCursor = if typeof(p2) == "table" then p2.nextCursor else nil

	if typeof(nextCursor) ~= "string" or nextCursor == "" then
		nextCursor = nil
	end

	return { hasEnablePurchasesConsent = v5, nextCursor = nextCursor }
end

local function fetchPage(p2, p3, p4)
	local v5 = `childUserId={p2}&consentStatus=Pending&consentType=UpdateUserSetting`

	if p3 then
		v5 ..= `&cursor={HttpService:UrlEncode(p3)}`
	end

	return module.asPromise(module.fetch({
		network = p4,
		method = "GET",
		url = `{url.APIS_URL}parental-controls-api/v1/parental-controls/consents?{v5}`,
		analyticsKey = "parental-controls-api.v1.consents",
		decode = decode,
		retry = false,
		headers = {}
	}))
end

local function hasPendingEnablePurchasesConsent(p2, p3)
	local function fromPage(p4, nextCursor)
		return fetchPage(p2, nextCursor, p3):andThen(function(p5)
			if p5.hasEnablePurchasesConsent then
				return true
			end

			if p5.nextCursor == nil or p4 >= 10 then
				return false
			end

			return fromPage(p4 + 1, p5.nextCursor)
		end)
	end
	local v5 = 1
	return fetchPage(p2, nil, p3):andThen(function(p4)
		if p4.hasEnablePurchasesConsent then
			return true
		end

		if p4.nextCursor == nil or v5 >= 10 then
			return false
		end

		return fromPage(v5 + 1, p4.nextCursor)
	end):catch(function()
		return module2.resolve(false)
	end)
end

return hasPendingEnablePurchasesConsent
