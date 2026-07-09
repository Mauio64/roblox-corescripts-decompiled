local Parent = script:FindFirstAncestor("GameDetailRodux").Parent
local Url = require(Parent.Http).Url
local v3 = require(Parent.UrlBuilder).UrlBuilder.new({
	path = "experience-details-api/v1/get-experience-details",
	base = Url.APIS_URL,
	query = {
		universeId = "{universeId}"
	}
})

return function(p1, p2) -- line: 23
	-- upvalues: v3 (copy)
	assert(type(p2) == "string", "GetExperienceDetailsPage request expects universeId to be a string")

	return p1(v3({
		universeId = p2
	}), "GET")
end
