local url = require("@luauforge/bundled/hZn").Url
require("@luauforge/bundled/hZn")

return {
	resolveReferralCode = function(callback, p2)
		local queryString = url:makeQueryString({ referralCode = p2 })

		return callback(
			string.format("%saffiliate-links/v1/links/resolve?%s", url.APIS_URL, queryString),
			"GET"
		)
	end
}
