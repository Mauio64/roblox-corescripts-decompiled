local Parent = script:FindFirstAncestor("Achievements").Parent
local Promise = require(Parent.Promise)
local Dash = require(Parent.Dash)
local MakeOmniRecommendationsRequest = require(Parent.GraphQlShared).MakeOmniRecommendationsRequest

return function(p1, _: number?) -- line: 44
	-- upvalues: MakeOmniRecommendationsRequest (copy), Promise (copy), Dash (copy)
	return MakeOmniRecommendationsRequest(p1, "Home", "0", nil, nil, nil, { (tostring(100000003)) }):andThen(function(p2) -- line: 47
		-- upvalues: Promise (copy), Dash (copy)
		if p2.responseBody == nil then
			return Promise.reject("Response has no body.")
		end

		local sorts = p2.responseBody.sorts

		if not sorts then
			return Promise.reject("Response has no sorts.")
		end

		local t1 = {}

		for _, v in pairs(sorts) do
			if v.topicId == 100000003 then
				t1 = v.recommendationList

				if not t1 then
					return Promise.reject("No recommendation list found in sorts.")
				end

				break
			end
		end

		local v12 = #t1

		if not Dash.find(t1, function(p3) -- line: 73
			return p3.contentId == game.GameId
		end) then
			v12 += 1
		end

		return Promise.resolve(v12)
	end)
end
