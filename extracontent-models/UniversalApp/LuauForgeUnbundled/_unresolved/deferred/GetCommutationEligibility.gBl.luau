local url = require("@luauforge/deferred/gBj").Url

local function GetCommutationEligibility(callback)
	return callback(
		url.APIS_URL .. "moderation-appeal-service/v2/consequence-commutation-eligibility",
		"GET"
	)
end

return GetCommutationEligibility
