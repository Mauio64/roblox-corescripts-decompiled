local parent = script:FindFirstAncestor("Achievements").Parent

local Promise = require(parent.Promise)
local Dash = require(parent.Dash)
local GraphQlShared = require(parent.GraphQlShared)
local MakeOmniRecommendationsRequest = GraphQlShared.MakeOmniRecommendationsRequest

return function(p, _: number?)
	return MakeOmniRecommendationsRequest(p, "Home", "0", nil, nil, nil, { (tostring(100000003)) }):andThen(function(p2)
		if p2.responseBody == nil then
			return Promise.reject("Response has no body.")
		end

		local sorts = p2.responseBody.sorts

		if not sorts then
			return Promise.reject("Response has no sorts.")
		end

		local v = {}

		for _, sort in pairs(sorts) do
			if sort.topicId == 100000003 then
				v = sort.recommendationList

				if not v then
					return Promise.reject("No recommendation list found in sorts.")
				end

				break
			end
		end

		local count = #v

		if not Dash.find(v, function(p3): boolean
			return p3.contentId == game.GameId
		end) then
			count += 1
		end

		return Promise.resolve(count)
	end)
end
