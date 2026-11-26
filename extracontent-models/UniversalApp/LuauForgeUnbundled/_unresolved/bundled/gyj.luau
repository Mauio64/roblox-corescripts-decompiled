local module = require("@luauforge/bundled/dVn")

return function(callback, p2, list)
	return callback(
		string.format(
			"%sproduct-experimentation-platform/v1/projects/1/layers/%s/values?parameters=%s",
			module.APIS_URL,
			p2,
			table.concat(list, ",")
		),
		"GET",
		{ maxRetryCount = 0 }
	)
end
