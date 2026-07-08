local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Url = require(Parent.Http).Url

return function(p1, p2) -- line: 5
	-- upvalues: Url (copy)
	return p1(string.format("%suniverses/v1/places/%d/universe", Url.APIS_URL, p2), "GET"):andThen(function(p3) -- line: 8
		-- upvalues: p2 (copy)
		if p3 and (p3.responseBody and p3.responseBody.universeId) then
			return p3.responseBody.universeId
		end

		error("Failed to get universeId from placeId: " .. tostring(p2))
	end)
end
