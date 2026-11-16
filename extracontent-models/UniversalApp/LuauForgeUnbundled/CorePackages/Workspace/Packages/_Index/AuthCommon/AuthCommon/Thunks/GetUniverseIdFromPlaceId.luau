local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url

return function(callback, p2)
	return callback(string.format("%suniverses/v1/places/%d/universe", url.APIS_URL, p2), "GET"):andThen(function(p3)
		if p3 and p3.responseBody and p3.responseBody.universeId then
			return p3.responseBody.universeId
		end

		error("Failed to get universeId from placeId: " .. tostring(p2))
	end)
end
