local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Promise")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Dash")
local makeOmniRecommendationsRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/GraphQlShared").MakeOmniRecommendationsRequest

return function(p2, p3)
	return makeOmniRecommendationsRequest(p2, "Home", "0", nil, nil, nil, { (tostring(100000003)) }):andThen(function(p4)
		if p4.responseBody == nil then
			return Promise.reject("Response has no body.")
		end

		local sorts = p4.responseBody.sorts

		if not sorts then
			return Promise.reject("Response has no sorts.")
		end

		local v5 = {}

		for k, sort in pairs(sorts) do
			if sort.topicId == 100000003 then
				v5 = sort.recommendationList

				if not v5 then
					return Promise.reject("No recommendation list found in sorts.")
				end

				break
			end
		end

		local count = #v5

		if not Dash.find(v5, function(p5): boolean
			return p5.contentId == game.GameId
		end) then
			count += 1
		end

		return Promise.resolve(count)
	end)
end
