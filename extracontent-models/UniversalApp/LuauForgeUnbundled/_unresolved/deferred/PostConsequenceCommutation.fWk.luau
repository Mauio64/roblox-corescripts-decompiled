local HttpService = game:GetService("HttpService")

local constants = require("@luauforge/deferred/fUP").Constants
local url = require("@luauforge/deferred/fWl").Url

local COMMUTATION_CATEGORIES = constants.COMMUTATION_CATEGORIES

local function PostConsequenceCommutation(callback)
	return callback(url.APIS_URL .. "moderation-appeal-service/v2/consequence-commutation", "POST", {
		postBody = HttpService:JSONEncode({ type = COMMUTATION_CATEGORIES.Educational })
	})
end

return PostConsequenceCommutation
