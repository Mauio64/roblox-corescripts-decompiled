return {
	request = {
		method = "POST",
		cachePolicy = Enum.HttpCachePolicy.None,
		headers = {},
		url = {
			host = "apis.roblox.com",
			path = "/virtual-events/v1/notifications/modal-history",
			scheme = "https",
			query = {}
		}
	},
	response = {
		body = "{}",
		isCached = false,
		type = "internal-response",
		headers = {
			["content-length"] = "2",
			["content-type"] = "application/json; charset=utf-8",
			["strict-transport-security"] = "max-age=3600",
			["x-envoy-upstream-service-time"] = "85",
			date = "Fri, 24 Feb 2023 19:10:00 GMT",
			server = "envoy"
		},
		stats = {
			retried = false,
			durations = {
				SSLHandshake = 0,
				connect = 0,
				inQueue = 3.506900000260771E-05,
				makeRequest = 7.800000000000001E-05,
				nameLookup = 5.4E-05,
				receiveResponse = 0.111598,
				roundTripTime = 0.11186444599999845
			}
		},
		status = {
			code = 500,
			message = "Internal Server Error"
		}
	}
}
