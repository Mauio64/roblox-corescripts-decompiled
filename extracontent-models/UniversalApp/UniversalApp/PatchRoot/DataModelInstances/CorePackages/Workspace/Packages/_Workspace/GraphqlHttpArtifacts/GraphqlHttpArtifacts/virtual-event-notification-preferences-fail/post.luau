return {
	request = {
		body = "{\"isEnabled\":true}",
		method = "POST",
		cachePolicy = Enum.HttpCachePolicy.None,
		headers = {
			["content-type"] = "application/json",
			accept = "application/json"
		},
		url = {
			host = "apis.roblox.com",
			path = "/virtual-events/v1/notifications/preferences",
			scheme = "https",
			query = {}
		}
	},
	response = {
		body = "",
		isCached = false,
		type = "internal-response",
		headers = {
			["content-length"] = "0",
			["report-to"] = "{\"group\":\"network-errors\",\"max_age\":604800,\"endpoints\":[{\"url\":\"https://ncs.roblox.com/upload\"}]}",
			["strict-transport-security"] = "max-age=3600",
			["x-envoy-upstream-service-time"] = "30",
			date = "Tue, 28 Feb 2023 00:52:28 GMT",
			server = "envoy"
		},
		stats = {
			retried = false,
			durations = {
				SSLHandshake = 0,
				connect = 0,
				inQueue = 1.1888000003068555E-05,
				makeRequest = 6.9E-05,
				nameLookup = 4E-05,
				receiveResponse = 0.088885,
				roundTripTime = 0.08910791099999926
			}
		},
		status = {
			code = 404,
			message = "Not Found"
		}
	}
}
