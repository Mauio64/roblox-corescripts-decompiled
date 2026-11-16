local parent = script:FindFirstAncestor("AuthCommon").Parent
local Http = require(parent.Http)
local Url = Http.Url

return function(callback, p)
	return callback(string.format("%suniverses/v1/places/%d/universe", Url.APIS_URL, p), "GET"):andThen(function(p2)
		if p2 and p2.responseBody and p2.responseBody.universeId then
			return p2.responseBody.universeId
		end

		error("Failed to get universeId from placeId: " .. tostring(p))
	end)
end
