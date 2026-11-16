local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent

local Http = require(parent.Http)
local HttpRequest = require(parent.HttpRequest)
local Enums = require(EditProfile.Common.Enums)

local Url = Http.Url

local config = HttpRequest.config({
	requestFunction = function(p: string, p2, p3)
		return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end
})

local function fetchUsernameChangePrice(_: string)
	return config(string.format("%sv1/username/change/price", Url.AUTH_URL), Enums.RequestMethods.GET):andThen(function(p)
		local responseBody = p.responseBody

		return {
			priceInRobux = responseBody.priceInRobux,
			isFreeUsernameChange = responseBody.isFreeUsernameChange == true
		}
	end)
end

return fetchUsernameChangePrice
