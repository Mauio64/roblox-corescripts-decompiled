local HttpService = game:GetService("HttpService")

local url = require("@luauforge/bundled/hIR").Url

local function buildLoginRedirectUrl(data)
	local product = data.product
	local v5 = product.kind == "subscription"

	local v6 = {
		{ "analyticId", data.purchaseFlowUuid },
		{ "at", data.ticket },
		{ "ctx", v5 and "subscription" or "redirect" },
		{ "paymentSessionId", data.paymentSessionId },
		{ "returnUrl", "/upgrades/paymentmethods" },
		{ "tuid", (tostring(data.userId)) }
	}

	if v5 then
		table.insert(v6, { "type", "RobloxPlus" })
		table.insert(v6, { "id", product.productId })
	else
		table.insert(v6, { "ap", product.productId })
	end

	table.insert(v6, { "redirectStartTs", (tostring(data.startTimeMs)) })

	local v7 = {}

	for k, v8 in v6 do
		local v9 = v8[1]
		local v10 = v8[2]

		if v10 ~= nil then
			table.insert(v7, `{v9}={HttpService:UrlEncode(v10)}`)
		end
	end

	return `{url.WWW_URL}login-redirect?{table.concat(v7, "&")}`
end

return buildLoginRedirectUrl
