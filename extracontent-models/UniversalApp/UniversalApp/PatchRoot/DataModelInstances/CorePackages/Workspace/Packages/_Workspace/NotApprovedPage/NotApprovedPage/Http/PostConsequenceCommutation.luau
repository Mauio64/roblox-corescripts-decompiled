local Parent = script:FindFirstAncestor("NotApprovedPage").Parent
local HttpService = game:GetService("HttpService")
local Constants = require(Parent.NotApprovedPageShared).Constants
local Url = require(Parent.Http).Url
local COMMUTATION_CATEGORIES = Constants.COMMUTATION_CATEGORIES

local function PostConsequenceCommutation(p1) -- line: 15
	-- upvalues: Url (copy), HttpService (copy), COMMUTATION_CATEGORIES (copy)
	return p1(Url.APIS_URL .. "moderation-appeal-service/v2/consequence-commutation", "POST", {
		postBody = HttpService:JSONEncode({
			type = COMMUTATION_CATEGORIES.Educational
		})
	})
end

return PostConsequenceCommutation
