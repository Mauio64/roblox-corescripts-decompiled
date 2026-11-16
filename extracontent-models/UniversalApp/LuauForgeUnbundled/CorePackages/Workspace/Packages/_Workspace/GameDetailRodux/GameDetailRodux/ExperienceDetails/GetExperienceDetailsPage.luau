local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/UrlBuilder").UrlBuilder.new({
	base = url.APIS_URL,
	path = "experience-details-api/v1/get-experience-details",
	query = { universeId = "{universeId}" }
})

return function(callback, value)
	assert(type(value) == "string", "GetExperienceDetailsPage request expects universeId to be a string")
	return callback(urlBuilder({ universeId = value }), "GET")
end
