local module = require("@luauforge/bundled/hxQ")
local centralOverlayType = require("@luauforge/bundled/hwj").CentralOverlayType
local module2 = require("@luauforge/bundled/hxA")
local url = require("@luauforge/bundled/hxE").Url

local function decodeEmail(p2)
	local emailAddress = if typeof(p2) == "table" then p2.emailAddress else nil

	if typeof(emailAddress) ~= "string" or emailAddress == "" then
		emailAddress = nil
	end

	return {
		emailAddress = emailAddress,
		verified = typeof(p2) == "table" and (p2.verified == true or p2.verified == "true")
	}
end

local function openEmailVerificationForPurchase(callback, p2)
	return module2.asPromise(module2.fetch({
		network = p2,
		method = "GET",
		url = `{url.ACCOUNT_SETTINGS_URL}v1/email`,
		analyticsKey = "accountsettings.v1.email",
		decode = decodeEmail,
		retry = false,
		headers = {}
	})):andThen(function(p3)
		if p3.verified then
			return
		end

		callback(module.Actions.SetCentralOverlay(centralOverlayType.EmailVerificationUpsellOverlay, {
			emailAddress = p3.emailAddress,
			origin = "purchaseWarning"
		}))
	end):catch(function() end)
end

return openEmailVerificationForPurchase
