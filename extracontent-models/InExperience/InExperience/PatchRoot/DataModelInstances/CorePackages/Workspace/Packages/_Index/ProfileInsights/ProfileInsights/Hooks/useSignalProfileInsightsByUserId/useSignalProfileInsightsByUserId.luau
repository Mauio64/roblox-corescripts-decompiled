local ProfileInsights = script:FindFirstAncestor("ProfileInsights")
local ProfileInsightsParent = ProfileInsights.Parent
local ProfileInsightsStore = require(ProfileInsights["data-hydration"].ProfileInsightsStore)
local SignalsReact = require(ProfileInsightsParent.SignalsReact)
local React = require(ProfileInsightsParent.React)

local function useSignalProfileInsightsByUserId(t1: {[any]: any}) -- line: 14
	-- upvalues: ProfileInsightsStore (copy), SignalsReact (copy), React (copy)
	local v8 = ProfileInsightsStore(false).getProfileInsightsByUserId({
		userIds = { t1.userId },
		rankingStrategy = t1.rankingStrategy
	})
	local v9 = SignalsReact.useSignalState(v8(false).data.getProfileInsights)

	return React.useMemo(function() -- line: 21
		-- upvalues: v9 (copy), t1 (copy)
		for _, v11 in v9 do
			if v11.targetUserId == t1.userId then
				return v11
			end
		end

		return {}
	end, { v9 }), v8(false).status == "fetching"
end

return useSignalProfileInsightsByUserId
