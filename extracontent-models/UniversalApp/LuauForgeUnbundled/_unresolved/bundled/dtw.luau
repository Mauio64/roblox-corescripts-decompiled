local module = require("@luauforge/bundled/dqV")

return function(p2, data)
	return data.type == module.name
		and {
			upsellCardType = data.upsellCardType,
			titleTextOverride = data.titleTextOverride,
			bodyTextOverride = data.bodyTextOverride,
			upsellCardV2Config = data.upsellCardV2Config
		}
		or p2
		or {
			upsellCardType = "",
			titleTextOverride = "",
			bodyTextOverride = "",
			upsellCardV2Config = nil
		}
end
