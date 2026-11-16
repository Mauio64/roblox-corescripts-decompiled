local parent = script:FindFirstAncestor("GameDetailRodux").Parent

local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder.new({
	base = Url.APIS_URL,
	path = "experience-details-api/v1/get-experience-details",
	query = { universeId = "{universeId}" }
})

return function(callback, universeId)
	assert(type(universeId) == "string", "GetExperienceDetailsPage request expects universeId to be a string")
	return callback(urlBuilder({ universeId = universeId }), "GET")
end
