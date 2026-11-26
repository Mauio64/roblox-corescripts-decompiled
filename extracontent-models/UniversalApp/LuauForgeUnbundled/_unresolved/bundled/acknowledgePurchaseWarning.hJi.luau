local module = require("@luauforge/bundled/hIN")
local url = require("@luauforge/bundled/hIR").Url

local function acknowledgePurchaseWarning(p2, p3)
	return module.asPromise(module.fetch({
		network = p3,
		method = "POST",
		url = `{url.APIS_URL}purchase-warning/v1/purchase-warnings/acknowledge`,
		body = { acknowledgement = `Confirmed{p2}` },
		analyticsKey = "purchase-warning.v1.acknowledge",
		decode = function(): nil
			return nil
		end,
		retry = false,
		headers = {}
	}))
end

return acknowledgePurchaseWarning
