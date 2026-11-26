local url = require("@luauforge/bundled/dJl").Url

return function(callback)
	return callback(string.format("%schallenge-dialog-service/v1/dialogs", url.APIS_URL), "GET")
end
