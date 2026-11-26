local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Http")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/HttpRequest")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Enums")

local url = Http.Url

local config = HttpRequest.config({
	requestFunction = function(p2, p3, p4)
		return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
	end
})

local function fetchUsernameChangePrice(p2)
	return config(string.format("%sv1/username/change/price", url.AUTH_URL), Enums.RequestMethods.GET):andThen(function(p3)
		local responseBody = p3.responseBody

		return {
			priceInRobux = responseBody.priceInRobux,
			isFreeUsernameChange = responseBody.isFreeUsernameChange == true
		}
	end)
end

return fetchUsernameChangePrice
