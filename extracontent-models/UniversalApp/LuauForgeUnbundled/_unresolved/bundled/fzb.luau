local url = require("@luauforge/bundled/fzc").Url

return function(callback)
	return callback(
		string.format(
			"%saccount-security-service/v1/prompt-assignments?shouldReturnMetadata=true",
			url.APIS_URL
		),
		"GET"
	)
end
