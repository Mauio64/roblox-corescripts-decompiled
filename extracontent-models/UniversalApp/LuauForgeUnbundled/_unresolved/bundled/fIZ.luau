local url = require("@luauforge/bundled/fJa").Url
require("@luauforge/bundled/fJa")

return {
	resolveReferralCode = function(callback, p2)
		local queryString = url:makeQueryString({ referralCode = p2 })

		return callback(
			string.format("%saffiliate-links/v1/links/resolve?%s", url.APIS_URL, queryString),
			"GET"
		)
	end
}
